/*
 * test_ipc_bypass_lsc.cpp
 * 
 * GPU A (Rank 0): 使用 bypass-cache LSC store 写入一个值
 * GPU B (Rank 1): 使用 bypass-cache LSC load 通过 IPC 映射读取该值
 *
 * 编译:
 *   I_MPI_CXX=icpx mpicxx -fsycl -fsycl-targets=spir64_gen -Xs "-device pvc" \
 *       -o test_ipc_bypass_lsc test_ipc_bypass_lsc.cpp -lze_loader
 *
 * 运行:
 *   mpirun -np 2 ./test_ipc_bypass_lsc
 */

#include <sycl/sycl.hpp>
#include <level_zero/ze_api.h>
#include <mpi.h>

#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <pwd.h>
#include <cstring>
#include <iostream>
#include <tuple>

#define ZE_CHECK(cmd) do {                             \
    ze_result_t e = cmd;                               \
    if (e != ZE_RESULT_SUCCESS) {                      \
        printf("L0 error %s:%d code=%d\n",             \
               __FILE__, __LINE__, e);                 \
        exit(EXIT_FAILURE);                            \
    }                                                  \
} while(0)

// ============================================================================
// Bypass-cache LSC load/store (L1 uncached, L3 uncached)
// ============================================================================

#ifdef __SYCL_DEVICE_ONLY__

inline int ld_uncached_global(const int* addr) {
    int result;
    asm volatile (
        "lsc_load.ugm.uc.uc (M1, 32) %0:d32 flat[%1]:a64"
        : "=rw"(result) : "rw"(addr)
    );
    return result;
}

inline int64_t ld_uncached_global(const int64_t* addr) {
    int64_t result;
    asm volatile (
        "lsc_load.ugm.uc.uc (M1, 32) %0:d64 flat[%1]:a64"
        : "=rw"(result) : "rw"(addr)
    );
    return result;
}

inline void st_uncached_global(int* addr, int value) {
    asm volatile (
        "lsc_store.ugm.uc.uc (M1, 32) flat[%0]:a64 %1:d32"
        : : "rw"(addr), "rw"(value) : "memory"
    );
}

inline void st_uncached_global(int64_t* addr, int64_t value) {
    asm volatile (
        "lsc_store.ugm.uc.uc (M1, 32) flat[%0]:a64 %1:d64"
        : : "rw"(addr), "rw"(value) : "memory"
    );
}

#else
inline int ld_uncached_global(const int* addr) { return *addr; }
inline int64_t ld_uncached_global(const int64_t* addr) { return *addr; }
inline void st_uncached_global(int* addr, int value) { *addr = value; }
inline void st_uncached_global(int64_t* addr, int64_t value) { *addr = value; }
#endif

// ============================================================================
// Unix socket helpers (传递 fd + offset)
// ============================================================================

struct exchange_fd {
    char obscure[CMSG_LEN(sizeof(int)) - sizeof(int)];
    int fd;
    exchange_fd(int level, int type, int fd) : fd(fd) {
        auto* cm = reinterpret_cast<cmsghdr*>(obscure);
        cm->cmsg_len = sizeof(exchange_fd);
        cm->cmsg_level = level;
        cm->cmsg_type = type;
    }
    exchange_fd() : fd(-1) { memset(obscure, 0, sizeof(obscure)); }
};

void send_fd(int sock, int fd, size_t offset) {
    iovec iov{&offset, sizeof(offset)};
    exchange_fd cmsg(SOL_SOCKET, SCM_RIGHTS, fd);
    msghdr msg{};
    msg.msg_iov = &iov;
    msg.msg_iovlen = 1;
    msg.msg_control = &cmsg;
    msg.msg_controllen = sizeof(exchange_fd);
    if (sendmsg(sock, &msg, 0) == -1) { perror("sendmsg"); exit(1); }
}

std::pair<int, size_t> recv_fd(int sock) {
    size_t offset;
    iovec iov{&offset, sizeof(offset)};
    exchange_fd cmsg;
    msghdr msg{};
    msg.msg_iov = &iov;
    msg.msg_iovlen = 1;
    msg.msg_control = &cmsg;
    msg.msg_controllen = sizeof(exchange_fd);
    if (recvmsg(sock, &msg, 0) == -1) { perror("recvmsg"); exit(1); }
    return {cmsg.fd, offset};
}

int create_server(const char* name) {
    unlink(name);
    sockaddr_un addr{};
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, name, sizeof(addr.sun_path) - 1);
    int s = socket(AF_UNIX, SOCK_STREAM, 0);
    bind(s, (sockaddr*)&addr, offsetof(sockaddr_un, sun_path) + strlen(addr.sun_path));
    listen(s, 2);
    return s;
}

int connect_to(const char* name) {
    sockaddr_un addr{};
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, name, sizeof(addr.sun_path) - 1);
    int s = socket(AF_UNIX, SOCK_STREAM, 0);
    auto len = offsetof(sockaddr_un, sun_path) + strlen(addr.sun_path);
    for (int i = 0; i < 50; i++) {
        if (connect(s, (sockaddr*)&addr, len) == 0) return s;
        usleep(100000);
    }
    perror("connect"); exit(1);
}

// ============================================================================
// SYCL queue 创建
// ============================================================================

static sycl::queue create_queue(int local_rank) {
    for (const auto& p : sycl::platform::get_platforms()) {
        if (p.get_backend() == sycl::backend::ext_oneapi_level_zero) {
            return sycl::queue(p.get_devices()[local_rank],
                               {sycl::property::queue::in_order{}});
        }
    }
    throw std::runtime_error("Level-Zero platform not found");
}

// ============================================================================
// Kernels — 使用 bypass-cache LSC 指令
// ============================================================================

// GPU A: 使用 uncached store 将 value 写入内存
class StoreKernel {
public:
    StoreKernel(int64_t* ptr, int64_t val) : ptr_(ptr), val_(val) {}
    void operator()(sycl::nd_item<1> item) const {
        if (item.get_local_id(0) == 0) {
            st_uncached_global(ptr_, val_);
        }
    }
private:
    int64_t* ptr_;
    int64_t val_;
};

// GPU B: while-loop uncached load 直到读到期望值 (模拟 CAS spin-wait)
class LoadKernel {
public:
    LoadKernel(const int64_t* src, int64_t* dst, int64_t expected, int64_t* spin_count)
        : src_(src), dst_(dst), expected_(expected), spin_count_(spin_count) {}
    void operator()(sycl::nd_item<1> item) const {
        if (item.get_local_id(0) == 0) {
            int64_t count = 0;
            int64_t val;
            // Spin-wait: 不断 bypass-cache load，直到读到期望值
            while ((val = ld_uncached_global(src_)) != expected_) {
                count++;
            }
            st_uncached_global(dst_, val);
            st_uncached_global(spin_count_, count);
        }
    }
private:
    const int64_t* src_;
    int64_t* dst_;
    int64_t expected_;
    int64_t* spin_count_;
};

// ============================================================================
// Main
// ============================================================================

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);
    int rank, world_size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);
    if (world_size != 2) {
        if (rank == 0) std::cerr << "Need exactly 2 ranks\n";
        MPI_Finalize(); return 1;
    }

    ZE_CHECK(zeInit(0));

    auto queue = create_queue(rank);
    auto l0_ctx = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_context());
    auto l0_dev = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_device());

    std::cout << "[Rank " << rank << "] Device: "
              << queue.get_device().get_info<sycl::info::device::name>() << std::endl;

    // ======== 分配设备内存 ========
    int64_t* local_buf = sycl::malloc_device<int64_t>(1, queue);
    queue.memset(local_buf, 0, sizeof(int64_t)).wait();

    // ======== 获取 IPC handle ========
    void* base_addr;
    size_t base_size;
    ZE_CHECK(zeMemGetAddressRange(l0_ctx, local_buf, &base_addr, &base_size));
    size_t offset = (char*)local_buf - (char*)base_addr;

    ze_ipc_mem_handle_t ipc_handle;
    ZE_CHECK(zeMemGetIpcHandle(l0_ctx, base_addr, &ipc_handle));
    int my_fd = *reinterpret_cast<int*>(&ipc_handle);

    // ======== Unix socket 交换 IPC handle ========
    auto pwd = getpwuid(getuid());
    char srv_name[128], remote_srv[128];
    snprintf(srv_name, sizeof(srv_name), "/tmp/ipc-bl-rank%d_%s", rank, pwd->pw_name);
    int remote_rank = 1 - rank;
    snprintf(remote_srv, sizeof(remote_srv), "/tmp/ipc-bl-rank%d_%s", remote_rank, pwd->pw_name);

    int server_sock = create_server(srv_name);
    MPI_Barrier(MPI_COMM_WORLD);

    int client_sock = connect_to(remote_srv);
    send_fd(client_sock, my_fd, offset);

    int accept_sock = accept(server_sock, nullptr, nullptr);
    auto [remote_fd, remote_offset] = recv_fd(accept_sock);

    ze_ipc_mem_handle_t remote_ipc;
    memset(&remote_ipc, 0, sizeof(remote_ipc));
    *reinterpret_cast<int*>(&remote_ipc) = remote_fd;

    void* remote_base;
    ZE_CHECK(zeMemOpenIpcHandle(l0_ctx, l0_dev, remote_ipc,
                                ZE_IPC_MEMORY_FLAG_BIAS_CACHED, &remote_base));
    int64_t* remote_ptr = (int64_t*)((char*)remote_base + remote_offset);

    std::cout << "[Rank " << rank << "] IPC mapping established. "
              << "local=" << local_buf << " remote=" << remote_ptr << std::endl;

    MPI_Barrier(MPI_COMM_WORLD);

    // ======== 测试: Rank 0 uncached store, Rank 1 uncached load ========
    constexpr int64_t MAGIC = 0xDEADBEEF42LL;

    if (rank == 1) {
        // Rank 1 先提交 while-load kernel（会在 GPU 上 spin 等待）
        int64_t* result_buf = sycl::malloc_device<int64_t>(1, queue);
        int64_t* spin_count = sycl::malloc_device<int64_t>(1, queue);
        queue.memset(result_buf, 0, sizeof(int64_t)).wait();
        queue.memset(spin_count, 0, sizeof(int64_t)).wait();

        std::cout << "[Rank 1] Submitting while-load kernel (spinning on remote memory)..." << std::endl;
        auto load_event = queue.submit([&](sycl::handler& h) {
            h.parallel_for(sycl::nd_range<1>(32, 32),
                           LoadKernel(remote_ptr, result_buf, MAGIC, spin_count));
        });

        // 通知 Rank 0 可以 store 了
        MPI_Barrier(MPI_COMM_WORLD);

        // 等待 kernel 完成
        load_event.wait();

        int64_t host_result = 0, host_spin = 0;
        queue.memcpy(&host_result, result_buf, sizeof(int64_t)).wait();
        queue.memcpy(&host_spin, spin_count, sizeof(int64_t)).wait();

        std::cout << "[Rank 1] While-load completed!" << std::endl;
        std::cout << "[Rank 1] Spin count: " << host_spin << " iterations" << std::endl;
        std::cout << "[Rank 1] Loaded value: " << host_result
                  << " (expected: " << MAGIC << ")" << std::endl;

        if (host_result == MAGIC) {
            std::cout << "[Rank 1] PASSED!" << std::endl;
        } else {
            std::cout << "[Rank 1] FAILED! Got " << host_result << std::endl;
        }

        sycl::free(result_buf, queue);
        sycl::free(spin_count, queue);

    } else {
        // Rank 0: 等 Rank 1 的 kernel 提交后再 store
        MPI_Barrier(MPI_COMM_WORLD);

        std::cout << "[Rank 0] Bypass-cache storing value: " << MAGIC << std::endl;
        queue.submit([&](sycl::handler& h) {
            h.parallel_for(sycl::nd_range<1>(32, 32), StoreKernel(local_buf, MAGIC));
        }).wait();
        std::cout << "[Rank 0] Uncached store done." << std::endl;
    }

    // ======== 清理 ========
    MPI_Barrier(MPI_COMM_WORLD);
    ZE_CHECK(zeMemCloseIpcHandle(l0_ctx, remote_base));
    sycl::free(local_buf, queue);
    close(accept_sock);
    close(client_sock);
    close(server_sock);
    unlink(srv_name);

    if (rank == 0) {
        std::cout << "\n=== Test completed ===" << std::endl;
    }

    MPI_Finalize();
    return 0;
}

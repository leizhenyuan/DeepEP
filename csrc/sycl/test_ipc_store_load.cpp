/*
 * test_ipc_store_load.cpp
 * 
 * GPU A (Rank 0): 在设备内存中 store 一个值
 * GPU B (Rank 1): 通过 IPC 映射读取该值
 *
 * 编译:
 *   I_MPI_CXX=icpx mpicxx -fsycl -fsycl-targets=spir64_gen -Xs "-device pvc" \
 *       -o test_ipc_store_load test_ipc_store_load.cpp -lze_loader
 *
 * 运行:
 *   mpirun -np 2 ./test_ipc_store_load
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
// Kernels
// ============================================================================

// GPU A: 将 value 写入 shared 内存
class StoreKernel {
public:
    StoreKernel(int64_t* ptr, int64_t val) : ptr_(ptr), val_(val) {}
    void operator()(sycl::nd_item<1> item) const {
        if (item.get_local_id(0) == 0) {
            *ptr_ = val_;
        }
    }
private:
    int64_t* ptr_;
    int64_t val_;
};

// GPU B: 从 remote 内存读取值到 result
class LoadKernel {
public:
    LoadKernel(const int64_t* src, int64_t* dst) : src_(src), dst_(dst) {}
    void operator()(sycl::nd_item<1> item) const {
        if (item.get_local_id(0) == 0) {
            *dst_ = *src_;
        }
    }
private:
    const int64_t* src_;
    int64_t* dst_;
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
    // Rank 0 分配: 用于 store 的 buffer（1 个 int64）
    // Rank 1 分配: 用于存放 load 结果的 buffer
    int64_t* local_buf = sycl::malloc_device<int64_t>(1, queue);
    queue.memset(local_buf, 0, sizeof(int64_t)).wait();

    // ======== 获取 IPC handle (只有 Rank 0 需要共享) ========
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
    snprintf(srv_name, sizeof(srv_name), "/tmp/ipc-sl-rank%d_%s", rank, pwd->pw_name);
    int remote_rank = 1 - rank;
    snprintf(remote_srv, sizeof(remote_srv), "/tmp/ipc-sl-rank%d_%s", remote_rank, pwd->pw_name);

    int server_sock = create_server(srv_name);
    MPI_Barrier(MPI_COMM_WORLD);

    // 双向交换: 每个 rank 都把自己的 fd+offset 发给对方
    int client_sock = connect_to(remote_srv);
    send_fd(client_sock, my_fd, offset);

    int accept_sock = accept(server_sock, nullptr, nullptr);
    auto [remote_fd, remote_offset] = recv_fd(accept_sock);

    // 打开远程 IPC handle
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

    // ======== 测试: Rank 0 store, Rank 1 load ========
    constexpr int64_t MAGIC = 0xDEADBEEF42LL;

    if (rank == 0) {
        // GPU A: store MAGIC 到本地 buffer (Rank 1 通过 IPC 映射可见)
        std::cout << "[Rank 0] Storing value: " << MAGIC << std::endl;
        queue.submit([&](sycl::handler& h) {
            h.parallel_for(sycl::nd_range<1>(32, 32), StoreKernel(local_buf, MAGIC));
        }).wait();
        std::cout << "[Rank 0] Store done." << std::endl;
    }

    // 确保 Rank 0 的 store 完成后 Rank 1 再 load
    MPI_Barrier(MPI_COMM_WORLD);

    if (rank == 1) {
        // GPU B: 从 remote_ptr (指向 Rank 0 的设备内存) load 值
        int64_t* result_buf = sycl::malloc_device<int64_t>(1, queue);
        queue.memset(result_buf, 0, sizeof(int64_t)).wait();

        std::cout << "[Rank 1] Loading value from Rank 0's memory..." << std::endl;
        queue.submit([&](sycl::handler& h) {
            h.parallel_for(sycl::nd_range<1>(32, 32), LoadKernel(remote_ptr, result_buf));
        }).wait();

        // 拷回 host 检查结果
        int64_t host_result = 0;
        queue.memcpy(&host_result, result_buf, sizeof(int64_t)).wait();

        std::cout << "[Rank 1] Loaded value: " << host_result
                  << " (expected: " << MAGIC << ")" << std::endl;

        if (host_result == MAGIC) {
            std::cout << "[Rank 1] PASSED!" << std::endl;
        } else {
            std::cout << "[Rank 1] FAILED! Got " << host_result << std::endl;
        }

        sycl::free(result_buf, queue);
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

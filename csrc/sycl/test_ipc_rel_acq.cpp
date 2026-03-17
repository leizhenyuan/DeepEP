/*
 * test_ipc_rel_acq.cpp
 *
 * 完整的 acquire-release 范式测试:
 *   GPU A: cached store data → fence(evict+sysrel) → bypass-cache store flag
 *   GPU B: bypass-cache while-load flag → fence(invalidate+sysacq) → cached load data
 *
 * 编译:
 *   I_MPI_CXX=icpx mpicxx -fsycl -fsycl-targets=spir64_gen -Xs "-device pvc" \
 *       -o test_ipc_rel_acq test_ipc_rel_acq.cpp -lze_loader
 *
 * 运行:
 *   mpirun -np 2 ./test_ipc_rel_acq
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


#ifdef __SYCL_DEVICE_ONLY__

inline int64_t ld_uncached_global(const int64_t* addr) {
    int64_t result;
    asm volatile (
        "lsc_load.ugm.uc.uc (M1, 32) %0:d64 flat[%1]:a64"
        : "=rw"(result) : "rw"(addr)
    );
    return result;
}

inline void st_uncached_global(int64_t* addr, int64_t value) {
    asm volatile (
        "lsc_store.ugm.uc.uc (M1, 32) flat[%0]:a64 %1:d64"
        : : "rw"(addr), "rw"(value) : "memory"
    );
}

inline void fence_release() {
    asm volatile ("lsc_fence.ugm.evict.sysrel\n" ::: "memory");
}

inline void fence_acquire() {
    asm volatile ("lsc_fence.ugm.invalidate.sysacq\n" ::: "memory");
}

#else
inline int64_t ld_uncached_global(const int64_t* addr) { return *addr; }
inline void st_uncached_global(int64_t* addr, int64_t value) { *addr = value; }
inline void fence_release() {}
inline void fence_acquire() {}
#endif

struct SharedBuffer {
    int64_t flag;                           // 同步标志 (bypass-cache 访问)
    char padding[128 - sizeof(int64_t)];    // 隔离到不同缓存行
    static constexpr int DATA_SIZE = 1024;
    int64_t data[DATA_SIZE];                // 数据区域 (cached 访问)
};

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

static sycl::queue create_queue(int local_rank) {
    for (const auto& p : sycl::platform::get_platforms()) {
        if (p.get_backend() == sycl::backend::ext_oneapi_level_zero) {
            return sycl::queue(p.get_devices()[local_rank],
                               {sycl::property::queue::in_order{}});
        }
    }
    throw std::runtime_error("Level-Zero platform not found");
}

class WriterKernel {
public:
    WriterKernel(SharedBuffer* buf, int64_t magic) : buf_(buf), magic_(magic) {}
    void operator()(sycl::nd_item<1> item) const {
        if (item.get_local_id(0) == 0) {
            for (int i = 0; i < SharedBuffer::DATA_SIZE; i++) {
                buf_->data[i] = magic_ + i;
            }

            fence_release();

            st_uncached_global(&buf_->flag, static_cast<int64_t>(1));
        }
    }
private:
    SharedBuffer* buf_;
    int64_t magic_;
};

class ReaderKernel {
public:
    ReaderKernel(SharedBuffer* buf, int64_t magic, int* error_count, int64_t* spin_count)
        : buf_(buf), magic_(magic), error_count_(error_count), spin_count_(spin_count) {}
    void operator()(sycl::nd_item<1> item) const {
        if (item.get_local_id(0) == 0) {
            int64_t spins = 0;
            while (ld_uncached_global(&buf_->flag) != 1) {
                spins++;
            }
            st_uncached_global(spin_count_, spins);

            fence_acquire();

            int errors = 0;
            for (int i = 0; i < SharedBuffer::DATA_SIZE; i++) {
                int64_t val = buf_->data[i];
                if (val != magic_ + i) {
                    errors++;
                }
            }
            *error_count_ = errors;
        }
    }
private:
    SharedBuffer* buf_;
    int64_t magic_;
    int* error_count_;
    int64_t* spin_count_;
};

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

    SharedBuffer* local_buf = sycl::malloc_device<SharedBuffer>(1, queue);
    queue.memset(local_buf, 0, sizeof(SharedBuffer)).wait();

    void* base_addr;
    size_t base_size;
    ZE_CHECK(zeMemGetAddressRange(l0_ctx, local_buf, &base_addr, &base_size));
    size_t offset = (char*)local_buf - (char*)base_addr;

    ze_ipc_mem_handle_t ipc_handle;
    ZE_CHECK(zeMemGetIpcHandle(l0_ctx, base_addr, &ipc_handle));
    int my_fd = *reinterpret_cast<int*>(&ipc_handle);

    auto pwd = getpwuid(getuid());
    char srv_name[128], remote_srv[128];
    snprintf(srv_name, sizeof(srv_name), "/tmp/ipc-ra-rank%d_%s", rank, pwd->pw_name);
    int remote_rank = 1 - rank;
    snprintf(remote_srv, sizeof(remote_srv), "/tmp/ipc-ra-rank%d_%s", remote_rank, pwd->pw_name);

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
    SharedBuffer* remote_buf = (SharedBuffer*)((char*)remote_base + remote_offset);

    std::cout << "[Rank " << rank << "] IPC mapping established." << std::endl;

    MPI_Barrier(MPI_COMM_WORLD);

    constexpr int64_t MAGIC = 0xCAFEBABE00LL;

    // 强行让读方先提交 kernel 并进入自旋，等待写方
    // 验证while by pass load的有效性
    if (rank == 1) {
        int* error_count = sycl::malloc_device<int>(1, queue);
        int64_t* spin_count = sycl::malloc_device<int64_t>(1, queue);
        queue.memset(error_count, 0, sizeof(int)).wait();
        queue.memset(spin_count, 0, sizeof(int64_t)).wait();

        std::cout << "[Rank 1] Reader kernel submitted, spinning on flag..." << std::endl;
        auto reader_event = queue.submit([&](sycl::handler& h) {
            h.parallel_for(sycl::nd_range<1>(32, 32),
                           ReaderKernel(remote_buf, MAGIC, error_count, spin_count));
        });

        // 通知 Rank 0 可以开始写了
        MPI_Barrier(MPI_COMM_WORLD);

        reader_event.wait();

        int host_errors = 0;
        int64_t host_spins = 0;
        queue.memcpy(&host_errors, error_count, sizeof(int)).wait();
        queue.memcpy(&host_spins, spin_count, sizeof(int64_t)).wait();

        std::cout << "[Rank 1] Flag detected after " << host_spins << " spins" << std::endl;
        std::cout << "[Rank 1] Data verification: "
                  << SharedBuffer::DATA_SIZE - host_errors << "/"
                  << SharedBuffer::DATA_SIZE << " correct" << std::endl;

        if (host_errors == 0) {
            std::cout << "[Rank 1] PASSED!" << std::endl;
        } else {
            std::cout << "[Rank 1] FAILED! " << host_errors << " data errors" << std::endl;
        }

        sycl::free(error_count, queue);
        sycl::free(spin_count, queue);

    } else {
        // Rank 0: 等 Rank 1 的 reader kernel 提交后再写
        MPI_Barrier(MPI_COMM_WORLD);

        std::cout << "[Rank 0] Writing " << SharedBuffer::DATA_SIZE
                  << " elements + setting flag..." << std::endl;
        queue.submit([&](sycl::handler& h) {
            h.parallel_for(sycl::nd_range<1>(32, 32),
                           WriterKernel(local_buf, MAGIC));
        }).wait();
        std::cout << "[Rank 0] Writer done (data + fence + flag)." << std::endl;
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
        std::cout << "\n=== Acquire-Release test completed ===" << std::endl;
    }

    MPI_Finalize();
    return 0;
}

// test_nbarrier_crash.cpp — minimal reproducer for IGC named_barrier_init crash
//
// Build (JIT):
//   icpx -std=c++17 -fsycl -D__SYCL_INTERNAL_API -fsycl-targets=spir64 \
//        -L/data/model/zhenyuan/old/compiler/2025.2/lib \
//        -Wl,-rpath,/data/model/zhenyuan/old/compiler/2025.2/lib \
//        -I ~/zhenyuan/tvisa/include \
//        test_nbarrier_crash.cpp -o test_nbarrier_crash
//
// Run with IGC debug:
//   IGC_ShaderDumpEnable=1 IGC_DumpToCurrentDir=1 ./test_nbarrier_crash

#include <sycl/sycl.hpp>
#include <cstdio>

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
#include "lsc.hpp"
#include "regmap.hpp"
#include "gateway.hpp"
#endif

constexpr int SG_SZ = 16;

struct MinimalNBarrierKernel {
    int* data;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        named_barrier_init<1>();
        nbarrier_signal(1, 2);
        nbarrier_wait(1);
#endif
        data[item.get_local_id(0)] = 42;
    }
};

int main() {
    sycl::queue q{sycl::gpu_selector_v};
    printf("Device: %s\n", q.get_device().get_info<sycl::info::device::name>().c_str());

    int* buf = sycl::malloc_device<int>(32, q);
    try {
        q.submit([&](sycl::handler& h) {
            h.parallel_for(sycl::nd_range<1>{32, 32}, MinimalNBarrierKernel{buf});
        }).wait_and_throw();
        printf("PASS\n");
    } catch (const sycl::exception& e) {
        printf("SYCL exception: %s\n", e.what());
    } catch (const std::exception& e) {
        printf("std exception: %s\n", e.what());
    }
    sycl::free(buf, q);
    return 0;
}

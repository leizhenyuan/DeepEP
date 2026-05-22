// test_nbarrier_fix3.cpp — use full OpenCL named barrier API (both init + barrier)
//
// Instead of raw asm nbarrier.signal/wait, use the OpenCL named barrier API:
//   named_barrier_init(subgroupCount) → __namedBarrier*
//   work_group_named_barrier(nb, flags) → sync
//
// IGC's NamedBarriersResolution HW path replaces these with:
//   GenISA_threadgroupnamedbarriers_signal + GenISA_threadgroupnamedbarriers_wait
//
// Build:
//   icpx -std=c++17 -fsycl -D__SYCL_INTERNAL_API -fsycl-targets=spir64 \
//        -I ~/zhenyuan/tvisa/include \
//        test_nbarrier_fix3.cpp -o test_nbarrier_fix3

#include <sycl/sycl.hpp>
#include <cstdio>

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
// ── OpenCL named barrier declarations matching IGC expectations ──────────
struct __namedBarrier;

extern SYCL_EXTERNAL __namedBarrier __attribute__((opencl_local)) *
named_barrier_init(int count);

extern SYCL_EXTERNAL void work_group_named_barrier(
    __namedBarrier __attribute__((opencl_local)) *, unsigned int);

// Keep lsc.hpp for cache control if needed
#include "lsc.hpp"
#include "regmap.hpp"
#endif

constexpr int SG_SZ = 16;
constexpr int N_SG  = 4;
constexpr int WG_SZ = SG_SZ * N_SG;

// OpenCL mem fence flags
#define CLK_LOCAL_MEM_FENCE  1
#define CLK_GLOBAL_MEM_FENCE 2

// ── T1: OpenCL named barrier API (init + barrier) ────────────────────────
struct NBarrierKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        // Allocate a named barrier with N_SG sub-group participants
        auto* nb = named_barrier_init(N_SG);
#endif

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        // Named barrier sync — IGC HW path converts to nbarrier.signal/wait
        work_group_named_barrier(nb, CLK_LOCAL_MEM_FENCE);
#else
        sycl::group_barrier(item.get_group());
#endif

        if (lane == 0) {
            int sum = 0;
            for (int i = 0; i < N_SG; ++i) sum += slm[i];
            out[sg_id] = sum;
        }
    }
};

// ── T2: baseline full-WG barrier ─────────────────────────────────────────
struct BaselineKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];
        sycl::group_barrier(item.get_group());

        if (lane == 0) {
            int sum = 0;
            for (int i = 0; i < N_SG; ++i) sum += slm[i];
            out[sg_id] = sum;
        }
    }
};

// ── Test runner ──────────────────────────────────────────────────────────
template <typename Kernel>
bool run_test(sycl::queue& q, const char* label) {
    int* in  = sycl::malloc_shared<int>(N_SG, q);
    int* out = sycl::malloc_shared<int>(N_SG, q);
    int expected = 0;
    for (int i = 0; i < N_SG; ++i) { in[i] = (i + 1) * 10; expected += in[i]; }
    std::fill_n(out, N_SG, -1);

    try {
        q.submit([&](sycl::handler& h) {
            sycl::local_accessor<int, 1> slm(N_SG, h);
            h.parallel_for(sycl::nd_range<1>{WG_SZ, WG_SZ}, Kernel{in, out, slm});
        }).wait_and_throw();
    } catch (const sycl::exception& e) {
        printf("[%s] SYCL exception: %s\n", label, e.what());
        sycl::free(in, q); sycl::free(out, q);
        return false;
    }

    bool pass = true;
    for (int i = 0; i < N_SG; ++i) {
        if (out[i] != expected) {
            printf("[%s] FAIL: sg %d expected %d got %d\n", label, i, expected, out[i]);
            pass = false;
        }
    }
    if (pass) printf("[%s] PASS\n", label);
    sycl::free(in, q); sycl::free(out, q);
    return pass;
}

int main(int argc, char* argv[]) {
    int which = (argc > 1) ? atoi(argv[1]) : 0;

    sycl::queue q{sycl::gpu_selector_v};
    printf("Device: %s\n\n", q.get_device().get_info<sycl::info::device::name>().c_str());

    int passed = 0, total = 0;

    if (which == 0 || which == 1) {
        printf("=== T1: OpenCL named barrier (init + work_group_named_barrier) ===\n");
        ++total; if (run_test<NBarrierKernel>(q, "T1")) ++passed;
    }

    if (which == 0 || which == 2) {
        printf("=== T2: baseline SYCL barrier ===\n");
        ++total; if (run_test<BaselineKernel>(q, "T2")) ++passed;
    }

    printf("\nResults: %d/%d passed\n", passed, total);
    return passed == total ? 0 : 1;
}

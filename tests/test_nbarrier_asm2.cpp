// test_nbarrier_asm2.cpp — asm nbarrier at convergence point (not inside divergent branches)
//
// Key insight: nbarrier.signal must be at a convergence point where
// ALL lanes execute the same path, otherwise SIMD divergent branches
// cause double-signaling.
//
// Build:
//   icpx -std=c++17 -fsycl -D__SYCL_INTERNAL_API -fsycl-targets=spir64 \
//        -I ~/zhenyuan/tvisa/include test_nbarrier_asm2.cpp -o test_nbarrier_asm2

#include <sycl/sycl.hpp>
#include <cstdio>

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
#include "lsc.hpp"
#include "regmap.hpp"

// Correct declarations for IGC (sets NBarrierCnt)
struct __namedBarrier;
extern SYCL_EXTERNAL __namedBarrier __attribute__((opencl_local)) *
named_barrier_init(int count);
extern SYCL_EXTERNAL void work_group_named_barrier(
    __namedBarrier __attribute__((opencl_local)) *, unsigned int);
#endif

constexpr int SG_SZ = 16;
constexpr int N_SG  = 4;
constexpr int WG_SZ = SG_SZ * N_SG;

// T1: IGC init + asm signal/wait at convergence point
// The key: SLM write is lane-predicated, but barrier code is UNIFORM (all lanes)
struct AsmConvergentKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        // Call named_barrier_init for IGC to set NBarrierCnt
        // Also need work_group_named_barrier declared (otherwise IGC crashes)
        // Use it for the actual barrier — it generates optimal asm anyway
        auto* nb = named_barrier_init(N_SG);

        // --- Phase 1: write to SLM (only lane 0 per sub-group) ---
        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];

        // --- Barrier: at convergence point, all lanes uniform ---
        // Use work_group_named_barrier — generates nbarrier.signal + nbarrier.wait
        work_group_named_barrier(nb, 0x1 /*CLK_LOCAL_MEM_FENCE*/);

        // --- Phase 2: read from SLM ---
        if (lane == 0) {
            int sum = 0;
            for (int i = 0; i < N_SG; ++i) sum += slm[i];
            out[sg_id] = sum;
        }
#else
        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];
        sycl::group_barrier(item.get_group());
        if (lane == 0) {
            int sum = 0;
            for (int i = 0; i < N_SG; ++i) sum += slm[i];
            out[sg_id] = sum;
        }
#endif
    }
};

// T2: Can we use asm nbarrier at a convergence point if we manually ensure it?
// Put the barrier AFTER the if-block, so all lanes hit it at the same point.
struct AsmManualConvergeKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        auto* nb = named_barrier_init(N_SG);
        (void)nb;  // just for NBarrierCnt

        // Phase 1: lane-predicated SLM write
        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];

        // Explicit convergence point — use asm fence + signal + wait
        // This MUST be outside any if-block so compiler doesn't put it inside branches
        asm volatile("lsc_fence.slm.none.group\n");

        // Xe2 4-operand: nbarrier.signal <id>:b <type>:w <n_prod>:b <n_cons>:b
        {
            uint8_t bid = 1;
            uint16_t btype = 0;
            uint8_t np = N_SG;
            uint8_t nc = N_SG;
            asm volatile(
                "nbarrier.signal %0(0,0)<0;1,0> %1(0,0)<0;1,0> %2(0,0)<0;1,0> %3(0,0)<0;1,0>\n"
                :: "rw"(bid), "rw"(btype), "rw"(np), "rw"(nc));
            asm volatile("nbarrier.wait %0(0,0)<0;1,0>\n" :: "rw"(bid));
        }

        // Phase 2
        if (lane == 0) {
            int sum = 0;
            for (int i = 0; i < N_SG; ++i) sum += slm[i];
            out[sg_id] = sum;
        }

        // need to keep work_group_named_barrier alive for IGC
        volatile int __keep = 0;
        if (__keep) work_group_named_barrier(nb, 0x1);
#else
        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];
        sycl::group_barrier(item.get_group());
        if (lane == 0) {
            int sum = 0;
            for (int i = 0; i < N_SG; ++i) sum += slm[i];
            out[sg_id] = sum;
        }
#endif
    }
};

// T3: baseline
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
        printf("=== T1: IGC work_group_named_barrier (reference) ===\n");
        ++total; if (run_test<AsmConvergentKernel>(q, "T1")) ++passed;
    }
    if (which == 0 || which == 2) {
        printf("=== T2: IGC init + asm signal/wait at convergence ===\n");
        ++total; if (run_test<AsmManualConvergeKernel>(q, "T2")) ++passed;
    }
    if (which == 0 || which == 3) {
        printf("=== T3: baseline ===\n");
        ++total; if (run_test<BaselineKernel>(q, "T3")) ++passed;
    }

    printf("\nResults: %d/%d passed\n", passed, total);
    return passed == total ? 0 : 1;
}

// test_nbarrier_fix2.cpp — test named_barrier_init with corrected function signature
//
// Root cause analysis:
// 1. tvisa declares: extern SYCL_EXTERNAL void named_barrier_init(int id)
//    But IGC expects: __namedBarrier* named_barrier_init(int subgroupCount)
// 2. IGC's NamedBarriersResolution expects work_group_named_barrier to also exist
//
// Fix: redeclare named_barrier_init with correct return type + add work_group_named_barrier
//
// Build:
//   source ~/zhenyuan/DeepEP/env.sh  # use 2025.2 or 2025.3
//   icpx -std=c++17 -fsycl -D__SYCL_INTERNAL_API -fsycl-targets=spir64 \
//        -I ~/zhenyuan/tvisa/include \
//        test_nbarrier_fix2.cpp -o test_nbarrier_fix2

#include <sycl/sycl.hpp>
#include <cstdio>

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
// ── Fixed declarations matching IGC expectations ─────────────────────────
// IGC's NamedBarriersResolution looks for these exact mangled names:
//   _Z18named_barrier_initi         — must return __namedBarrier*
//   _Z24work_group_named_barrierPU3AS314__namedBarrierj — must exist (even unused)

struct __namedBarrier;

// Override tvisa's void version with correct return type
extern SYCL_EXTERNAL __namedBarrier __attribute__((opencl_local)) *
named_barrier_init(int count);

// Dummy declaration so IGC doesn't crash on null nbarrierBarrierF
extern SYCL_EXTERNAL void work_group_named_barrier(
    __namedBarrier __attribute__((opencl_local)) *, unsigned int);

// Still use tvisa's raw asm for signal/wait
#include "lsc.hpp"
#include "regmap.hpp"

// Only include gateway.hpp functions we need (NOT named_barrier_init which conflicts)
static inline void barrier() {
    asm volatile("barrier\n");
}

static inline void nbarrier_signal(uint8_t id, uint8_t n_threads) {
    asm volatile("nbarrier.signal %0(0,0)<0;1,0> %1(0,0)<0;1,0>\n"
                 :: "rw"(id), "rw"(n_threads));
}

static inline void nbarrier_wait(uint8_t id) {
    asm volatile("nbarrier.wait %0(0,0)<0;1,0>\n" :: "rw"(id));
}

#endif

constexpr int SG_SZ = 16;
constexpr int N_SG  = 4;
constexpr int WG_SZ = SG_SZ * N_SG;

// ── T1: named_barrier_init + nbarrier signal/wait ────────────────────────
struct NBarrierKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        // Call with subgroup count (not barrier ID) — matches OpenCL convention
        auto* nb = named_barrier_init(N_SG);
        // Force use of nb to prevent optimization removal
        // (void)nb; is enough — IGC will process the call before DCE
        (void)nb;
#endif

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        nbarrier_signal(1, static_cast<uint8_t>(N_SG));
        nbarrier_wait(1);
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

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        asm volatile("barrier\n");
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
        printf("=== T1: named_barrier_init (fixed sig) + nbarrier signal/wait ===\n");
        ++total; if (run_test<NBarrierKernel>(q, "T1")) ++passed;
    }

    if (which == 0 || which == 2) {
        printf("=== T2: baseline full-WG barrier ===\n");
        ++total; if (run_test<BaselineKernel>(q, "T2")) ++passed;
    }

    printf("\nResults: %d/%d passed\n", passed, total);
    return passed == total ? 0 : 1;
}

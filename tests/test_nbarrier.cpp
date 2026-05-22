// test_nbarrier.cpp — minimal tvisa nbarrier asm test for Intel GPU (Xe2/BMG)
//
// Build:
//   source ~/zhenyuan/DeepEP/env.sh
//   icpx -std=c++17 -fsycl -D__SYCL_INTERNAL_API -fsycl-targets=spir64 \
//        -L/data/model/zhenyuan/old/compiler/2025.2/lib \
//        -Wl,-rpath,/data/model/zhenyuan/old/compiler/2025.2/lib \
//        -I ~/zhenyuan/tvisa/include \
//        test_nbarrier.cpp -o test_nbarrier
//
// Tests:
//   T1: raw asm "nbarrier.signal" + "nbarrier.wait" (no named_barrier_init)
//   T2: named_barrier_init<1>() + nbarrier_signal/wait
//   T3: raw asm "barrier" (full WG barrier, baseline)

#include <sycl/sycl.hpp>
#include <cstdio>

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
#include "lsc.hpp"
#include "regmap.hpp"
#include "gateway.hpp"
#endif

constexpr int SG_SZ = 16;
constexpr int N_SG  = 4;   // 4 sub-groups per work-group
constexpr int WG_SZ = SG_SZ * N_SG;

// ── T1: raw nbarrier.signal + nbarrier.wait asm (no init) ────────────────
struct RawNBarrierKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id  = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane   = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid    = static_cast<int>(item.get_local_id(0));

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];
        sycl::group_barrier(item.get_group());

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        uint8_t bar_id = 1;
        uint8_t n_threads = static_cast<uint8_t>(N_SG);
        asm volatile("nbarrier.signal %0(0,0)<0;1,0> %1(0,0)<0;1,0>\n"
                     :: "rw"(bar_id), "rw"(n_threads));
        asm volatile("nbarrier.wait %0(0,0)<0;1,0>\n" :: "rw"(bar_id));
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

// ── T2: named_barrier_init + nbarrier_signal + nbarrier_wait ─────────────
// DISABLED: named_barrier_init causes IGC 2.27.10 to segfault during JIT
// even if this kernel is never launched. Uncomment when IGC is fixed.
#if 0
struct InitNBarrierKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id  = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane   = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid    = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        named_barrier_init<1>();
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
#endif

// ── T3: raw asm "barrier" (full WG barrier, baseline) ────────────────────
struct RawBarrierKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id  = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane   = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid    = static_cast<int>(item.get_local_id(0));

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
    // Usage: ./test_nbarrier [1|2|3]  — run only that test, default = 3 (baseline)
    int which = (argc > 1) ? atoi(argv[1]) : 0;

    sycl::queue q{sycl::gpu_selector_v};
    printf("Device: %s\n\n", q.get_device().get_info<sycl::info::device::name>().c_str());

    int passed = 0, total = 0;

    if (which == 0 || which == 1) {
        printf("=== T1: raw asm nbarrier.signal + nbarrier.wait (no init) ===\n");
        ++total; if (run_test<RawNBarrierKernel>(q, "T1")) ++passed;
    }

    if (which == 0 || which == 2) {
        printf("=== T2: DISABLED (named_barrier_init crashes IGC 2.27.10) ===\n");
        // ++total; if (run_test<InitNBarrierKernel>(q, "T2")) ++passed;
    }

    if (which == 0 || which == 3) {
        printf("=== T3: raw asm barrier (full WG, baseline) ===\n");
        ++total; if (run_test<RawBarrierKernel>(q, "T3")) ++passed;
    }

    printf("=== T3: raw asm barrier (full WG, baseline) ===\n");
    ++total; if (run_test<RawBarrierKernel>(q, "T3")) ++passed;

    printf("\nResults: %d/%d passed\n", passed, total);
    return passed == total ? 0 : 1;
}

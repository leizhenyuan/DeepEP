// test_nbarrier_fix.cpp — test named_barrier_init with IGC crash workaround
//
// Root cause: IGC's NamedBarriersResolution pass expects both
// _Z18named_barrier_initi AND _Z24work_group_named_barrierPU3AS314__namedBarrierj
// to be present. tvisa only declares the former, so nbarrierBarrierF is nullptr
// and IGC crashes on nbarrierBarrierF->eraseFromParent().
//
// Fix: declare a dummy work_group_named_barrier so IGC doesn't crash.
//
// Build:
//   source ~/zhenyuan/DeepEP/env.sh
//   icpx -std=c++17 -fsycl -D__SYCL_INTERNAL_API -fsycl-targets=spir64 \
//        -L/data/model/zhenyuan/old/compiler/2025.2/lib \
//        -Wl,-rpath,/data/model/zhenyuan/old/compiler/2025.2/lib \
//        -I ~/zhenyuan/tvisa/include \
//        test_nbarrier_fix.cpp -o test_nbarrier_fix

#include <sycl/sycl.hpp>
#include <cstdio>

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
#include "lsc.hpp"
#include "regmap.hpp"
#include "gateway.hpp"

// ── IGC crash workaround ─────────────────────────────────────────────────
// Declare the missing work_group_named_barrier symbol that IGC expects.
// This is never called — it just prevents the null pointer crash in
// NamedBarriersResolution::runOnModule().
struct __namedBarrier;
extern "C" SYCL_EXTERNAL void _Z24work_group_named_barrierPU3AS314__namedBarrierj(
    __namedBarrier __attribute__((opencl_local)) *, unsigned int);
#endif

constexpr int SG_SZ = 16;
constexpr int N_SG  = 4;
constexpr int WG_SZ = SG_SZ * N_SG;

// ── T1: named_barrier_init + raw asm nbarrier signal/wait ────────────────
struct NBarrierKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

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

// ── T2: raw_sends barrier signal (BarrierPayload) ───────────────────────
struct RawSendsBarrierKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        named_barrier_init<1>();
#endif

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        // Use raw_sends version with BarrierPayload for signal
        BarrierPayload bp(1, false, BarrierType::ProducerConsumer,
                          static_cast<uint8_t>(N_SG),
                          static_cast<uint8_t>(N_SG));
        nbarrier_signal(bp);
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

// ── T3: baseline full-WG barrier ─────────────────────────────────────────
struct BaselineBarrierKernel {
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
        printf("=== T1: named_barrier_init + nbarrier.signal/wait ===\n");
        ++total; if (run_test<NBarrierKernel>(q, "T1")) ++passed;
    }

    if (which == 0 || which == 2) {
        printf("=== T2: named_barrier_init + raw_sends barrier signal ===\n");
        ++total; if (run_test<RawSendsBarrierKernel>(q, "T2")) ++passed;
    }

    if (which == 0 || which == 3) {
        printf("=== T3: baseline full-WG barrier ===\n");
        ++total; if (run_test<BaselineBarrierKernel>(q, "T3")) ++passed;
    }

    printf("\nResults: %d/%d passed\n", passed, total);
    return passed == total ? 0 : 1;
}

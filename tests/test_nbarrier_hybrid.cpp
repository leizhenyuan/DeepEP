// test_nbarrier_hybrid.cpp — named_barrier_init via IGC + raw asm signal/wait
//
// Goal: call named_barrier_init to let IGC allocate barrier slots (NBarrierCnt),
// then use raw asm nbarrier.signal/wait for fine-grained control.
//
// Build:
//   icpx -std=c++17 -fsycl -D__SYCL_INTERNAL_API -fsycl-targets=spir64 \
//        -I ~/zhenyuan/tvisa/include \
//        test_nbarrier_hybrid.cpp -o test_nbarrier_hybrid

#include <sycl/sycl.hpp>
#include <cstdio>

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
#include "lsc.hpp"
#include "regmap.hpp"

// ── Correct named_barrier declarations for IGC ──────────────────────────
struct __namedBarrier;

extern SYCL_EXTERNAL __namedBarrier __attribute__((opencl_local)) *
named_barrier_init(int count);

// Must be declared to prevent IGC crash (even if never called)
extern SYCL_EXTERNAL void work_group_named_barrier(
    __namedBarrier __attribute__((opencl_local)) *, unsigned int);

// ── Convenience wrapper ─────────────────────────────────────────────────
// Call named_barrier_init to let IGC allocate barrier slots (NBarrierCnt).
// The volatile-guard keeps work_group_named_barrier in SPIR-V IR so IGC
// doesn't crash, but it never actually executes at runtime.
inline void nbarrier_init_slot(int sub_group_count) {
    auto* nb = named_barrier_init(sub_group_count);
    // volatile prevents compiler from optimizing away the branch,
    // but at runtime this never executes.
    volatile int __keep = 0;
    if (__keep) {
        work_group_named_barrier(nb, 0x1 /*CLK_LOCAL_MEM_FENCE*/);
    }
}

// ── Raw asm signal/wait — Xe2 4-operand format ──────────────────────────
// Xe2 format: nbarrier.signal <id>:b <type>:w <n_producers>:b <n_consumers>:b
// type=0 means ProducerConsumer mode
static inline void nbarrier_signal_xe2(uint8_t id, uint8_t n_prod, uint8_t n_cons) {
    // Xe2 requires 4-operand nbarrier.signal (NOT PVC 2-operand format)
    asm volatile(
        "nbarrier.signal %0(0,0)<0;1,0> %1(0,0)<0;1,0> %2(0,0)<0;1,0> %3(0,0)<0;1,0>\n"
        :: "rw"(id), "rw"((uint16_t)0), "rw"(n_prod), "rw"(n_cons));
}

static inline void nbarrier_wait(uint8_t id) {
    asm volatile("nbarrier.wait %0(0,0)<0;1,0>\n" :: "rw"(id));
}

// PVC-style 2-operand (kept for reference — NOT valid on Xe2)
// static inline void nbarrier_signal_pvc(uint8_t id, uint8_t n_threads) {
//     asm volatile("nbarrier.signal %0(0,0)<0;1,0> %1(0,0)<0;1,0>\n"
//                  :: "rw"(id), "rw"(n_threads));
// }

// ── Raw_sends signal (full producer/consumer control) ───────────────────
static inline void nbarrier_signal(const BarrierPayload& bp) {
    asm volatile(
        "raw_sends.3.1.0.0 (M1, 1) 0x0:ud 0x02000004:ud %0.0 V0.0 V0.0\n"
        :: "rw"(bp.getPayload()));
}
#endif

constexpr int SG_SZ = 16;
constexpr int N_SG  = 4;
constexpr int WG_SZ = SG_SZ * N_SG;

// ── T1: init via IGC + simple asm signal/wait ────────────────────────────
struct HybridSimpleKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        nbarrier_init_slot(N_SG);  // IGC allocates barrier slot (ID=1)
#endif

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        nbarrier_signal_xe2(1, static_cast<uint8_t>(N_SG), static_cast<uint8_t>(N_SG));  // raw asm Xe2
        nbarrier_wait(1);                                 // raw asm
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

// ── T2: init via IGC + raw_sends signal (producer/consumer) ─────────────
struct HybridRawSendsKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        nbarrier_init_slot(N_SG);
#endif

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        // raw_sends version: separate producer/consumer counts
        BarrierPayload bp(1, false, BarrierType::ProducerConsumer,
                          static_cast<uint8_t>(N_SG),
                          static_cast<uint8_t>(N_SG));
        nbarrier_signal(bp);   // raw_sends Gateway message
        nbarrier_wait(1);      // raw asm wait
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

// ── T3: baseline ─────────────────────────────────────────────────────────
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
        printf("=== T1: nbarrier_init (IGC) + asm signal/wait ===\n");
        ++total; if (run_test<HybridSimpleKernel>(q, "T1")) ++passed;
    }

    if (which == 0 || which == 2) {
        printf("=== T2: nbarrier_init (IGC) + raw_sends signal ===\n");
        ++total; if (run_test<HybridRawSendsKernel>(q, "T2")) ++passed;
    }

    if (which == 0 || which == 3) {
        printf("=== T3: baseline SYCL barrier ===\n");
        ++total; if (run_test<BaselineKernel>(q, "T3")) ++passed;
    }

    printf("\nResults: %d/%d passed\n", passed, total);
    return passed == total ? 0 : 1;
}

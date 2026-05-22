// test_nbarrier_asm.cpp — pure raw asm named barriers, no IGC init
// Tests if nbarrier.signal/wait works without named_barrier_init / NBarrierCnt
//
// Build:
//   icpx -std=c++17 -fsycl -D__SYCL_INTERNAL_API -fsycl-targets=spir64 \
//        -I ~/zhenyuan/tvisa/include test_nbarrier_asm.cpp -o test_nbarrier_asm

#include <sycl/sycl.hpp>
#include <cstdio>

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
#include "lsc.hpp"
#include "regmap.hpp"
#endif

constexpr int SG_SZ = 16;
constexpr int N_SG  = 4;
constexpr int WG_SZ = SG_SZ * N_SG;

// T1: pure asm nbarrier — Xe2 4-operand format, no IGC init
struct PureAsmXe2Kernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        // SLM fence before barrier
        asm volatile("lsc_fence.slm.none.group\n");
        // Xe2 4-operand: nbarrier.signal <id>:b <type>:w <n_prod>:b <n_cons>:b
        uint8_t bid = 1;
        uint16_t btype = 0;
        uint8_t n_sg = N_SG;
        asm volatile(
            "nbarrier.signal %0(0,0)<0;1,0> %1(0,0)<0;1,0> %2(0,0)<0;1,0> %3(0,0)<0;1,0>\n"
            :: "rw"(bid), "rw"(btype), "rw"(n_sg), "rw"(n_sg));
        asm volatile("nbarrier.wait %0(0,0)<0;1,0>\n" :: "rw"(bid));
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

// T2: pure asm nbarrier — PVC 2-operand format
struct PureAsmPvcKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        asm volatile("lsc_fence.slm.none.group\n");
        // PVC 2-operand: nbarrier.signal <id> <n_threads>
        uint8_t bid = 1;
        uint8_t n_sg = N_SG;
        asm volatile(
            "nbarrier.signal %0(0,0)<0;1,0> %1(0,0)<0;1,0>\n"
            :: "rw"(bid), "rw"(n_sg));
        asm volatile("nbarrier.wait %0(0,0)<0;1,0>\n" :: "rw"(bid));
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

// T3: raw_sends Gateway approach (tvisa BarrierPayload)
struct RawSendsGatewayKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        asm volatile("lsc_fence.slm.none.group\n");
        // Gateway raw_sends for named barrier signal
        BarrierPayload bp(1, false, BarrierType::ProducerConsumer,
                          static_cast<uint8_t>(N_SG),
                          static_cast<uint8_t>(N_SG));
        asm volatile(
            "raw_sends.3.1.0.0 (M1, 1) 0x0:ud 0x02000004:ud %0.0 V0.0 V0.0\n"
            :: "rw"(bp.getPayload()));
        // wait
        uint8_t bid = 1;
        asm volatile("nbarrier.wait %0(0,0)<0;1,0>\n" :: "rw"(bid));
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

// T4: baseline
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
        printf("=== T1: pure asm Xe2 4-operand ===\n");
        ++total; if (run_test<PureAsmXe2Kernel>(q, "T1")) ++passed;
    }
    if (which == 0 || which == 2) {
        printf("=== T2: pure asm PVC 2-operand ===\n");
        ++total; if (run_test<PureAsmPvcKernel>(q, "T2")) ++passed;
    }
    if (which == 0 || which == 3) {
        printf("=== T3: raw_sends Gateway ===\n");
        ++total; if (run_test<RawSendsGatewayKernel>(q, "T3")) ++passed;
    }
    if (which == 0 || which == 4) {
        printf("=== T4: baseline ===\n");
        ++total; if (run_test<BaselineKernel>(q, "T4")) ++passed;
    }

    printf("\nResults: %d/%d passed\n", passed, total);
    return passed == total ? 0 : 1;
}

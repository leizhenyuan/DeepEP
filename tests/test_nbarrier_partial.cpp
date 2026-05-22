// test_nbarrier_partial.cpp — partial work-group sync: 3 SGs + 5 SGs
//
// 8 sub-groups total:
//   SG 0-2 → nb1 (count=3), write/read SLM[0..2]
//   SG 3-7 → nb2 (count=5), write/read SLM[3..7]
//
// Build:
//   icpx -std=c++17 -fsycl -D__SYCL_INTERNAL_API -fsycl-targets=spir64 \
//        -I ~/zhenyuan/tvisa/include test_nbarrier_partial.cpp -o test_nbarrier_partial

#include <sycl/sycl.hpp>
#include <cstdio>
#include "nbarrier_xe2.hpp"

constexpr int SG_SZ = 16;
constexpr int N_SG  = 8;
constexpr int WG_SZ = SG_SZ * N_SG;
constexpr int GROUP_A = 3;  // SG 0..2
constexpr int GROUP_B = 5;  // SG 3..7

struct PartialSyncKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        // ALL sub-groups must call init
        NBarrier nb1, nb2;
        nb1.init(GROUP_A);   // barrier for 3 sub-groups
        nb2.init(GROUP_B);   // barrier for 5 sub-groups

        // Phase 1: each SG writes its value to SLM
        if (lane == 0) slm[sg_id] = in[sg_id];

        // Phase 2: selective sync — only participating SGs call sync
        if (sg_id < GROUP_A) {
            nb1.sync();  // SG 0,1,2 sync together
        } else {
            nb2.sync();  // SG 3,4,5,6,7 sync together
        }

        // Phase 3: each SG sums its group's SLM values
        if (lane == 0) {
            int sum = 0;
            if (sg_id < GROUP_A) {
                for (int i = 0; i < GROUP_A; ++i) sum += slm[i];
            } else {
                for (int i = GROUP_A; i < N_SG; ++i) sum += slm[i];
            }
            out[sg_id] = sum;
        }
#else
        if (lane == 0) slm[sg_id] = in[sg_id];
        sycl::group_barrier(item.get_group());
        if (lane == 0) {
            int sum = 0;
            if (sg_id < GROUP_A) {
                for (int i = 0; i < GROUP_A; ++i) sum += slm[i];
            } else {
                for (int i = GROUP_A; i < N_SG; ++i) sum += slm[i];
            }
            out[sg_id] = sum;
        }
#endif
    }
};

int main() {
    sycl::queue q{sycl::gpu_selector_v};
    printf("Device: %s\n\n", q.get_device().get_info<sycl::info::device::name>().c_str());

    int* in  = sycl::malloc_shared<int>(N_SG, q);
    int* out = sycl::malloc_shared<int>(N_SG, q);
    for (int i = 0; i < N_SG; ++i) in[i] = (i + 1) * 10;
    std::fill_n(out, N_SG, -1);

    // Expected: SG 0-2 → sum of in[0..2] = 10+20+30 = 60
    //           SG 3-7 → sum of in[3..7] = 40+50+60+70+80 = 300
    int exp_a = 0, exp_b = 0;
    for (int i = 0; i < GROUP_A; ++i) exp_a += in[i];
    for (int i = GROUP_A; i < N_SG; ++i) exp_b += in[i];
    printf("Expected: group A (SG 0-%d) = %d, group B (SG %d-%d) = %d\n\n",
           GROUP_A - 1, exp_a, GROUP_A, N_SG - 1, exp_b);

    try {
        q.submit([&](sycl::handler& h) {
            sycl::local_accessor<int, 1> slm(N_SG, h);
            h.parallel_for(sycl::nd_range<1>{WG_SZ, WG_SZ},
                           PartialSyncKernel{in, out, slm});
        }).wait_and_throw();
    } catch (const sycl::exception& e) {
        printf("SYCL exception: %s\n", e.what());
        sycl::free(in, q); sycl::free(out, q);
        return 1;
    }

    bool pass = true;
    for (int i = 0; i < N_SG; ++i) {
        int expected = (i < GROUP_A) ? exp_a : exp_b;
        printf("  SG %d: out=%d expected=%d %s\n", i, out[i], expected,
               out[i] == expected ? "OK" : "FAIL");
        if (out[i] != expected) pass = false;
    }
    printf("\n%s\n", pass ? "PASS" : "FAIL");

    sycl::free(in, q); sycl::free(out, q);
    return pass ? 0 : 1;
}

// test_nbarrier_api.cpp — verify NBarrier wrapper API
//
// Build:
//   icpx -std=c++17 -fsycl -D__SYCL_INTERNAL_API -fsycl-targets=spir64 \
//        -I ~/zhenyuan/tvisa/include test_nbarrier_api.cpp -o test_nbarrier_api

#include <sycl/sycl.hpp>
#include <cstdio>
#include "nbarrier_xe2.hpp"

constexpr int SG_SZ = 16;
constexpr int N_SG  = 4;
constexpr int WG_SZ = SG_SZ * N_SG;

// T1: single named barrier
struct SingleBarrierKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        NBarrier nb;
        nb.init(N_SG);

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];
        nb.sync();  // signal + wait

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

// T2: two named barriers (pipeline pattern)
struct DualBarrierKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        NBarrier nb1, nb2;
        nb1.init(N_SG);
        nb2.init(N_SG);

        // Phase 1: write
        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];
        nb1.sync();

        // Phase 2: read + accumulate
        if (lane == 0) {
            int sum = 0;
            for (int i = 0; i < N_SG; ++i) sum += slm[i];
            slm[sg_id] = sum;
        }
        nb2.sync();

        // Phase 3: write result
        if (lane == 0) {
            out[sg_id] = slm[sg_id];
        }
#else
        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];
        sycl::group_barrier(item.get_group());
        if (lane == 0) {
            int sum = 0;
            for (int i = 0; i < N_SG; ++i) sum += slm[i];
            slm[sg_id] = sum;
        }
        sycl::group_barrier(item.get_group());
        if (lane == 0) {
            out[sg_id] = slm[sg_id];
        }
#endif
    }
};

// T3: nbarrier_create convenience
struct ConvenienceKernel {
    int* in;
    int* out;
    sycl::local_accessor<int, 1> slm;

    [[sycl::reqd_sub_group_size(SG_SZ)]] void operator()(sycl::nd_item<1> item) const {
        int sg_id = static_cast<int>(item.get_sub_group().get_group_id()[0]);
        int lane  = static_cast<int>(item.get_sub_group().get_local_linear_id());
        int lid   = static_cast<int>(item.get_local_id(0));

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        auto nb = nbarrier_create(N_SG);

        if (lane == 0) slm[sg_id] = in[lid / SG_SZ];
        nb.sync(CLK_LOCAL_MEM_FENCE);

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

int main() {
    sycl::queue q{sycl::gpu_selector_v};
    printf("Device: %s\n\n", q.get_device().get_info<sycl::info::device::name>().c_str());

    int passed = 0, total = 0;

    printf("=== T1: NBarrier single barrier ===\n");
    ++total; if (run_test<SingleBarrierKernel>(q, "T1")) ++passed;

    printf("=== T2: NBarrier dual barriers ===\n");
    ++total; if (run_test<DualBarrierKernel>(q, "T2")) ++passed;

    printf("=== T3: nbarrier_create convenience ===\n");
    ++total; if (run_test<ConvenienceKernel>(q, "T3")) ++passed;

    printf("\nResults: %d/%d passed\n", passed, total);
    return passed == total ? 0 : 1;
}

// IGC Load Narrowing Bug Reproducer
// 
// Build:
//   icpx -fsycl -fsycl-targets=intel_gpu_bmg -O2 -o test_load_narrowing test_load_narrowing.cpp
//
// Run:
//   ./test_load_narrowing
//
// Expected: all values non-zero (matching reference)
// Bug: some values are zero due to IGC narrowing the load

#include <sycl/sycl.hpp>
#include <cstdio>
#include <cstring>

struct int4 { int x, y, z, w; };
static_assert(sizeof(int4) == 16, "int4 must be 16 bytes");

using bf16 = sycl::ext::oneapi::bfloat16;

// Reproduces IGC load narrowing bug:
// When loading an int4 (16 bytes) and reinterpreting as 8 x bf16,
// IGC may narrow the load to fewer bytes if it thinks some components are unused.
void test_kernel(sycl::queue& q, const int4* input, float* output, int n) {
    q.submit([&](sycl::handler& cgh) {
        cgh.parallel_for(sycl::range<1>(32), [=](sycl::id<1> id) {
            int lane = id[0];
            
            // Load a full int4 (16 bytes = 8 bf16 values) via normal pointer deref
            // IGC has freedom to optimize this load
            int4 loaded = input[lane];
            
            // Reinterpret as bf16 and accumulate all 8 values to float
            auto values_bf16 = reinterpret_cast<const bf16*>(&loaded);
            float sum = 0.0f;
            for (int i = 0; i < 8; ++i) {
                sum += static_cast<float>(values_bf16[i]);
            }
            
            // Convert back to bf16, pack into int4, store
            int4 result;
            auto result_bf16 = reinterpret_cast<bf16*>(&result);
            for (int i = 0; i < 8; ++i) {
                result_bf16[i] = static_cast<bf16>(sum + static_cast<float>(i));
            }
            
            // Store result as 4 floats (reinterpret int4 components)
            output[lane * 4 + 0] = *reinterpret_cast<float*>(&result.x);
            output[lane * 4 + 1] = *reinterpret_cast<float*>(&result.y);
            output[lane * 4 + 2] = *reinterpret_cast<float*>(&result.z);
            output[lane * 4 + 3] = *reinterpret_cast<float*>(&result.w);
            
            // BUG WORKAROUND (uncomment to fix):
            // volatile float dummy = static_cast<float>(values_bf16[0]);
        });
    }).wait();
}

int main() {
    sycl::queue q;
    
    constexpr int N = 32;
    auto* input = sycl::malloc_device<int4>(N, q);
    auto* output = sycl::malloc_device<float>(N * 4, q);
    
    // Fill input with known bf16 values (1.0, 2.0, ..., 8.0 per int4)
    std::vector<int4> host_input(N);
    for (int i = 0; i < N; ++i) {
        bf16 vals[8];
        for (int j = 0; j < 8; ++j) {
            vals[j] = static_cast<bf16>(static_cast<float>(j + 1));
        }
        std::memcpy(&host_input[i], vals, 16);
    }
    q.memcpy(input, host_input.data(), N * sizeof(int4)).wait();
    
    test_kernel(q, input, output, N);
    
    // Read back and verify
    std::vector<float> host_output(N * 4);
    q.memcpy(host_output.data(), output, N * 4 * sizeof(float)).wait();
    
    // Check: all output values should be non-zero
    int errors = 0;
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < 4; ++j) {
            if (host_output[i * 4 + j] == 0.0f) {
                if (errors < 10) {
                    printf("ERROR: output[%d][%d] = 0 (unexpected zero)\n", i, j);
                }
                errors++;
            }
        }
    }
    
    if (errors == 0) {
        printf("PASS: all %d values non-zero\n", N * 4);
    } else {
        printf("FAIL: %d zero values detected (IGC load narrowing bug)\n", errors);
    }
    
    // Print first lane's output for inspection
    printf("Lane 0 output: %.4f %.4f %.4f %.4f\n",
           host_output[0], host_output[1], host_output[2], host_output[3]);
    
    sycl::free(input, q);
    sycl::free(output, q);
    return errors ? 1 : 0;
}

#include <cstdio>

__global__ void fence_builtin(int* data, int* flag) {
    data[threadIdx.x] = threadIdx.x + 1;
    __threadfence();          // GPU-level fence
    if (threadIdx.x == 0) flag[0] = 1;
}

__global__ void fence_block_builtin(int* data, int* flag) {
    data[threadIdx.x] = threadIdx.x + 1;
    __threadfence_block();    // Block-level fence
    if (threadIdx.x == 0) flag[0] = 1;
}

__global__ void fence_acq_rel_gpu(int* data, int* flag) {
    data[threadIdx.x] = threadIdx.x + 1;
    asm volatile("fence.acq_rel.gpu;" ::: "memory");
    if (threadIdx.x == 0) flag[0] = 1;
}

__global__ void fence_acq_rel_cta(int* data, int* flag) {
    data[threadIdx.x] = threadIdx.x + 1;
    asm volatile("fence.acq_rel.cta;" ::: "memory");
    if (threadIdx.x == 0) flag[0] = 1;
}

int main() {
    int *d_data, *d_flag;
    cudaMalloc(&d_data, 256 * sizeof(int));
    cudaMalloc(&d_flag, sizeof(int));
    fence_builtin<<<1, 32>>>(d_data, d_flag);
    fence_block_builtin<<<1, 32>>>(d_data, d_flag);
    fence_acq_rel_gpu<<<1, 32>>>(d_data, d_flag);
    fence_acq_rel_cta<<<1, 32>>>(d_data, d_flag);
    cudaDeviceSynchronize();
    cudaFree(d_data);
    cudaFree(d_flag);
    return 0;
}

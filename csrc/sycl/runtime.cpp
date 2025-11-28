#include <cstdlib>
#include <iostream>
#include <ishmem.h>
#include <ishmemx.h>
#include <mpi.h>
#include "sycl/api.hpp"

namespace deep_ep {

    
namespace internode {

std::vector<uint8_t> get_unique_id() {
    ishmemx_uniqueid_t unique_id;
    ishmemx_get_uniqueid(&unique_id);

    std::vector<uint8_t> result(sizeof(ishmemx_uniqueid_t));
    std::memcpy(result.data(), &unique_id, sizeof(ishmemx_uniqueid_t));
    return result;
}

int init(const std::vector<uint8_t>& root_unique_id_val, int rank, int num_ranks, bool low_latency_mode) {
    ishmemx_uniqueid_t root_unique_id;
    ishmemx_init_attr_t attr;
    std::memcpy(&root_unique_id, root_unique_id_val.data(), sizeof(ishmemx_uniqueid_t));
    // nvshmemx_set_attr_uniqueid_args(rank, num_ranks, &root_unique_id, &attr);
    // todo: 这里没有显示指定rank，那么ishmem_my_pe()会返回什么？
    attr.initialize_runtime = false;
    attr.use_uid = true;
    attr.nranks = num_ranks;
    attr.uid = &root_unique_id;

    ishmemx_init_attr(NVSHMEMX_INIT_WITH_UNIQUEID, &attr);

    // Create sub-RDMA teams
    // NOTES: if `num_ranks <= NUM_MAX_NVL_PEERS` then only low-latency kernels are used
    if (low_latency_mode and num_ranks > NUM_MAX_NVL_PEERS) {
        EP_HOST_ASSERT(cpu_rdma_team == NVSHMEM_TEAM_INVALID);
        EP_HOST_ASSERT(num_ranks % NUM_MAX_NVL_PEERS == 0);
        EP_HOST_ASSERT(nvshmem_team_split_strided(NVSHMEM_TEAM_WORLD,
                                                  rank % NUM_MAX_NVL_PEERS,
                                                  NUM_MAX_NVL_PEERS,
                                                  num_ranks / NUM_MAX_NVL_PEERS,
                                                  &cpu_rdma_team_config,
                                                  0,
                                                  &cpu_rdma_team) == 0);
        EP_HOST_ASSERT(cpu_rdma_team != NVSHMEM_TEAM_INVALID);
    }

    ishmem_barrier_all();
    return ishmem_my_pe();
}

// world team collective operation
// 这里会隐式的调用一个barrier all 在nvshmem align exit的时候
// 每个PE 上面分配的ptr size如果不同会导致未定义行为
void* alloc(size_t size, size_t alignment) {
    return ishmem_align(alignment, size);
}

// 在enter之前隐式的有一个barrier all的alinment
void free(void* ptr) {
    ishmem_free(ptr);
}

void barrier() {
    ishmem_barrier_all();
}

void finalize() {
    if (cpu_rdma_team != NVSHMEM_TEAM_INVALID) {
        ishmem_team_destroy(cpu_rdma_team);
        cpu_rdma_team = NVSHMEM_TEAM_INVALID;
    }
    ishmem_finalize();
}

}

}
#include <cstdlib>
#include <iostream>
#include <cstring>
#include <vector>
#include "api.hpp"

// 注意：当前实现是stub版本，用于intranode模式（不需要ISHMEM）
// 完整的internode功能需要ISHMEM支持

namespace deep_ep {

    
namespace internode {

std::vector<uint8_t> get_unique_id() {
#ifndef DISABLE_NVSHMEM
    // 需要ISHMEM支持
    #include <ishmem.h>
    #include <ishmemx.h>
    ishmemx_uniqueid_t unique_id;
    ishmemx_get_uniqueid(&unique_id);

    std::vector<uint8_t> result(sizeof(ishmemx_uniqueid_t));
    std::memcpy(result.data(), &unique_id, sizeof(ishmemx_uniqueid_t));
    return result;
#else
    // Stub: 返回空的unique_id，仅用于intranode模式
    EP_HOST_ASSERT(false && "ISHMEM is disabled during compilation, get_unique_id not available");
    return std::vector<uint8_t>();
#endif
}

int init(const std::vector<uint8_t>& root_unique_id_val, int rank, int num_ranks, bool low_latency_mode) {
#ifndef DISABLE_NVSHMEM
    // 需要ISHMEM支持
    EP_HOST_ASSERT(false && "ISHMEM init requires ISHMEM library");
    return -1;
#else
    // Stub: intranode模式不需要NVSHMEM/ISHMEM初始化
    EP_HOST_ASSERT(false && "ISHMEM is disabled during compilation, init not available");
    return -1;
#endif
}

void* alloc(size_t size, size_t alignment) {
#ifndef DISABLE_NVSHMEM
    EP_HOST_ASSERT(false && "ISHMEM alloc requires ISHMEM library");
    return nullptr;
#else
    // Stub
    EP_HOST_ASSERT(false && "ISHMEM is disabled during compilation, alloc not available");
    return nullptr;
#endif
}

void free(void* ptr) {
#ifndef DISABLE_NVSHMEM
    // 需要ISHMEM支持
#else
    // Stub
#endif
}

void barrier() {
#ifndef DISABLE_NVSHMEM
    // 需要ISHMEM支持
#else
    // Stub
#endif
}

void finalize() {
#ifndef DISABLE_NVSHMEM
    // 需要ISHMEM支持
#else
    // Stub
#endif
}

}

}
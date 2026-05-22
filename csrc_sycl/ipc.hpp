// PORTED_FROM: csrc/utils/shared_memory.hpp
// Level Zero IPC handle management for intranode GPU-GPU memory sharing.
//
// On NVIDIA: cudaIpcGetMemHandle / cudaIpcOpenMemHandle
// On Intel:  zeMemGetIpcHandle / zeMemOpenIpcHandle (Level Zero)
//
// HIGH_RISK: Level Zero IPC requires that allocations are made via
// zeMemAllocDevice (not sycl::malloc_device) to get valid IPC handles.
// We use Level Zero directly for the IPC-shared allocations.
#pragma once

#include <sycl/sycl.hpp>
#include <level_zero/ze_api.h>
#include <sycl/ext/oneapi/backend/level_zero.hpp>
#include <cstring>
#include <stdexcept>

#include "exception.hpp"

namespace deep_ep::shared_memory {

struct MemHandle {
    ze_ipc_mem_handle_t ipc_handle;
    size_t size;
};

// HIGH_RISK: Level Zero IPC for intranode PCIe P2P.
// Unlike CUDA IPC over NVLink (cache-coherent), Level Zero IPC over PCIe
// may require explicit cache invalidation on the reading GPU after writes
// complete on the writing GPU. The kernel already has memory_fence(system)
// calls which should cover this, but needs hardware validation.
class SharedMemoryAllocator {
public:
    explicit SharedMemoryAllocator() = default;

    void malloc(void** ptr, size_t size, sycl::queue& queue) {
        auto ctx = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_context());
        auto dev = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_device());

        ze_device_mem_alloc_desc_t dev_desc = {};
        dev_desc.stype = ZE_STRUCTURE_TYPE_DEVICE_MEM_ALLOC_DESC;
        dev_desc.ordinal = 0;
        dev_desc.flags = 0;

        auto result = zeMemAllocDevice(ctx, &dev_desc, size, 64, dev, ptr);
        if (result != ZE_RESULT_SUCCESS) {
            throw EPException("Level Zero", __FILE__, __LINE__,
                              "zeMemAllocDevice failed: " + std::to_string(result));
        }
    }

    void free(void* ptr, sycl::queue& queue) {
        auto ctx = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_context());
        zeMemFree(ctx, ptr);
    }

    void get_mem_handle(MemHandle* mem_handle, void* ptr, size_t alloc_size, sycl::queue& queue) {
        auto ctx = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_context());
        mem_handle->size = alloc_size;

        auto result = zeMemGetIpcHandle(ctx, ptr, &mem_handle->ipc_handle);
        if (result != ZE_RESULT_SUCCESS) {
            throw EPException("Level Zero", __FILE__, __LINE__,
                              "zeMemGetIpcHandle failed: " + std::to_string(result));
        }
    }

    void open_mem_handle(void** ptr, MemHandle* mem_handle, sycl::queue& queue) {
        auto ctx = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_context());
        auto dev = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_device());

        auto result = zeMemOpenIpcHandle(ctx, dev, mem_handle->ipc_handle, 0, ptr);
        if (result != ZE_RESULT_SUCCESS) {
            throw EPException("Level Zero", __FILE__, __LINE__,
                              "zeMemOpenIpcHandle failed: " + std::to_string(result));
        }
    }

    void close_mem_handle(void* ptr, sycl::queue& queue) {
        auto ctx = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_context());
        zeMemCloseIpcHandle(ctx, ptr);
    }
};

}  // namespace deep_ep::shared_memory

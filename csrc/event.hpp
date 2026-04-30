#include <memory>
#include <torch/types.h>

#ifdef USE_CUDA
#include <ATen/cuda/CUDAContext.h>
#include "kernels/exception.cuh"
#endif

#ifdef USE_XPU
#include <ATen/xpu/XPUContext.h>
#include "sycl/configs.h"
#endif

namespace deep_ep {

struct EventHandle {
    std::shared_ptr<torch::Event> event;

#ifdef USE_CUDA
    EventHandle() {
        event = std::make_shared<torch::Event>(torch::kCUDA);
        event->record(at::cuda::getCurrentCUDAStream());
    }

    explicit EventHandle(const at::cuda::CUDAStream& stream) {
        event = std::make_shared<torch::Event>(torch::kCUDA);
        event->record(stream);
    }

    EventHandle(const EventHandle& other) = default;

    void current_stream_wait() const { at::cuda::getCurrentCUDAStream().unwrap().wait(*event); }
#endif

#ifdef USE_XPU
    EventHandle() {
        event = std::make_shared<torch::Event>(torch::kXPU);
        event->record(at::xpu::getCurrentXPUStream());
    }

    explicit EventHandle(const at::xpu::XPUStream& stream) {
        event = std::make_shared<torch::Event>(torch::kXPU);
        event->record(stream);
    }

    EventHandle(const EventHandle& other) = default;

    void current_stream_wait() const { event->block(at::xpu::getCurrentXPUStream()); }
#endif
};

#ifdef USE_CUDA
torch::Event create_event(const at::cuda::CUDAStream& s) {
    auto event = torch::Event(torch::kCUDA);
    event.record(s);
    return event;
}

void stream_wait(const at::cuda::CUDAStream& s_0, const at::cuda::CUDAStream& s_1) {
    EP_HOST_ASSERT(s_0.id() != s_1.id());
    s_0.unwrap().wait(create_event(s_1));
}

void stream_wait(const at::cuda::CUDAStream& s, const EventHandle& event) {
    s.unwrap().wait(*event.event);
}
#endif

#ifdef USE_XPU
torch::Event create_event(const at::xpu::XPUStream& s) {
    auto event = torch::Event(torch::kXPU);
    event.record(s);
    return event;
}

void stream_wait(const at::xpu::XPUStream& s_0, const at::xpu::XPUStream& s_1) {
    EP_HOST_ASSERT(s_0.id() != s_1.id());
    auto event = create_event(s_1);
    event.block(s_0);
}

void stream_wait(const at::xpu::XPUStream& s, const EventHandle& event) {
    event.event->block(s);
}
#endif

}  // namespace deep_ep

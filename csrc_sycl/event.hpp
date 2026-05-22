// PORTED_FROM: csrc/utils/event.hpp
// SYCL event handle wrapper for stream synchronization.
#pragma once

#include <sycl/sycl.hpp>
#include <memory>
#include <vector>
#include <optional>

#include <torch/python.h>

#include "exception.hpp"

namespace deep_ep {

// A SYCL queue wrapper that provides stream-like semantics.
// On Intel GPUs, we use sycl::queue as the equivalent of cudaStream_t.
// We maintain a dedicated "comm_queue" separate from the compute queue.

struct EventHandle {
    std::shared_ptr<sycl::event> event;

    EventHandle() = default;

    explicit EventHandle(sycl::queue& queue) {
        // Record an event on the given queue by submitting an empty barrier
        auto evt = queue.ext_oneapi_submit_barrier();
        event = std::make_shared<sycl::event>(evt);
    }

    EventHandle(const EventHandle& other) = default;

    void current_stream_wait() const {
        // Wait for this event to complete on the host
        // In a full implementation, we would submit a barrier on the current queue
        // that depends on this event. For now, host-side wait.
        if (event) {
            event->wait();
        }
    }

    void wait() const {
        if (event) {
            event->wait();
        }
    }
};

// Submit a barrier on queue q that waits for queue other to finish its current work.
static inline void queue_wait(sycl::queue& q, sycl::queue& other) {
    auto evt = other.ext_oneapi_submit_barrier();
    q.ext_oneapi_submit_barrier({evt});
}

// Submit a barrier on queue q that waits for the given event.
static inline void queue_wait(sycl::queue& q, const EventHandle& eh) {
    if (eh.event) {
        q.ext_oneapi_submit_barrier({*eh.event});
    }
}

}  // namespace deep_ep

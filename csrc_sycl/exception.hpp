// PORTED_FROM: csrc/kernels/exception.cuh
// Exception handling and assertion macros for the DeepEP SYCL port.
#pragma once

#include <exception>
#include <string>

#include "configs.hpp"

#ifndef EP_STATIC_ASSERT
#define EP_STATIC_ASSERT(cond, reason) static_assert(cond, reason)
#endif

class EPException : public std::exception {
private:
    std::string message = {};

public:
    explicit EPException(const char* name, const char* file, const int line, const std::string& error) {
        message = std::string("Failed: ") + name + " error " + file + ":" + std::to_string(line) + " '" + error + "'";
    }

    const char* what() const noexcept override { return message.c_str(); }
};

#ifndef SYCL_CHECK
#define SYCL_CHECK(expr)                                                          \
    do {                                                                          \
        try {                                                                     \
            (expr);                                                               \
        } catch (const sycl::exception& e) {                                      \
            throw EPException("SYCL", __FILE__, __LINE__, std::string(e.what())); \
        }                                                                         \
    } while (0)
#endif

#ifndef EP_HOST_ASSERT
#define EP_HOST_ASSERT(cond)                                           \
    do {                                                               \
        if (not(cond)) {                                               \
            throw EPException("Assertion", __FILE__, __LINE__, #cond); \
        }                                                              \
    } while (0)
#endif

// HIGH_RISK: Device-side assertion cannot trap on SYCL like CUDA's asm("trap;").
// Using sycl::ext::oneapi::experimental::printf for diagnostics; no abort mechanism.
#ifndef EP_DEVICE_ASSERT
#define EP_DEVICE_ASSERT(cond)                                                        \
    do {                                                                              \
        if (!(cond)) {                                                                \
            /* MEMORY_MODEL_ISSUE: SYCL has no device-side abort equivalent to PTX    \
               trap; assertion failures will print but continue execution. */          \
            sycl::ext::oneapi::experimental::printf(                                  \
                "Assertion failed: %s:%d, condition: %s\n", __FILE__, __LINE__, #cond);\
        }                                                                             \
    } while (0)
#endif

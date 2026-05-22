// PORTED_FROM: csrc/python_api.cpp
// pybind11 module entry point for the DeepEP SYCL port.
// Registers the V1 (legacy) Buffer and Config classes.

#include <pybind11/pybind11.h>
#include <torch/python.h>

#include "legacy/buffer.hpp"

#ifndef TORCH_EXTENSION_NAME
#define TORCH_EXTENSION_NAME _C_sycl
#endif

PYBIND11_MODULE(TORCH_EXTENSION_NAME, m) {
    m.doc() = "DeepEP SYCL port: expert-parallel communication library for Intel GPUs";

    // The integer type of top-k indices
    m.attr("topk_idx_t") = py::cast(c10::CppTypeToScalarType<deep_ep::topk_idx_t>::value);

    // Register legacy buffer APIs
    deep_ep::legacy::register_apis(m);
}

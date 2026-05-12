# PORTED_FROM: csrc/CMakeLists.txt + csrc/kernels/CMakeLists.txt
# Build system for DeepEP SYCL port targeting Intel B60/B70 (BMG) GPUs.

cmake_minimum_required(VERSION 3.20)
project(deep_ep_sycl LANGUAGES CXX)

# =============================================================
# Compiler and SYCL Configuration
# =============================================================

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Intel SYCL compiler
find_package(IntelSYCL QUIET)

# SYCL compilation flags
set(SYCL_FLAGS "-fsycl" "-fsycl-targets=intel_gpu_bmg")
add_compile_options(${SYCL_FLAGS})
add_link_options(${SYCL_FLAGS})

# Sub-group size
add_compile_definitions(SUBGROUP_SIZE=32)

# Optional: fast debug mode
option(ENABLE_FAST_DEBUG "Enable fast debug with shorter timeouts" OFF)
if(ENABLE_FAST_DEBUG)
    add_compile_definitions(ENABLE_FAST_DEBUG)
endif()

# Optional: topk_idx bits
set(TOPK_IDX_BITS 64 CACHE STRING "Number of bits for topk index type (32 or 64)")
add_compile_definitions(TOPK_IDX_BITS=${TOPK_IDX_BITS})

# =============================================================
# ishmem Configuration
# =============================================================

option(DISABLE_ISHMEM "Disable ishmem (for unit testing infrastructure only)" OFF)
if(DISABLE_ISHMEM)
    add_compile_definitions(DISABLE_ISHMEM)
else()
    # Find ishmem
    set(ISHMEM_DIR "" CACHE PATH "Path to ishmem installation")
    if(ISHMEM_DIR)
        include_directories(${ISHMEM_DIR}/include)
        link_directories(${ISHMEM_DIR}/lib)
    endif()
endif()

# =============================================================
# tvisa Configuration (for named barriers and cache-controlled loads)
# =============================================================

set(TVISA_DIR "" CACHE PATH "Path to tvisa source (https://github.com/CaoZhongZ/tvisa)")
if(TVISA_DIR)
    include_directories(${TVISA_DIR}/include)
endif()

# =============================================================
# Level Zero Configuration (for IPC handles)
# =============================================================

find_package(LevelZero QUIET)
if(LevelZero_FOUND)
    include_directories(${LevelZero_INCLUDE_DIRS})
endif()

# =============================================================
# Source Files
# =============================================================

set(SYCL_INFRA_HEADERS
    configs.hpp
    exception.hpp
    utils.hpp
    buffer.hpp
)

set(SYCL_KERNEL_SOURCES
    internode_dispatch.cpp
    # internode_combine.cpp      # TODO: Phase 3b
    # internode_ll_dispatch.cpp  # TODO: Phase 3c
    # internode_ll_combine.cpp   # TODO: Phase 3d
    # runtime.cpp                # TODO: ishmem init/finalize
)

# =============================================================
# Library Target
# =============================================================

add_library(deep_ep_sycl SHARED ${SYCL_KERNEL_SOURCES})

target_include_directories(deep_ep_sycl PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

if(NOT DISABLE_ISHMEM AND ISHMEM_DIR)
    target_link_libraries(deep_ep_sycl PUBLIC ishmem)
endif()

if(LevelZero_FOUND)
    target_link_libraries(deep_ep_sycl PUBLIC ${LevelZero_LIBRARIES})
endif()

# =============================================================
# Install
# =============================================================

install(TARGETS deep_ep_sycl LIBRARY DESTINATION lib)
install(FILES ${SYCL_INFRA_HEADERS} DESTINATION include/deep_ep_sycl)

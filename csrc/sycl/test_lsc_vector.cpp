#include <iostream>
#include <sycl/sycl.hpp>

// tvisa headers (from /home/sdp/zhenyuan/tvisa)
#include "cxxopts.hpp"
#include "sycl_misc.hpp"
#include "gen_visa_templates.hpp"

// Minimal scope guard (from tvisa's utils.hpp, avoid conflict with local utils.hpp)
template <typename F>
class __scope_guard {
  F f;
public:
  __scope_guard(const F &f) : f(f) {}
  ~__scope_guard() { f(); }
};

#define SG_SZ 32

template <typename T>
void fill_sequential(T *p, int rank, size_t nelems) {
  for (size_t i = 0; i < nelems; ++ i) {
    p[i] = i + rank;
  }
}

// LSC load & store test with d32x4 (32-bit × 4 vector)
// Each work-item processes a sycl::vec<uint32_t, 4>
template <typename T>
struct lsc_d32x4_load {
  lsc_d32x4_load(T* dst, T* src)
    : src(src), dst(dst) {}

  void operator() [[sycl::reqd_sub_group_size(SG_SZ)]] (sycl::id<1> index) const {
#if defined(__SYCL_DEVICE_ONLY__)
    using vector_t = typename T::vector_t;
    vector_t tmp;
    auto* saddr = (void *)(src + index);

    // LSC load: lsc_load.ugm.<cache> (M1, <simd>) dst:d32x4 flat[src]:a64
    asm volatile ("\n"
        "lsc_load.ugm.uc.uc (M1, 32) %0:d32x4 flat[%1]:a64\n"
        : "=rw"(tmp) : "rw"(saddr));

    reinterpret_cast<vector_t&>(dst[index]) = tmp;
#else
    dst[index] = src[index];
#endif
  }

private:
  T* src;
  T* dst;
};

template <typename T>
struct lsc_d32x4_store {
  lsc_d32x4_store(T* dst, T* src)
    : src(src), dst(dst) {}

  void operator() [[sycl::reqd_sub_group_size(SG_SZ)]] (sycl::id<1> index) const {
#if defined(__SYCL_DEVICE_ONLY__)
    using vector_t = typename T::vector_t;
    vector_t tmp = reinterpret_cast<const vector_t&>(src[index]);
    auto* daddr = (void *)(dst + index);

    // LSC store: lsc_store.ugm.<cache> (M1, <simd>) flat[dst]:a64 src:d32x4
    asm volatile ("\n"
        "lsc_store.ugm.uc.uc (M1, 32) flat[%0]:a64 %1:d32x4\n"
        :: "rw"(daddr), "rw"(tmp));
#else
    dst[index] = src[index];
#endif
  }

private:
  T* src;
  T* dst;
};

int main(int argc, char *argv[]) {
  cxxopts::Options opts("LSC_d32x4", "LSC load/store test with d32x4 bit size");
  opts.allow_unrecognised_options();
  opts.add_options()
    ("s,size", "Number of vec4 elements", cxxopts::value<size_t>()->default_value("1024"))
    ;

  auto parsed_opts = opts.parse(argc, argv);
  auto num_vec4 = parsed_opts["size"].as<size_t>();

  // Total number of uint32_t elements = num_vec4 * 4
  size_t total_u32 = num_vec4 * 4;
  size_t alloc_size = total_u32 * sizeof(uint32_t);

  std::cout << "Testing LSC d32x4 load/store" << std::endl;
  std::cout << "  vec4 elements: " << num_vec4 << std::endl;
  std::cout << "  total uint32_t: " << total_u32 << std::endl;
  std::cout << "  alloc size: " << alloc_size << " bytes" << std::endl;

  auto queue = currentQueue(0, 0);

  auto* src = sycl::malloc_device<uint32_t>(total_u32, queue);
  auto* dst = sycl::malloc_device<uint32_t>(total_u32, queue);
  auto* b_host = sycl::malloc_host<uint32_t>(total_u32, queue);
  auto* b_check = sycl::malloc_host<uint32_t>(total_u32, queue);

  __scope_guard __guard([&]{
    sycl::free(src, queue);
    sycl::free(dst, queue);
    sycl::free(b_host, queue);
    sycl::free(b_check, queue);
  });

  // Initialize source data
  fill_sequential(b_host, 1, total_u32);
  queue.memcpy(src, b_host, alloc_size);
  queue.memset(dst, 0, alloc_size);
  queue.wait();

  // Phase 1: LSC load test — load src into dst
  queue.submit([&](sycl::handler &h) {
    h.parallel_for(sycl::range<1>{num_vec4},
        lsc_d32x4_load(
          reinterpret_cast<sycl::vec<uint32_t, 4> *>(dst),
          reinterpret_cast<sycl::vec<uint32_t, 4> *>(src)));
  });

  queue.memcpy(b_check, dst, alloc_size);
  queue.wait();

  // Verify load
  int errors = 0;
  for (size_t i = 0; i < total_u32; ++ i) {
    if (b_check[i] != b_host[i]) {
      if (errors < 10) {
        std::cout << "  LOAD MISMATCH @" << i
                  << ": expected=" << b_host[i]
                  << " got=" << b_check[i] << std::endl;
      }
      errors++;
    }
  }

  if (errors == 0) {
    std::cout << "PASSED: LSC d32x4 load verified correct ("
              << total_u32 << " elements)" << std::endl;
  } else {
    std::cout << "FAILED: LSC d32x4 load — " << errors << " mismatches out of "
              << total_u32 << " elements" << std::endl;
  }

  // Phase 2: LSC store test — store from src into dst (reset dst first)
  queue.memset(dst, 0, alloc_size);
  queue.wait();

  queue.submit([&](sycl::handler &h) {
    h.parallel_for(sycl::range<1>{num_vec4},
        lsc_d32x4_store(
          reinterpret_cast<sycl::vec<uint32_t, 4> *>(dst),
          reinterpret_cast<sycl::vec<uint32_t, 4> *>(src)));
  });

  queue.memcpy(b_check, dst, alloc_size);
  queue.wait();

  // Verify store
  int store_errors = 0;
  for (size_t i = 0; i < total_u32; ++ i) {
    if (b_check[i] != b_host[i]) {
      if (store_errors < 10) {
        std::cout << "  STORE MISMATCH @" << i
                  << ": expected=" << b_host[i]
                  << " got=" << b_check[i] << std::endl;
      }
      store_errors++;
    }
  }

  if (store_errors == 0) {
    std::cout << "PASSED: LSC d32x4 store verified correct ("
              << total_u32 << " elements)" << std::endl;
  } else {
    std::cout << "FAILED: LSC d32x4 store — " << store_errors << " mismatches out of "
              << total_u32 << " elements" << std::endl;
  }

  return (errors + store_errors) > 0 ? 1 : 0;
}

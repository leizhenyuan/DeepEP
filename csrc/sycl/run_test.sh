#!/bin/bash

# Build and test the SYCL layout kernel

echo "========================================"
echo "Building SYCL layout test..."
echo "========================================"

cd "$(dirname "$0")"

# Source Intel oneAPI environment if not already done
if [ -z "$ONEAPI_ROOT" ]; then
    echo "Sourcing Intel oneAPI environment..."
    source /home/gta/intel/oneapi/setvars.sh
fi

# Compile
echo ""
echo "Compiling..."
icpx -fsycl -fsycl-targets=spir64_gen -Xs "-device pvc" \
    -O3 -std=c++17 \
    -DNUM_MAX_NVL_PEERS=8 \
    -Dtopk_idx_t=int32_t \
    test_layout.cpp layout.cpp \
    -o test_layout

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Compilation failed!"
    exit 1
fi

echo ""
echo "✅ Compilation successful!"
echo ""
echo "========================================"
echo "Running tests..."
echo "========================================"
echo ""

# Run tests
./test_layout

exit_code=$?

echo ""
if [ $exit_code -eq 0 ]; then
    echo "✅ All tests passed!"
else
    echo "❌ Tests failed with exit code $exit_code"
fi

exit $exit_code

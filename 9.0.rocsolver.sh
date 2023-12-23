#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/rocSOLVER $ROCM_TMP_DIR/rocsolver
git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/hipSOLVER $ROCM_TMP_DIR/hipsolver

export LD_LIBRARY_PATH=$ROCM_INSTALL_PREFIX/lib

pushd $ROCM_TMP_DIR/rocsolver
rm -rf build
cmake -S . -B build -G Ninja \
  -DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

pushd $ROCM_TMP_DIR/hipsolver
rm -rf build
cmake -S . -B build -G Ninja \
  -DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd


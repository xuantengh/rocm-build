#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# git clone https://github.com/RadeonOpenCompute/llvm-project.git $ROCM_TMP_DIR/llvm-git-$ROCM_VERSION -b amd-stg-open --depth 1
git clone https://github.com/ROCm/ROCm-Device-Libs.git $ROCM_TMP_DIR/device-libs -b rocm-$ROCM_VERSION --depth 1

pushd $ROCM_TMP_DIR/device-libs
LLVM_BUILD=$ROCM_TMP_DIR/llvm-project-$ROCM_VERSION/build
rm -rf build

cmake -S . -B build -G "Ninja" \
-DCMAKE_C_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang++ \
-DCMAKE_PREFIX_PATH="$LLVM_BUILD;$ROCM_INSTALL_PREFIX" \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build build
cmake --build build -t install
popd


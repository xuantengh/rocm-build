#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

LLVM_DIR=$ROCM_TMP_DIR/llvm-project

# git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/llvm-project $LLVM_DIR

pushd $LLVM_DIR
rm -rf build
cmake -S llvm -B build -G "Ninja" \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_COMPILER=gcc \
-DCMAKE_CXX_COMPILER=g++ \
-DLLVM_INCLUDE_TESTS=OFF \
-DLLVM_ENABLE_PROJECTS="llvm;clang;lld" \
-DLLVM_ENABLE_RUNTIMES="compiler-rt" \
-DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,$ROCM_INSTALL_PREFIX/lib" \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
-DLLVM_TARGETS_TO_BUILD="X86;AMDGPU" \
-DLLVM_BUILD_TESTS=OFF -DLLVM_INCLUDE_TESTS=OFF

cmake --build build
cmake --build build -t install
popd


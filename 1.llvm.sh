#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# LLVM, git is too slow to download, using wget instead
# git clone https://github.com/RadeonOpenCompute/llvm-project.git -b rocm-$ROCM_VERSION $ROCM_TMP_DIR/llvm
download_repo_and_extract "https://github.com/ROCm/llvm-project/archive/refs/tags/rocm-$ROCM_VERSION.tar.gz" "llvm"

pushd $ROCM_TMP_DIR/llvm-project-rocm-$ROCM_VERSION
rm -rf build
cmake -S llvm -B build -G "Ninja" \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_COMPILER=gcc \
-DCMAKE_CXX_COMPILER=g++ \
-DLLVM_INCLUDE_TESTS=OFF \
-DLLVM_ENABLE_PROJECTS="llvm;clang;lld" \
-DLLVM_ENABLE_RUNTIMES="compiler-rt" \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
-DLLVM_TARGETS_TO_BUILD="X86;AMDGPU"

cmake --build build
cmake --build build -t install
popd

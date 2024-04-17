#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

LLVM_DIR=$ROCM_TMP_DIR/llvm-project
DEVICE_LIBS_DIR=$LLVM_DIR/amd/device-libs

# comgr has been a part of AMD llvm-project
pushd $LLVM_DIR/amd/comgr
rm -rf build

ROCM_PATH=$ROCM_INSTALL_PREFIX \
cmake -S . -B build -G "Ninja" \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang++ \
-DCMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX \
-DROCM_DIR=$ROCM_INSTALL_PREFIX \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build build
cmake --build build -t install
popd


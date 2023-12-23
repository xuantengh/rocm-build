#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

LLVM_DIR=$ROCM_TMP_DIR/llvm-project
DEVICE_LIBS_DIR=$ROCM_TMP_DIR/device-libs

git clone https://github.com/ROCm/ROCm-CompilerSupport $ROCM_TMP_DIR/comgr -b rocm-$ROCM_VERSION --depth 1

pushd $ROCM_TMP_DIR/comgr
rm -rf build

ROCM_PATH=$ROCM_INSTALL_PREFIX \
cmake -S lib/comgr -B build -G "Ninja" \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang++ \
-DCMAKE_PREFIX_PATH="$LLVM_DIR/build;$DEVICE_LIBS_DIR/build" \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build build
cmake --build build -t install
popd


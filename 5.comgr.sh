#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone https://github.com/ROCm/ROCm-CompilerSupport $ROCM_TMP_DIR/comgr -b rocm-$ROCM_VERSION --depth 1

LLVM_BUILD=$ROCM_TMP_DIR/llvm-project-$ROCM_VERSION/build
DEVICE_LIBS_BUILD=$ROCM_TMP_DIR/device-libs/build

set -e
pushd $ROCM_TMP_DIR/comgr
rm -rf build
cmake -S lib/comgr -B build -G "Ninja" \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang++ \
-DCMAKE_PREFIX_PATH="$LLVM_BUILD;$DEVICE_LIBS_BUILD;$ROCM_INSTALL_PREFIX" \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build build
cmake --build build -t install
popd


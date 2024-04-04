#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# ROCt
git clone https://github.com/ROCm/ROCT-Thunk-Interface $ROCM_TMP_DIR/roct -b rocm-$ROCM_VERSION --depth 1
pushd $ROCM_TMP_DIR/roct
rm -rf build
cmake -S . -B build -G "Ninja" -DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

# ROCr
git clone https://github.com/ROCm/ROCR-Runtime $ROCM_TMP_DIR/rocr -b rocm-$ROCM_VERSION --depth 1
pushd $ROCM_TMP_DIR/rocr
rm -rf build
cmake -S src -B build -G "Ninja" \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
-Dhsakmt_DIR=$ROCM_INSTALL_PRERIX/lib/cmake/hsakmt \
-DLLVM_DIR=$ROCM_INSTALL_PREFIX/lib/cmake \
-DIMAGE_SUPPORT=OFF
cmake --build build
cmake --build build -t install
popd


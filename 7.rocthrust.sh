#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/rocPRIM $ROCM_TMP_DIR/rocPRIM
git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/rocThrust $ROCM_TMP_DIR/rocThrust

export LD_LIBRARY_PATH=$ROCM_INSTALL_PREFIX/lib

pushd $ROCM_TMP_DIR/rocPRIM
rm -rf build
cmake -S . -B build -G "Ninja" \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
-DAMDGPU_TARGETS=$ROCM_GPU_ARCH
cmake --build build
cmake --build build -t install
popd

pushd $ROCM_TMP_DIR/rocThrust
rm -rf build
cmake -S . -B build -G "Ninja" -DCMAKE_BUILD_TYPE=Release \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
-DROCM_PATH=$ROCM_INSTALL_PREFIX \
-DAMDGPU_TARGETS=$ROCM_GPU_ARCH \
-DBUILD_TEST=OFF
cmake --build build
cmake --build build -t install
popd


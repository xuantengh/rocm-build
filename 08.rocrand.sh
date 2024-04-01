#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/rocRAND $ROCM_TMP_DIR/rocrand
git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/hipRAND $ROCM_TMP_DIR/hiprand

export LD_LIBRARY_PATH=$ROCM_INSTALL_PREFIX/lib

pushd $ROCM_TMP_DIR/rocrand
git submodule update --init
rm -rf build

cmake -S . -B build -G Ninja \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build build
cmake --build build -t install
popd

# https://github.com/ROCm/hipRAND/wiki/Build
pushd $ROCM_TMP_DIR/hiprand
rm -rf build

cmake -S . -B build -G Ninja \
-DROCM_PATH=$ROCM_INSTALL_PREFIX \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build build
cmake --build build -t install
popd


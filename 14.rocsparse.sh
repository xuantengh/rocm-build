#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/rocSPARSE $ROCM_TMP_DIR/rocsparse
git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/hipSPARSE $ROCM_TMP_DIR/hipsparse

pushd $ROCM_TMP_DIR/rocsparse
rm -rf build
export LD_LIBRARY_PATH=$ROCM_INSTALL_PREFIX/lib

cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
-DCMAKE_Fortran_COMPILER=`which gfortran` \
-DBUILD_CLIENTS_TESTS=OFF \
-DBUILD_CLIENTS_BENCHMARKS=OFF \
-DBUILD_CLIENTS_SAMPLES=OFF \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build build
cmake --build build -t install
unset LD_LIBRARY_PATH
popd

# https://github.com/ROCm/hipSPARSE/wiki/Build
pushd $ROCM_TMP_DIR/hipsparse
rm -rf build
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_MODULE_PATH=$ROCM_INSTALL_PREFIX/lib/cmake/rocsparse \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
  -DBUILD_CLIENTS_BENCHMARKS=OFF -DBUILD_CLIENTS_SAMPLES=OFF
cmake --build build
cmake --build build -t install
popd


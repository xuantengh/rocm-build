#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/rocFFT $ROCM_TMP_DIR/rocfft
git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/hipFFT $ROCM_TMP_DIR/hipfft

source $HOME/softwares/init/bash
module load rocm/$ROCM_VERSION

pushd $ROCM_TMP_DIR/rocfft
rm -rf build
cmake -S . -B build -G Ninja \
  -DCMAKE_C_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
  -DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
  -DAMDGPU_TARGETS=$ROCM_GPU_ARCH \
  -DBUILD_CLIENTS_RIDER=OFF \
  -DBUILD_CLIENTS_TESTS=OFF \
  -DBUILD_CLIENTS_SAMPLES=OFF

cmake --build build
cmake --build build -t install
popd

pushd $ROCM_TMP_DIR/hipfft
git submodule update --init
rm -rf build
cmake -S . -B build -G Ninja \
  -DCMAKE_C_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
  -DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
  -DCMAKE_BUILD_TYPE=Release \
  -DAMDGPU_TARGETS=$ROCM_GPU_ARCH \
  -DCMAKE_MODULE_PATH=$ROCM_INSTALL_PREFIX/lib/cmake/hip \
  -DHIP_ROOT_DIR=$ROCM_INSTALL_PREFIX \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
  -DBUILD_CLIENTS=OFF

cmake --build build
cmake --build build -t install
popd

module purge


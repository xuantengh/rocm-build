#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/rocBLAS $ROCM_TMP_DIR/rocblas
git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/hipBLAS $ROCM_TMP_DIR/hipblas
# git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/hipBLASLt $ROCM_TMP_DIR/hipblaslt

pushd $ROCM_TMP_DIR/rocblas
# CC=$ROCM_INSTALL_PREFIX/bin/clang \
# CXX=$ROCM_INSTALL_PREFIX/bin/hipcc \
# cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=toolchain-linux.cmake \
# -DROCM_PATH=$ROCM_INSTALL_PREFIX \
# -DAMDGPU_TARGETS=$ROCM_GPU_ARCH \
# -DCMAKE_BUILD_TYPE=Release \
# -DTensile_LOGIC=asm_full \
# -DTensile_CODE_OBJECT_VERSION=V3 \
# -DTensile_SEPARATE_ARCHITECTURES=ON \
# -DTensile_LAZY_LIBRARY_LOADING=ON \
# -DTensile_LIBRARY_FORMAT=msgpack \
# -DTensile_COMPILER=hipcc \
# -DRUN_HEADER_TESTING=OFF \
# -DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=ON \
# -DCPACK_SET_DESTDIR=OFF \
# -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

CC=$ROCM_INSTALL_PREFIX/bin/clang \
CXX=$ROCM_INSTALL_PREFIX/bin/hipcc \
ROCM_PATH=$ROCM_INSTALL_PREFIX \
CMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX/lib/cmake \
./install.sh -a $ROCM_GPU_ARCH

cp -r $ROCM_TMP_DIR/rocblas/build/release/rocblas-install/* $ROCM_INSTALL_PREFIX/
popd

pushd $ROCM_TMP_DIR/hipblas
rm -rf build
ROCM_PATH=$ROCM_INSTALL_PREFIX \
./install.sh -n -r --hip-clang \
--rocblas-path=$ROCM_INSTALL_PREFIX \
--compiler=$ROCM_INSTALL_PREFIX/bin/hipcc
cmake --build build/release -t install
popd


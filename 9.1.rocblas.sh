#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/rocBLAS $ROCM_TMP_DIR/rocblas
git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/hipBLAS $ROCM_TMP_DIR/hipblas
git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/hipBLASLt $ROCM_TMP_DIR/hipblaslt

git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/rocSOLVER $ROCM_TMP_DIR/rocsolver
git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/hipSOLVER $ROCM_TMP_DIR/hipsolver


export LD_LIBRARY_PATH=$ROCM_INSTALL_PREFIX/lib

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

rm -rf build

CC=$ROCM_INSTALL_PREFIX/bin/clang \
CXX=$ROCM_INSTALL_PREFIX/bin/hipcc \
ROCM_PATH=$ROCM_INSTALL_PREFIX \
CMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX/lib/cmake \
TENSILE_ROCM_ASSEMBLER_PATH=$ROCM_INSTALL_PREFIX/bin/clang \
TENSILE_ROCM_OFFLOAD_BUNDLER_PATH=$ROCM_INSTALL_PREFIX/bin/clang-offload-bundler \
./install.sh -a $ROCM_GPU_ARCH

cp -r $ROCM_TMP_DIR/rocblas/build/release/rocblas-install/* $ROCM_INSTALL_PREFIX/
popd

pushd $ROCM_TMP_DIR/rocsolver
rm -rf build
cmake -S . -B build -G Ninja \
  -DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

pushd $ROCM_TMP_DIR/hipsolver
rm -rf build
cmake -S . -B build -G Ninja \
  -DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd


pushd $ROCM_TMP_DIR/hipblas
rm -rf build
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
-DCMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX \
-DROCM_PATH=$ROCM_INSTALL_PREFIX \
-DROCM_DISABLE_LDCONFIG=ON \
-DBUILD_WITH_SOLVER=ON \
-DCMAKE_EXE_LINKER_FLAGS=" -Wl,--enable-new-dtags -Wl,--rpath,$ROCM_INSTALL_PREFIX/lib " \
-DCMAKE_SHARED_LINKER_FLAGS=" -Wl,--enable-new-dtags -Wl,--rpath,$ROCM_INSTALL_PREFIX/lib " \
-DBUILD_CLIENTS_TESTS=OFF -DBUILD_CLIENTS_BENCHMARKS=OFF -DBUILD_CLIENTS_SAMPLES=OFF
cmake --build build
cmake --build build -t install
popd

# hipBLASLt supports only gfx90a (MI200 series) GPUs now

# pushd $ROCM_TMP_DIR/hipblaslt
# rm -rf build
# 
# PATH=$ROCM_INSTALL_PREFIX/bin:$PATH \
# Clang_DIR=$ROCM_INSTALL_PREFIX/lib/cmake/clang \
# ROCM_PATH=$ROCM_INSTALL_PREFIX \
# cmake  -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
# -DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
# -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
# -DCMAKE_SHARED_LINKER_FLAGS=" -Wl,--enable-new-dtags -Wl,--rpath,$ROCM_INSTALL_PREFIX/lib " \
# -DCMAKE_PREFIX_PATH="$ROCM_INSTALL_PREFIX" \
# -DCMAKE_MODULE_PATH="$ROCM_INSTALL_PREFIX/lib/cmake;" \
# -DROCM_DISABLE_LDCONFIG=ON \
# -DROCM_PATH=$ROCM_INSTALL_PREFIX \
# -DAMDGPU_TARGETS=$ROCM_GPU_ARCH \
# -DTensile_TEST_LOCAL_PATH=$PWD/tensilelite \
# -DBUILD_CLIENTS_SAMPLES=OFF -DBUILD_CLIENTS_TESTS=OFF -DBUILD_CLIENTS_BENCHMARKS=OFF
# cmake --build build
# cmake --build build -t install
# popd


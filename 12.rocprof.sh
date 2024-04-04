#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/rocprofiler $ROCM_TMP_DIR/rocprofiler
git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/roctracer $ROCM_TMP_DIR/roctracer

# Install hsa-amd-aqlprofile package
wget https://repo.radeon.com/rocm/apt/6.0.2/pool/main/h/hsa-amd-aqlprofile/hsa-amd-aqlprofile_1.0.0.60002.60002-115~22.04_amd64.deb \
  -O $ROCM_TMP_DIR/hsa-amd-aqlprofile_$ROCM_VERSION.deb
dpkg-deb -R $ROCM_TMP_DIR/hsa-amd-aqlprofile_$ROCM_VERSION.deb $ROCM_TMP_DIR/aql_$ROCM_VERSION
cp -r $ROCM_TMP_DIR/aql_$ROCM_VERSION/opt/rocm-$ROCM_VERSION/* $ROCM_INSTALL_PREFIX

source $HOME/softwares/init/bash
module load rocm/$ROCM_VERSION

pushd $ROCM_TMP_DIR/roctracer
rm -rf build
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX \
  -DCMAKE_MODULE_PATH=$ROCM_INSTALL_PREFIX/lib/cmake/hip \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
  -DCMAKE_SHARED_LINKER_FLAGS=" -Wl,--enable-new-dtags -Wl,--rpath,$ROCM_INSTALL_PREFIX/lib "
cmake --build build
cmake --build build -t install
popd

pushd $ROCM_TMP_DIR/rocprofiler
rm -rf build

ROCM_PATH=$ROCM_INSTALL_PREFIX \
cmake -S . -B build -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DROCPROFILER_BUILD_CI=1 \
  -DROCPROFILER_BUILD_TESTS=1 \
  -DROCPROFILER_BUILD_SAMPLES=1 \
  -DGPU_TARGETS=$ROCM_GPU_ARCH \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_PREFIX_PATH="$ROCM_INSTALL_PREFIX/llvm;$ROCM_INSTALL_PREFIX" \
  -DCMAKE_MODULE_PATH="$ROCM_INSTALL_PREFIX/lib/cmake;$ROCM_INSTALL_PREFIX/lib/cmake/hip" \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=FALSE \
  -DCMAKE_SHARED_LINKER_FLAGS=" -Wl,--enable-new-dtags -Wl,--rpath,$ROCM_INSTALL_PREFIX/lib "

cmake --build build --parallel 32
cmake --build build -t install
popd

module purge

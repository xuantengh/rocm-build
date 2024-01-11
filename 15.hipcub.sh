#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/hipCUB $ROCM_TMP_DIR/hipcub

export LD_LIBRARY_PATH=$ROCM_INSTALL_PREFIX/lib

pushd $ROCM_TMP_DIR/hipcub
rm -rf build
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DBUILD_TEST=OFF -DBUILD_BENCHMARK=OFF -DDEPENDENCIES_FORCE_DOWNLOAD=OFF \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
-DCMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build build
cmake --build build -t install
popd


#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/rccl $ROCM_TMP_DIR/rccl
git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/HIPIFY $ROCM_TMP_DIR/hipify

source $HOME/softwares/init/bash
module load rocm/$ROCM_VERSION

pushd $ROCM_TMP_DIR/hipify
rm -rf build
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX \
-DCMAKE_INSTALL_PREFIX=$ROCM_TMP_DIR/hipify/install
cmake --build build
cmake --build build -t install
popd

pushd $ROCM_TMP_DIR/rccl
rm -rf build

mkdir -p $ROCM_INSTALL_PREFIX/.info
rm -f $ROCM_INSTALL_PREFIX/.info/version
echo $ROCM_VERSION > $ROCM_INSTALL_PREFIX/.info/version

cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
-DCMAKE_PREFIX_PATH="$ROCM_INSTALL_PREFIX;$ROCM_TMP_DIR/hipify/install" \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

module purge


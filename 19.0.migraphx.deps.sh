#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# https://github.com/ROCm/AMDMIGraphX
eval "$($CONDA_PATH/bin/conda shell.bash hook)"
conda activate $CONDA_ENV
which python3
which pip3

pip3 install protobuf

git clone https://github.com/msgpack/msgpack-c --depth 1 -b cpp-6.1.0 $ROCM_TMP_DIR/msgpack
pushd $ROCM_TMP_DIR/msgpack
rm -rf build
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
  -DMSGPACK_BUILD_TESTS=OFF \
  -DMSGPACK_BUILD_EXAMPLES=OFF
cmake --build build
cmake --build build -t install
popd

#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

if [ ! -d $ROCM_TMP_DIR/pytorch ]; then
  git clone https://github.com/pytorch/pytorch $ROCM_TMP_DIR/pytorch -b v2.1.2 --depth 1
  pushd $ROCM_TMP_DIR/pytorch
    git submodule sync
    git submodule update --init --recursive
    python3 tools/amd_build/build_amd.py
  popd
fi

eval "$($HOME/miniconda3/bin/conda shell.bash hook)"
if conda env list | grep -q "pytorch"; then
  conda activate pytorch
  which python3
  pushd $ROCM_TMP_DIR/pytorch
    rm -rf build

    export _GLIBCXX_USE_CXX11_ABI=1
    export CMAKE_PREFIX_PATH="$HOME/miniconda3/envs/pytorch;$HOME/opt/rocm/6.0.0"
    export USE_KINETO=0
    export USE_LMDB=1
    export BUILD_CAFFE2=0
    export BUILD_CAFFE2_OPS=0
    export USE_NUMPY=1
    export USE_ROCM=1
    export USE_CUDA=0
    export BUILD_TEST=0
    export PYTORCH_ROCM_ARCH=$ROCM_GPU_ARCH
    export MIOPEN_LIB_DIR=$HOME/opt/rocm/6.0.0/lib
    export USE_NNPACK=0
    export USE_QNNPACK=0
    export USE_XNNPACK=0
    python setup.py develop
  popd
else
  conda create -y -n "pytorch" python=3.11
  conda activate pytorch
  pushd $ROCM_TMP_DIR/pytorch
    conda install -y mkl mkl-include pyyaml
    pip3 install -r requirements.txt
  popd
fi


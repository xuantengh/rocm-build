#!/bin/bash

# Define some environment variables
export ROCM_VERSION=6.1.0
USER_DIR=/mnt/data0/hxt
export ROCM_TMP_DIR=$USER_DIR/tmp/rocm.$ROCM_VERSION
export ROCM_INSTALL_PREFIX=$USER_DIR/opt/rocm/$ROCM_VERSION
# export ROCM_GPU_ARCH=gfx1030
export ROCM_GPU_ARCH=gfx908

mkdir -p $ROCM_TMP_DIR

export MIOPEN_TMP_DIR=$ROCM_TMP_DIR/miopen.deps
mkdir -p $MIOPEN_TMP_DIR
export TORCH_TMP_DIR=$ROCM_TMP_DIR/torch.deps
mkdir -p $TORCH_TMP_DIR

export MODULE_PREFIX=$HOME/softwares
mkdir -p $MODULE_PREFIX/modulefiles/rocm

CONDA_PATH=$HOME/miniconda3
CONDA_ENV=pytorch.$ROCM_VERSION
CONDA_PYTHON_VERSION=3.10

PYTORCH_BRANCH=v2.2.2
VISION_VERSION=v0.17.2
TEXT_VERSION=v0.17.2

set -e

function download_repo_and_extract {
  echo "Download from $1, extract to $ROCM_TMP_DIR/$2"
  wget $1 -O $ROCM_TMP_DIR/$2.tar.gz
  tar -zxvf $ROCM_TMP_DIR/$2.tar.gz -C $ROCM_TMP_DIR
}

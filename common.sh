#!/bin/bash

# Define some environment variables
export ROCM_VERSION=6.0.0
export ROCM_TMP_DIR=$HOME/tmp/rocm.$ROCM_VERSION
export ROCM_INSTALL_PREFIX=$HOME/opt/rocm/$ROCM_VERSION
# export ROCM_GPU_ARCH=gfx1030
export ROCM_GPU_ARCH=gfx908

mkdir -p $ROCM_TMP_DIR

export MIOPEN_TMP_DIR=$ROCM_TMP_DIR/miopen.deps
mkdir -p $MIOPEN_TMP_DIR
export TORCH_TMP_DIR=$ROCM_TMP_DIR/torch.extra
mkdir -p $TORCH_TMP_DIR

CONDA_PATH=$HOME/miniconda3
CONDA_ENV=pt.revise

PYTORCH_BRANCH=v2.2.0-rc8
VISION_VERSION=v0.17.0-rc4
TEXT_VERSION=v0.17.0-rc1

set -e

function download_repo_and_extract {
  echo "Download from $1, extract to $ROCM_TMP_DIR/$2"
  wget $1 -O $ROCM_TMP_DIR/$2.tar.gz
  tar -zxvf $ROCM_TMP_DIR/$2.tar.gz -C $ROCM_TMP_DIR
}

#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

eval "$($CONDA_PATH/bin/conda shell.bash hook)"
conda activate pytorch

TEXT_VERSION=v0.17.0-rc1

git clone https://github.com/pytorch/text $TORCH_TMP_DIR/text --depth 1 -b $TEXT_VERSION

export LD_LIBRARY_PATH=$ROCM_INSTALL_PREFIX/lib
pushd $TORCH_TMP_DIR/text
git submodule update --init --recursive
rm -rf build
python setup.py develop
popd


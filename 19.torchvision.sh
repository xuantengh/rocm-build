#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

eval "$($CONDA_PATH/bin/conda shell.bash hook)"
conda activate pytorch
conda install -y libpng libjpeg-turbo -c pytorch

VISION_VERSION=v0.17.0-rc1

git clone https://github.com/pytorch/vision $TORCH_TMP_DIR/vision --depth 1 -b $VISION_VERSION
pip3 install flake8 mypy pytest pytest-mock scipy

export LD_LIBRARY_PATH=$ROCM_INSTALL_PREFIX/lib
pushd $TORCH_TMP_DIR/vision
rm -rf build
python setup.py develop
popd

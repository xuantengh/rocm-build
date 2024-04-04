#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

eval "$($CONDA_PATH/bin/conda shell.bash hook)"
conda activate $CONDA_ENV
conda install -y libpng libjpeg-turbo -c pytorch

git clone https://github.com/pytorch/vision $TORCH_TMP_DIR/vision --depth 1 -b $VISION_VERSION
pip3 install flake8 mypy pytest pytest-mock scipy

source $HOME/softwares/init/bash
module load rocm/$ROCM_VERSION

pushd $TORCH_TMP_DIR/vision
rm -rf build
python setup.py develop
popd

python3 -c "import torchvision"


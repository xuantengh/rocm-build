#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

eval "$($CONDA_PATH/bin/conda shell.bash hook)"
conda activate $CONDA_ENV

git clone https://github.com/pytorch/text $TORCH_TMP_DIR/text --depth 1 -b $TEXT_VERSION

source $HOME/softwares/init/bash
module load rocm/$ROCM_VERSION

pushd $TORCH_TMP_DIR/text
git submodule update --init --recursive
rm -rf build
python setup.py develop
popd

python3 -c "import torchtext"


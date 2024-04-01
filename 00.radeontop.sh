#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone --depth 1 https://github.com/clbr/radeontop.git $ROCM_TMP_DIR/radeontop

pushd $ROCM_TMP_DIR/radeontop
make
cp radeontop $HOME/softwares/bin
popd

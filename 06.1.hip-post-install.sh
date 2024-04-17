#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

python3 $SCRIPT_DIR/../../misc/envm_generator.py $ROCM_INSTALL_PREFIX > $HOME/softwares/modulefiles/rocm/$ROCM_VERSION


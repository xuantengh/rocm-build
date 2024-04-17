#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# https://github.com/ROCm/AMDMIGraphX
eval "$($CONDA_PATH/bin/conda shell.bash hook)"
conda activate $CONDA_ENV
which python3
which pip3

source $HOME/softwares/init/bash
module load rocm/$ROCM_VERSION

pip3 install pybind11
# TODO: change to release tag, use develop as for now due to blaze removal has not been release yet
# https://github.com/ROCm/AMDMIGraphX/issues/2681
git clone https://github.com/ROCm/AMDMIGraphX -b develop --depth 1 $ROCM_TMP_DIR/migraphx

pushd $ROCM_TMP_DIR/migraphx
rm -rf build

which python3

cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_PREFIX_PATH="$ROCM_INSTALL_PREFIX;$CONDA_PREFIX/lib/python${CONDA_PYTHON_VERSION}/site-packages/pybind11;$CONDA_PREFIX" \
  -DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX \
  -DCMAKE_CXX_COMPILER="$ROCM_INSTALL_PREFIX/bin/clang++" \
  -DCMAKE_CXX_FLAGS="-I $ROCM_INSTALL_PREFIX/include" \
  -DGPU_TARGETS=$ROCM_GPU_ARCH -DBUILD_TESTING=OFF \
  -DMIGRAPHX_ENABLE_GPU=ON -DMIGRAPHX_USE_COMPOSABLEKERNEL=OFF -DMIGRAPHX_ENABLE_MLIR=OFF

cmake --build build
cmake --build build -t install
popd

# git clone https://github.com/ROCm/torch_migraphx --depth 1 $ROCM_TMP_DIR/torch_migraphx
pushd $ROCM_TMP_DIR/torch_migraphx/py
rm -rf build
ROCM_PATH=$ROCM_INSTALL_PREFIX \
TORCH_CMAKE_PATH=$(python -c "import torch; print(torch.utils.cmake_prefix_path)") \
CMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX \
pybind11_DIR=$CONDA_PREFIX/lib/python${CONDA_PYTHON_VERSION}/site-packages/pybind11/share/cmake/pybind11 \
  pip install .

pip3 list
popd


#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone https://github.com/ROCm/clr $ROCM_TMP_DIR/clr -b rocm-$ROCM_VERSION --depth 1
git clone https://github.com/ROCm/HIP $ROCM_TMP_DIR/HIP -b rocm-$ROCM_VERSION --depth 1
git clone https://github.com/ROCm/HIPCC $ROCM_TMP_DIR/HIPCC -b rocm-$ROCM_VERSION --depth 1

pushd $ROCM_TMP_DIR/HIPCC
rm -rf build
cmake -S . -B build -G "Ninja" \
-DCMAKE_C_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang++ \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX

cmake --build build
popd

pushd $ROCM_TMP_DIR/clr
rm -rf build
mkdir build && cd build

ROCM_PATH=$ROCM_INSTALL_PREFIX \
cmake -S .. -G "Ninja" \
-DCMAKE_BUILD_TYPE=RelWithDebInfo -DCLR_BUILD_HIP=ON \
-DHIP_COMMON_DIR=$ROCM_TMP_DIR/HIP \
-DHIPCC_BIN_DIR=$ROCM_TMP_DIR/HIPCC/build \
-DCMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build .
cmake --build . -t install
mv $ROCM_INSTALL_PREFIX/bin/hipcc.bat $ROCM_INSTALL_PREFIX/bin/hipcc.bat.back
mv $ROCM_INSTALL_PREFIX/bin/hipconfig.bat $ROCM_INSTALL_PREFIX/bin/hipconfig.bat.back
ln -s $ROCM_INSTALL_PREFIX/bin/hipcc $ROCM_INSTALL_PREFIX/bin/hipcc.bat
ln -s $ROCM_INSTALL_PREFIX/bin/hipconfig $ROCM_INSTALL_PREFIX/bin/hipconfig.bat
popd


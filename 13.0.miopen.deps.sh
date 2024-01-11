#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# # Sqlite3
# git clone https://github.com/sqlite/sqlite -b release --depth 1 $MIOPEN_TMP_DIR/sqlite 
# pushd $MIOPEN_TMP_DIR/sqlite 
# rm -rf build
# mkdir build && cd build
# 
# ../configure --prefix=$ROCM_INSTALL_PREFIX
# make -j64
# make install
# popd
# 
# # Conda
# if [ ! -d $CONDA_PATH ]; then
#   wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/tmp/miniconda.sh
#   chmod +x $HOME/tmp/miniconda.sh
#   $HOME/tmp/miniconda.sh -b
# fi
# eval "$($CONDA_PATH/bin/conda shell.bash hook)"
# if ! conda env list | grep -q $CONDA_ENV; then
#   conda create -y -n $CONDA_ENV python=3.11
# fi

# # Boost
# wget https://boostorg.jfrog.io/artifactory/main/release/1.79.0/source/boost_1_79_0.tar.gz -O $MIOPEN_TMP_DIR/boost.tar.gz
tar -zxvf $MIOPEN_TMP_DIR/boost.tar.gz -C $MIOPEN_TMP_DIR
pushd $MIOPEN_TMP_DIR/boost_*
rm -rf build stage
./bootstrap.sh --without-libraries="mpi" \
  --with-python=$CONDA_PATH/envs/$CONDA_ENV/bin/python3
./b2 install cxxflags=-fPIC cflags=-fPIC --prefix=$ROCM_INSTALL_PREFIX --build-dir=./build -q --without-mpi --link=shared
popd


# Half
git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/half $MIOPEN_TMP_DIR/half
pushd $MIOPEN_TMP_DIR/half
pwd
rm -rf build
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

# rocMLIR
git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/rocMLIR $MIOPEN_TMP_DIR/rocmlir
pushd $MIOPEN_TMP_DIR/rocmlir
rm -rf build
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DBUILD_FAT_LIBROCKCOMPILER=1 \
-DCMAKE_C_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang++ \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

# Json
git clone --depth 1 -b v3.9.1 https://github.com/nlohmann/json $MIOPEN_TMP_DIR/json
pushd $MIOPEN_TMP_DIR/json
rm -rf build
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DJSON_MultipleHeaders=ON \
-DJSON_BuildTests=OFF \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

git clone --depth 1 -b v0.2.18-p0 https://github.com/ROCmSoftwarePlatform/FunctionalPlus $MIOPEN_TMP_DIR/FunctionalPlus
pushd $MIOPEN_TMP_DIR/FunctionalPlus
rm -rf build
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

# Eigen
git clone --depth 1 -b 3.4.0 https://github.com/ROCmSoftwarePlatform/eigen $MIOPEN_TMP_DIR/eigen
pushd $MIOPEN_TMP_DIR/eigen
rm -rf build
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

git clone --depth 1 -b master https://github.com/ROCmSoftwarePlatform/frugally-deep $MIOPEN_TMP_DIR/frugally-deep
pushd $MIOPEN_TMP_DIR/frugally-deep
rm -rf build
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

# CK
git clone --depth 1 -b rocm-$ROCM_VERSION https://github.com/ROCm/composable_kernel $MIOPEN_TMP_DIR/ck
pushd $MIOPEN_TMP_DIR/ck
rm -rf build
export LD_LIBRARY_PATH=$ROCM_INSTALL_PREFIX/lib
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/hipcc \
-DINSTANCES_ONLY=ON \
-DGPU_TARGETS=$ROCM_GPU_ARCH \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build build
cmake --build build -t install
unset LD_LIBRARY_PATH
popd


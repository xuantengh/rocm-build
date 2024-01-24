#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

wget https://github.com/checkpoint-restore/criu/archive/v$CRIU_VERSION/criu-$CRIU_VERSION.tar.gz -O $ROCM_TMP_DIR/criu.tar.gz
tar -zxvf $ROCM_TMP_DIR/criu.tar.gz -C $ROCM_TMP_DIR

git clone https://github.com/google/protobuf -b v25.2 --depth 1 $ROCM_TMP_DIR/protobuf
git clone https://github.com/protobuf-c/protobuf-c -b v1.5.0 --depth 1 $ROCM_TMP_DIR/protobuf-c
git clone https://github.com/abseil/abseil-cpp -b 20240116.0 --depth 1 $ROCM_TMP_DIR/absl

CRIU_PREFIX=$HOME/opt/criu/$CRIU_VERSION

pushd $ROCM_TMP_DIR/absl
rm -rf build
cmake -DABSL_BUILD_TESTING=OFF -DABSL_USE_GOOGLETEST_HEAD=OFF -DCMAKE_CXX_STANDARD=14 \
  -DCMAKE_INSTALL_PREFIX=$CRIU_PREFIX \
  -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release

cmake --build build
cmake --build build -t install
popd

pushd $ROCM_TMP_DIR/protobuf
git submodule update --init --recursive

rm -rf build
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_STANDARD=14 \
  -Dprotobuf_BUILD_TESTS=OFF \
  -DCMAKE_INSTALL_PREFIX=$CRIU_PREFIX \
  -Dprotobuf_ABSL_PROVIDER=package \
  -DCMAKE_PREFIX_PATH=$CRIU_PREFIX

cmake --build build
cmake --build build -t install
popd

pushd $ROCM_TMP_DIR/protobuf-c

rm -rf build
./autogen.sh

mkdir build
pushd build

PKG_CONFIG_PATH=$CRIU_PREFIX/lib/pkgconfig \
../configure --prefix=$CRIU_PREFIX

make -j
make install

popd
popd

pushd $ROCM_TMP_DIR/criu-$CRIU_VERSION

eval "$($CONDA_PATH/bin/conda shell.bash hook)"
conda activate $CONDA_ENV
pip3 install protobuf asciidoc
which python3

rm images/google/protobuf/descriptor.proto 
ln -s $CRIU_PREFIX/include/google/protobuf/descriptor.proto images/google/protobuf/descriptor.proto 

export PATH=$CRIU_PREFIX/bin:$PATH
export CPATH=$CRIU_PREFIX/include
export LIBRARY_PATH=$CRIU_PREFIX/lib
which protoc

rm -rf build
mkdir -p build
pushd build
make -C .. PREFIX=$CRIU_PREFIX install
popd

popd


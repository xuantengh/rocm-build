#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/ROCdbgapi $ROCM_TMP_DIR/rocgdbapi
# git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/ROCgdb $ROCM_TMP_DIR/rocgdb
 
pushd $ROCM_TMP_DIR/rocgdbapi
rm -rf build
cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX
cmake --build build
cmake --build build -t install
popd

exit 0

rm -rf $ROCM_TMP_DIR/rocgdb/build
mkdir -p $ROCM_TMP_DIR/rocgdb/build
pushd $ROCM_TMP_DIR/rocgdb/build
set -x
../configure --program-prefix=roc --prefix=$ROCM_INSTALL_PREFIX \
  --enable-64-bit-bfd --enable-targets="x86_64-linux-gnu,amdgcn-amd-amdhsa" \
  --disable-ld --disable-gas --disable-gdbserver --disable-sim --enable-tui \
  --disable-gdbtk --disable-gprofng --disable-shared --with-expat \
  --with-system-zlib --without-guile --with-babeltrace --with-lzma \
  --with-python=python3 --with-rocm-dbgapi=$ROCM_INSTALL_PREFIX

make -j16
make install
popd


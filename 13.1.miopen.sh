#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

source $HOME/softwares/init/bash
module load rocm/$ROCM_VERSION

git clone -b rocm-$ROCM_VERSION --depth 1 https://github.com/ROCm/MIOpen $ROCM_TMP_DIR/miopen

pushd $ROCM_TMP_DIR/miopen
# cmake -P install_deps.cmake --minimum --prefix
rm -rf build
module load rocm/$ROCM_VERSION

cmake -S . -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_CXX_COMPILER=$ROCM_INSTALL_PREFIX/bin/clang++ \
-DMIOPEN_BACKEND=HIP \
-DCMAKE_PREFIX_PATH=$ROCM_INSTALL_PREFIX \
-DCMAKE_INSTALL_PREFIX=$ROCM_INSTALL_PREFIX

cmake --build build
cmake --build build -t install
popd

simplified_version=$(echo $ROCM_VERSION | awk -F'.' '{if ($3 == "0") {print $1"."$2} else {print $1"."$2"."$3}}')
os_version=$(cat /etc/os-release | grep VERSION_ID | cut -d '=' -f2)
os_version=${os_version#\"}
os_version=${os_version%\"}
wget "https://repo.radeon.com/rocm/apt/6.1/pool/main/m/miopen-hip/miopen-hip_3.1.0.60100-82~22.04_amd64.deb" \
  -O $ROCM_TMP_DIR/miopen-kdb.deb

dpkg-deb -R $ROCM_TMP_DIR/miopen-kdb.deb $ROCM_TMP_DIR/miopen-kdb
cp -r $ROCM_TMP_DIR/miopen-kdb/opt/rocm-$ROCM_VERSION/* $ROCM_INSTALL_PREFIX

module purge


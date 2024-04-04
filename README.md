# Build ROCm Software Stack from Source

This repository contains the automatic scripts to build AMD ROCm software stack for heterogenous computing.

Change the install directory and ROCm version in `common.sh`.
Run the shell script **one by one** as the prefix numbers follow the dependency order.
We use [environment modules](https://modules.readthedocs.io/en/latest/) to activate the required environment variables.

```bash
# run with root to install amdgpu driver
./driver.sh

# ROCm will be installed at $HOME/opt/rocm/x.y.z, change the version and install prefix in `common.sh`
python3 envm_generator.py install_destination > modulefile_path/rocm/rocm_version

source module_install_path/init/bash
module load rocm/rocm_version

./00.radeontop.sh
./01.llvm.sh
# ...
```

> [!CAUTION]
> Patch is required for PyTorch building with ROCm 6.0. Check `ubuntu/amd-gpu/patches/pytorch.$PYTORCH_BRANCH.patch` for details.

## Test

Tested in:
- AMD Instinct MI100 (`gfx908`) with ROCm 6.0.2
- AMD Radeon 6900XT (`gfx1030`) with ROCm 5.6.0


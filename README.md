# Build ROCm Software Stack from Source

This repository contains the automatic scripts to build AMD ROCm software stack for heterogenous computing.

Change the install directory and ROCm version in `common.sh`.
Run the shell script **one by one** as the prefix numbers follow the dependency order.

```bash
# run with root to install amdgpu driver
./driver.sh

# ROCm will be installed at $HOME/opt/rocm/x.y.z, change the version and install prefix in `common.sh`
./0.radeontop.sh
./1.llvm.sh
# ...
```

> [!CAUTION]
> Patch is required for PyTorch building with ROCm 6.0. Check `ubuntu/amd-gpu/patches/pytorch.$PYTORCH_BRANCH.patch` for details.

## Test

Tested in:
- AMD Instinct MI100 (`gfx908`) with ROCm 6.0.0
- AMD Radeon 6900XT (`gfx1030`) with ROCm 5.6.0


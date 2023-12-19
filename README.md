# Build ROCm Software Stack from Source

This repository contains the automatic scripts to build AMD ROCm software stack for heterogenous computing.

```bash
# run with root to install amdgpu driver
./driver.sh

# ROCm will be installed at $HOME/opt/rocm/x.y.z
./0.radeontop.sh
./1.llvm.sh
./2.rocm.sh
# ...
./13.conda.sh
```

> [!CAUTION]
> ROCm 6.0 is a newly released version, the AMD team is still working to support the latest PyTorch atop it.
> So the `14.pytorch.sh` script is not usable as for now.

## Test

Tested in:
- AMD Instinct MI100 (`gfx908`) with ROCm 6.0.0
- AMD Radeon 6900XT (`gfx1030`) with ROCm 5.6.0


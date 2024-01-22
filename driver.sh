#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

set -e
wget https://repo.radeon.com/amdgpu-install/latest/ubuntu/jammy/amdgpu-install_6.0.60000-1_all.deb -P /root/downloads
apt install -y /root/downloads/amdgpu-install*.deb
apt update
which amdgpu-install
# Backup
amdgpu-install -h > /root/amdgpu-install.option.txt
amdgpu-install --list-usecase >> /root/amdgpu-install.option.txt
amdgpu-install -y --accept-eula --no-32 --usecase=dkms --dryrun > /root/amdgpu-install.commands.sh

# amdgpu-install -y --accept-eula --no-32 --usecase=dkms
bash /root/amdgpu-install.commands.sh

apt update
apt install libstdc++-12-dev

# Optional: fetch `amdgpu-dkms` .deb src from AMD website, and build from source
wget https://repo.radeon.com/amdgpu/6.0/ubuntu/pool/main/a/amdgpu-dkms/amdgpu-dkms_6.3.6.60000-1697589.22.04_all.deb -P /root/downloads
dkpg-deb -R /root/downloads/amdgpu-dkms_6.3.6.60000-1697589.22.04_all.deb \
  /tmp/amdgpu-dkms
wget https://repo.radeon.com/amdgpu/6.0/ubuntu/pool/main/a/amdgpu-dkms/amdgpu-dkms-firmware_6.3.6.60000-1697589.22.04_all.deb -P /root/downloads
dkpg-deb -R /root/downloads/amdgpu-dkms-firmware_6.3.6.60000-1697589.22.04_all.deb /tmp/amdgpu-dkms-firmware

# Check installation
lsmod | grep amd


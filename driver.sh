#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

set -e
wget http://repo.radeon.com/amdgpu-install/latest/ubuntu/jammy/amdgpu-install_5.5.50500-1_all.deb -P /root/downloads
apt install -y /root/downloads/amdgpu-install*.deb
apt update
which amdgpu-install
# Backup
amdgpu-install -h > /root/amdgpu-install.option.txt
amdgpu-install --list-usecase >> /root/amdgpu-install.option.txt
amdgpu-install -y --accept-eula --no-32 --usecase=dkms --dryrun > /root/amdgpu-install.commands.txt
amdgpu-install -y --accept-eula --no-32 --usecase=dkms
# Check installation
lsmod | grep amd

apt update
apt install libstdc++-12-dev

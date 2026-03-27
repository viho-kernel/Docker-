#!/bin/bash
set -eu
echo "=== Initial disk layout ==="
lsblk
# Install required package (RHEL uses dnf/yum)
dnf install -y cloud-utils-growpart || yum install -y cloud-utils-growpart

# Expand partition 4
growpart /dev/nvme0n1 4

echo "=== After growpart ==="
lsblk

# Resize physical volume
pvresize /dev/nvme0n1p4

# Show volume group free space
vgdisplay RootVG

#========#

# Extend /var to 20GB TOTAL
lvextend -L 30G /dev/RootVG/varVol

# Resize filesystem (RHEL uses XFS here)
xfs_growfs /var

echo "=== Final disk usage ==="
df -hT

sudo dnf -y install dnf-plugins-core

sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo systemctl start docker

sudo systemctl enable docker

sudo usermod -aG docker ec2-user

docker --version


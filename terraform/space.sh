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

# Extend /var to 20GB TOTAL
lvextend -L 30G /dev/RootVG/varVol

# Resize filesystem (RHEL uses XFS here)
xfs_growfs /var

echo "=== Final disk usage ==="
df -hT

echo "=== Installing Docker ==="

# Remove conflicting packages
dnf remove -y docker docker-client docker-client-latest docker-common docker-latest \
docker-latest-logrotate docker-logrotate docker-engine podman runc || true

# Install required tools
dnf install -y dnf-plugins-core

# Add Docker repo
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# Clean metadata (IMPORTANT)
dnf clean all
dnf makecache

# Install Docker
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
systemctl daemon-reexec
systemctl start docker
systemctl enable docker

# Wait until Docker is ready
until systemctl is-active --quiet docker; do
  sleep 2
done

echo "=== Docker Installed ==="

# Add user to docker group
usermod -aG docker ec2-user

# Test Docker in new session
su - ec2-user -c "docker run hello-world"
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

# Check RHEL version
echo "RHEL Version:"
cat /etc/os-release | grep VERSION
 
# Remove conflicting packages (more lenient)
echo "Removing conflicting packages..."
for pkg in docker docker-client docker-client-latest docker-common docker-latest \
           docker-latest-logrotate docker-logrotate docker-engine podman runc; do
  dnf remove -y "$pkg" 2>/dev/null || true
done
 
# Update system
echo "Updating system packages..."
dnf update -y
 
# Install required tools
echo "Installing dnf-plugins-core..."
dnf install -y dnf-plugins-core
 
# Add Docker repo with error handling
echo "Adding Docker repository..."
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
 
# Verify repo was added
if [ -f /etc/yum.repos.d/docker-ce.repo ]; then
    echo "✓ Docker repo added successfully"
else
    echo "✗ Docker repo failed to add"
    exit 1
fi
 
# Clean and rebuild metadata
echo "Cleaning and rebuilding package metadata..."
dnf clean all
dnf makecache --timer
 
# List available Docker packages (for debugging)
echo "Available Docker packages:"
dnf list --available docker-ce 2>/dev/null || echo "Docker CE not found in repos"
 
# Install Docker with verbose output
echo "Installing Docker packages..."
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>&1 | tee /tmp/docker-install.log
 
# Check if installation succeeded
if command -v docker &> /dev/null; then
    echo "✓ Docker installed successfully"
else
    echo "✗ Docker installation failed"
    echo "Install log:"
    cat /tmp/docker-install.log
    exit 1
fi
 
# Start Docker service
echo "Starting Docker service..."
systemctl daemon-reload
systemctl start docker
systemctl enable docker
 
# Wait until Docker is ready
echo "Waiting for Docker daemon..."
for i in {1..30}; do
    if systemctl is-active --quiet docker; then
        echo "✓ Docker daemon is active"
        break
    fi
    echo "Waiting... ($i/30)"
    sleep 2
done
 
# Verify Docker works
echo "Testing Docker..."
docker --version
docker run hello-world
 
# Add user to docker group
echo "Adding ec2-user to docker group..."
usermod -aG docker ec2-user
 
echo "=== Docker Installation Complete ==="
echo "Note: ec2-user needs to log out and log back in for group changes to take effect"
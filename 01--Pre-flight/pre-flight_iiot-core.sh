#!/bin/bash

# ==============================================================
# Edit your /etc/hosts file to resolve IP and FQDN. 
# Pre-requisite steps: disable swap
#                      disable firewall (demo only)
# Install packages:    Helm
#
# Install Docker
# Install Docker Compose
# Install Docker Registry 
#
# 20/05/2022
# ==============================================================

# Infrastructure
dnf update -y
dnf upgrade -y
swapoff --all
sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab
systemctl disable firewalld # Do not disable in Production.
echo -e "Infrastructure update completed .."

sleep 3s
echo -e "Install Pre-requisites .."

# Install Yq
snap install yq
sleep 2s
echo -e "Yq installed .."

# Install Jq
dnf install -y jq
sleep 2s
echo -e "Jq installed .."

# Install Helm
snap install helm --classic
sleep 2s
echo -e "Helm installed .."
sleep 2s
echo -e "Pre-requisite installations completed .."


# Docker pre-requisites
sleep 3s
echo -e "Install Docker .."
dnf install -y yum-utils
dnf config-manager –add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf list docker-ce
pause 5s
dnf install docker-ce --nobest -y
systemctl start docker
systemctl enable docker
groupadd docker
MAINUSER=$(logname)
usermod -aG docker $MAINUSER
systemctl daemon-reload
systemctl restart docker
pause 2s
echo -e "Docker installed .."


# Install Latest Stable Docker Release
sleep 3s
echo -e "Install Docker Compose .."
dnf install curl -y
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Update Docker Daemon for Insecure Registry
tee /etc/docker/daemon.json >/dev/null <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "insecure-registries" : ["iiot-core:5000","0.0.0.0/0"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },


  "storage-driver": "overlay2"
}
EOF
systemctl start docker.service
systemctl enable docker.service

echo -e "Docker daemon updated .."
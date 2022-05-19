#!/bin/bash

# ==============================================================
# Edit your /etc/hosts file to resolve IP and FQDN. 
# Pre-requisite steps: disable swap
#                      disable firewall (demo only)
# Install packages:
#                      Helm
#
# Pre-requistes steps for Docker: 
#                      apt-transport-https
#                      ca-certificates 
#                      curl 
#                      gnupg-agent 
#                      software-properties-common
#
# Install Docker
# Install Docker Compose
# Install Docker Registry 
#
# /05/2022
# ==============================================================

# Infrastructure
dnf update -y
dnf upgrade -y
swapoff --all
sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab
systemctl disable firewalld # Do not disable in Production.
echo -e "Infrastructure update completed .."

sleep 3s
echo -e "The server requires a reboot .."
reboot

# Install Yq
snap install yq

# Install Jq
dnf install -y jq

# Install Helm
snap install helm --classic

# Docker pre-requisites
dnf install -y yum-utils
dnf config-manager –add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf update
dnf repolist
sleep 10s
dnf remove podman buildah
echo -e "Pre-requisite installations completed .."

# Install Latest Stable Docker Release
dnf install docker-ce docker-ce-cli containerd.io
yum install docker-ce --allowerasing -y
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
groupadd docker
MAINUSER=$(logname)
usermod -aG docker $MAINUSER
systemctl daemon-reload
systemctl restart docker
echo -e "Docker Installation completed .."
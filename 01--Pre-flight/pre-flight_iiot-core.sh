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
yum remove -y docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-engine \
                podman \
                runc
dnf install -y yum-utils
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf makecache
slepp 2s
dnf list docker-ce
sleep 5s
yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
systemctl start docker
systemctl enable docker
groupadd docker
usermod -aG docker $USER
newgrp docker
systemctl restart docker
sleep 2s
echo -e "Docker installed .."


# Install Latest Stable Docker Release
sleep 3s
echo -e "Install Docker Compose .."
dnf install curl wget -y
curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url  | grep docker-compose-linux-x86_64 | cut -d '"' -f 4 | wget -qi -
chmod +x docker-compose-linux-x86_64
mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
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
systemctl restart docker.service
sleep 1s
echo -e "Docker daemon updated .."
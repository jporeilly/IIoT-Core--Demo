#!/bin/bash

# ==============================================================
# Edit your /etc/hosts file to resolve IP and FQDN. 
# Pre-requisite steps: disable swap
#                      disable firewall (demo only)
# Install packages:
#                      Jq
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
# 24/04/2022
# ==============================================================

# Infrastructure
apt update -y
apt upgrade -y
swapoff --all
sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab
ufw disable # Do not disable in Production.
echo -e "Infrastructure update completed .."

sleep 3s
echo -e "The server requires a reboot .."
reboot

# Install Jq
apt-get install -y jq

# Install Helm
snap install helm --classic

# Docker pre-requisites
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
echo -e "Pre-requisite installations completed .."

# Install Latest Stable Docker Release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io
tee /etc/docker/daemon.json >/dev/null <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "insecure-registries" : ["localhost:5000","0.0.0.0/0"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
groupadd docker
MAINUSER=$(logname)
usermod -aG docker $MAINUSER
systemctl daemon-reload
systemctl restart docker
echo -e "Docker Installation completed .."

# Install Latest Stable Docker Compose Release
COMPOSEVERSION=$(curl -s https://github.com/docker/compose/releases/latest/download 2>&1 | grep -Po [0-9]+\.[0-9]+\.[0-9]+)
curl -L "https://github.com/docker/compose/releases/download/v$COMPOSEVERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
echo "Docker Compose Installation completed .."

# Install Docker Registry
mkdir -p /data/docker-registry
cp /Downloads/docker-compose.yaml /data/docker-registry
cd /data/docker-registry
docker-compose up -d
echo "Docker Registry Installation completed .."

sleep 3s
echo "The server requires a reboot .."
reboot
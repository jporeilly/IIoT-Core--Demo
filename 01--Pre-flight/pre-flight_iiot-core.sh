#!/bin/bash

# ==============================================================
# Edit your /etc/hosts file to resolve IP and FQDN. 
# Pre-requisite steps: disable swap
#                      disable firewall (demo only)
<<<<<<< Updated upstream:01--Pre-flight/pre-flight_iiot-core.sh
# Install packages:    Yq
#                      Jq
=======
# Install packages:
>>>>>>> Stashed changes:01--Pre-flight/pre-flight_dc.sh
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
<<<<<<< Updated upstream:01--Pre-flight/pre-flight_iiot-core.sh
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
=======
>>>>>>> Stashed changes:01--Pre-flight/pre-flight_dc.sh
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
<<<<<<< Updated upstream:01--Pre-flight/pre-flight_iiot-core.sh
snap install -y jq
=======
dnf install -y jq
>>>>>>> Stashed changes:01--Pre-flight/pre-flight_dc.sh

# Install Helm
snap install helm --classic

<<<<<<< Updated upstream:01--Pre-flight/pre-flight_iiot-core.sh
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
=======
# Install Docker
dnf install 
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf update -y
dnf install --nobest -y docker-ce docker-ce-cli containerd.io
>>>>>>> Stashed changes:01--Pre-flight/pre-flight_dc.sh
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
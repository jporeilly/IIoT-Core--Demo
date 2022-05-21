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
dnf install -y iproute-tc

# open ports in firewall
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10251/tcp
firewall-cmd --permanent --add-port=10252/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --permanent --add-port=30000-32767/tcp  
firewall-cmd --reload
modprobe br_netfilter
modprobe overlay
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables



sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab
systemctl disable firewalld # Do not disable in Production.
cp /etc/sysctl.conf /etc/sysctl.conf.bak # Elasticsearch requires a max map count > 262144
chown -R k8s /etc/sysctl.conf
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
sysctl -p --system
echo -e "Infrastructure update completed .."

sleep 3s
echo -e "Install Pre-requisites .."

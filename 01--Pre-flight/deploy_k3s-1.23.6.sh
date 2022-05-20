#!/bin/bash

# ==============================================================
#
# Deploy k3s -disable traefik
# Configure kubectl 
#
# 20/05/2022
# ==============================================================

# Install k3s - Rancher
curl https://get.k3s.io | sudo INSTALL_K3S_COMMIT=$COMMIT INSTALL_K3S_TYPE=server sh -s - --cluster-init --disable traefik

# Connect and test kubectl
chown -R k8s /etc/rancher/k3s/k3s.yaml
mkdir ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
chown -R $USER:$GROUP ~/.kube/config
systemctl enable k3s
kubectl get pods -A
echo -e "k3s Installation Completed .."

sleep 2s
echo -e "Reboot required .."
reboot
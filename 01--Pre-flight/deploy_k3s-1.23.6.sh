#!/bin/bash

# ==============================================================
#
# Deploy k3s -disable traefik
# Configure kubectl 
#
# 20/05/2022
# ==============================================================

# Install k3s - Rancher
curl -sfL https://get.k3s.io | sh -

# Connect and test kubectl
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
mkdir ~/.kube
cp -i /etc/rancher/k3s/k3s.yaml  $HOME/.kube/config
chown -R $(id -u):$(id -g) $HOME/.kube/config
systemctl enable k3s
kubectl get pods -A
echo -e "k3s Installation Completed .."

sleep 2s
echo -e "Reboot required .."
reboot
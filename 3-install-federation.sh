#!/bin/bash

source .env
set -eux

# Switch to master cluster
kubectl config use-context ${FED_CONTEXT}

# Deploy the Federation control plane to the host cluster
git clone https://github.com/kubernetes-sigs/kubefed.git -b v0.2.0-alpha.1
cd kubefed

helm install charts/kubefed \
  --name kubefed \
  --namespace kube-federation-system \
  --set controllermanager.tag=v0.2.0-alpha.1

# Remove unnecessary files
cd ../
rm -rf kubefed

kubectl -n kube-federation-system get po -o wide

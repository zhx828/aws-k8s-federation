#!/bin/bash

source .env
set -eux


#kubectl config use-context ${FED_CONTEXT}

# from https://cert-manager.io/docs/installation/kubernetes/
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.14.3/cert-manager-legacy.crds.yaml

#Create the namespace for cert-manager.
kubectl create namespace cert-manager

#Add the Jetstack Helm repository.
helm repo add jetstack https://charts.jetstack.io

#Update your local Helm chart repository cache.
helm repo update

# Helm v2
helm install \
  --name cert-manager \
  --namespace cert-manager \
  --version v0.14.3 \
  jetstack/cert-manager



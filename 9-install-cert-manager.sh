#!/bin/bash

source .env
set -eux


# install the nginx-ingress controller
helm install stable/nginx-ingress --name nginx-ingress-controller

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


# install nginx-ingress controller on all clusters
for c in ${US_EAST_CONTEXT} ${AP_NORTHEAST_CONTEXT}; do
    echo; echo ------------ ${c} : install nginx-ingress controller ------------; echo
    kubectl config use-context ${c}
    helm install stable/nginx-ingress --name nginx-ingress
    echo; echo
done

# kubectl describe clusterissuer letsencrypt-staging
kubectl apply -f ingress/cluster-issuer.yaml
kubectl apply -f ingress/certificate.yaml



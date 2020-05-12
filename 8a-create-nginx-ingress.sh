#!/bin/bash

source .env
set -eux



# install nginx-ingress controller on all clusters
for c in ${US_EAST_CONTEXT} ${AP_NORTHEAST_CONTEXT}; do
    echo; echo ------------ ${c} : install nginx-ingress controller ------------; echo
    kubectl config use-context ${c};
#    kubectl apply -f ./nginx-ingress.yaml;
    helm install stable/nginx-ingress --name nginx-ingress --set controller.publishService.enabled=true
#    helm install stable/nginx-ingress --name nginx-ingress
    echo; echo
done

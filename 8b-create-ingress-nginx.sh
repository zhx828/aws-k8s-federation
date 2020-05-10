#!/bin/bash

source .env
set -eux



# install nginx-ingress controller on all clusters
for c in ${US_EAST_CONTEXT} ${AP_NORTHEAST_CONTEXT}; do
    echo; echo ------------ ${c} : install nginx-ingress controller ------------; echo
    kubectl config use-context ${c}
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml
    echo; echo
done

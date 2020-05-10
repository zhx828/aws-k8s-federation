#!/bin/bash

source .env
set -eux



# install nginx-ingress controller on all clusters
for c in ${US_EAST_CONTEXT} ${AP_NORTHEAST_CONTEXT}; do
    echo; echo ------------ ${c} : install nginx-ingress controller ------------; echo
    kubectl config use-context ${c}
    helm install stable/nginx-ingress --name nginx-ingress --publish-service=test/ingress-oncokb-dev
    echo; echo
done

#!/bin/bash

source .env
set -eux

for c in ${US_EAST_CONTEXT} ${AP_NORTHEAST_CONTEXT}; do
    echo; echo ------------ ${c} : install tiller ------------; echo
    kubectl config use-context ${c}
    # Create RBAC for Helm
    kubectl -n kube-system create sa tiller
    kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
    helm init --service-account tiller
    echo; echo
done


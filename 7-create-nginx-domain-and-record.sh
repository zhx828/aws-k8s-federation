#!/bin/bash

source .env
set -eux

# Switch to the fed cluster context
kubectl config use-context ${FED_CONTEXT}

# Create a domain and service dns record
cat <<EOF | kubectl apply -f -
apiVersion: multiclusterdns.kubefed.io/v1alpha1
kind: Domain
metadata:
  name: oncokb-dev
  namespace: kube-federation-system
domain: ${DOMAIN_NAME}
EOF

# Create a ingress dns record
kubectl apply -f ./ingress-dns-record.yaml

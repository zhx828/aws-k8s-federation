#!/bin/bash

source .env
set -eux

# Switch to the fed cluster context
kubectl config use-context ${FED_CONTEXT}

# Create externalDNS for Route53
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
  namespace: kube-federation-system
  labels:
    k8s-app: external-dns
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: external-dns
  template:
    metadata:
      labels:
        k8s-app: external-dns
    spec:
      serviceAccountName: external-dns
      tolerations:
      - key: CriticalAddonsOnly
        operator: Exists
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
      containers:
      - name: external-dns
        image: registry.opensource.zalan.do/teapot/external-dns:latest
        args:
          - --source=crd
          - --crd-source-apiversion=multiclusterdns.kubefed.io/v1alpha1
          - --crd-source-kind=DNSEndpoint
          - --domain-filter=${DOMAIN_NAME}
          - --provider=aws
          - --policy=upsert-only
          - --aws-zone-type=public
          - --registry=txt
          - --txt-owner-id=${HOSTED_ZONE_ID}
          - --txt-prefix=cname
          - --log-level=debug

EOF

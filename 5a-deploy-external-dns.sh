#!/bin/bash

source .env
set -eux

# Switch to the fed cluster context
kubectl config use-context ${FED_CONTEXT}

# Create externalDNS for Route53
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  namespace: kube-federation-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: external-dns
rules:
- apiGroups: [""]
  resources: ["services","endpoints","pods"]
  verbs: ["get","watch","list"]
- apiGroups: ["extensions"]
  resources: ["ingresses"]
  verbs: ["get","watch","list"]
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["list", "watch"]
- apiGroups: ["multiclusterdns.kubefed.io"]
  resources: ["dnsendpoints"]
  verbs: ["get","watch","list"]
- apiGroups: ["multiclusterdns.kubefed.io"]
  resources: ["dnsendpoints/status"]
  verbs: ["*"]
- apiGroups: ["externaldns.k8s.io"]
  resources: ["dnsendpoints"]
  verbs: ["get","watch","list"]
- apiGroups: ["externaldns.k8s.io"]
  resources: ["dnsendpoints/status"]
  verbs: ["*"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: external-dns-viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: external-dns
subjects:
- kind: ServiceAccount
  name: external-dns
  namespace: kube-federation-system

EOF

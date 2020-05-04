#!/bin/bash

source .env
set -eux

# Switch to the fed cluster context
kubectl create -f external-dns/deployment.yaml

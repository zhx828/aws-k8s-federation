#!/bin/bash

source .env
set -eux

kubectl apply -f ./create-fingress.yaml

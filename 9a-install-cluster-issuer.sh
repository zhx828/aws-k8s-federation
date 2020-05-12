
source .env
set -eux


#kubectl config use-context ${FED_CONTEXT}

# kubectl describe clusterissuer letsencrypt-staging
kubectl apply -f ingress/cluster-issuer.yaml
kubectl apply -f ingress/certificate.yaml


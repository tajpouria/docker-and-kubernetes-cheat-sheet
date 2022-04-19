#!/bin/bash

# Create cluster
k3d cluster create --volume ${PWD}/data:/mnt/data --agents 2

# Use the CFSSL to generate self signed TLS certificate to be used
# within the webhook server.

docker run -it -v --rm --volume ${PWD}:/work -w /work debian bash
# Inside the container
apt update
apt install -y curl
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl_1.5.0_linux_amd64 -o /usr/local/bin/cfssl && chmod +x /usr/local/bin/cfssl
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssljson_1.5.0_linux_amd64 -o /usr/local/bin/cfssljson && chmod +x /usr/local/bin/cfssljson

# Generate ca in /tmp
cfssl gencert -initca ./tls/ca-csr.json | cfssljson -bare /tmp/ca

# Generate certificate in /tmp
cfssl gencert \
  -ca=/tmp/ca.pem \
  -ca-key=/tmp/ca-key.pem \
  -config=./tls/ca-config.json \
  -hostname="vault-example,vault-example.default.svc.cluster.local,vault-example.default.svc,localhost,127.0.0.1" \
  -profile=default \
  ./tls/ca-csr.json | cfssljson -bare /tmp/vault-example

# Make a secret
cat <<EOF >./server/server-tls-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: vault-example-tls-secret
type: Opaque
data:
  vault-example.pem: $(cat /tmp/vault-example.pem | base64 | tr -d '\n')
  vault-example-key.pem: $(cat /tmp/vault-example-key.pem | base64 | tr -d '\n')
  ca.pem: $(cat /tmp/ca.pem | base64 | tr -d '\n')
EOF

# Outside of container

# Deploy vault
k create ns vault-example
k apply -n vault-example -f ./server

k exec -it -n vault-example vault-example-0 -c vault -- sh
# Inside the container
# Initialize the vault
vault operator init

# Unseal the vault
# Needs at least 3 unseal key to unseal the vault
for i in $(seq 1 3); do
  vault operator unseal
done
# Outside of container

# Port forward the UI
k port-forward -n vault-example svc/vault-example-ui 8080
# Navigate to https://localhost:8080/

## Secret injection

# Check the k8s API version
k api-versions
# Make sure admissionregistration.k8s.io/v1 are enabled

# Create Vault k8s injector
k apply -n vault-example -f ./injector

k exec -it -n vault-example vault-example-0 -c vault
# Inside the container
vault login
vault auth enable kubernetes
vault write auth/kubernetes/config \
  token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

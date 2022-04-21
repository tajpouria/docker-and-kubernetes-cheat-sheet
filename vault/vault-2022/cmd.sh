#!/bin/bash

######################
## Vault Deployment ##
######################

# Create a cluster

# The Kubernetes version must be 1.21
# Because the Vault that we're installing during this guide
# Uses a specific API of the AdmissionControl which is available
# up to the Kubernetes 1.21.

k3d cluster create \
  --agents 3 \
  --image rancher/k3s:v1.21.7-k3s1

# Use the CFSSL to generate self signed TLS certificate.
docker run -it --rm -v ${PWD}:/work -w /work debian bash
# Inside the container

apt update && apt install -y curl
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssl_1.6.1_linux_amd64 -o /usr/local/bin/cfssl && chmod +x /usr/local/bin/cfssl
curl -L https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssljson_1.6.1_linux_amd64 -o /usr/local/bin/cfssljson && chmod +x /usr/local/bin/cfssljson

# Generate ca in /tmp
cfssl gencert -initca tls/ca-csr.json | cfssljson -bare /tmp/ca

# Generate certificate in /tmp
cfssl gencert \
  -ca=/tmp/ca.pem \
  -ca-key=/tmp/ca-key.pem \
  -config=tls/ca-config.json \
  -hostname="vault,vault.vault.svc.cluster.local,vault.vault.svc,localhost,127.0.0.1" \
  -profile=default \
  tls/ca-config.json | cfssljson -bare /tmp/vault

mv /tmp/* ./tls/
chown 1000:1000 -R ./tls/

exit
# Outside of the container

# Install dependencies

docker run -it --rm --net host -v ${HOME}/.kube/:/root/.kube/ -v ${PWD}/:/work -w /work alpine sh
# Inside the container
apk add --no-cache curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
mv kubectl /usr/local/bin && chmod +x /usr/local/bin/kubectl
alias k=kubectl

curl https://get.helm.sh/helm-v3.8.2-linux-amd64.tar.gz >/tmp/helm-v3.8.2-linux-amd64.tar.gz
tar -C /tmp/ -zxvf /tmp/helm-v3.8.2-linux-amd64.tar.gz
mv /tmp/linux-amd64/helm /usr/local/bin
chmod +x /usr/local/bin/helm

helm repo add hashicorp https://helm.releases.hashicorp.com

# Using Consul as backend storage
# Check available chart versions
helm search repo hashicorp/consul --versions
# We can use chart 0.39.0
# Let's create a manifests folder and grab the YAML
mkdir manifests
helm template consul hashicorp/consul \
  --namespace vault \
  --version 0.39.0 \
  -f consul-values.yaml \
  >./manifests/consul.yaml
k create ns vault
k apply -f manifests/consul.yaml -n vault

# Wait for consul server pod to be ready
while [[ $(kubectl get pods -n vault consul-consul-server-0 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
  echo "waiting for pod" && sleep 1
done

# Create TLS secret
k create secret tls tls-ca -n vault --cert tls/ca.pem --key tls/ca-key.pem
k create secret tls tls-server -n vault --cert tls/vault.pem --key tls/vault-key.pem

# Check available chart versions
helm search repo hashicorp/vault --versions
# Let's grab the YAML
helm template vault hashicorp/vault \
  --namespace vault \
  --version 0.19.0 \
  -f vault-values.yaml \
  >./manifests/vault.yaml
k apply -f manifests/vault.yaml -n vault

# We running the Vault in HA(high availability mode) with three replicas
# we need to unseal ALL OF THE the vault instances

k -n vault exec -it vault-0 -- sh
# Inside the container
vault operator init
for i in {1..3}; do
  vault operator unseal
done
exit
# Outside of the container

k -n vault exec -it vault-1 -- sh
# Inside the container
vault operator init
for i in {1..3}; do
  vault operator unseal
done
exit
# Outside of the container

k -n vault exec -it vault-2 -- sh
# Inside the container
vault operator init
for i in {1..3}; do
  vault operator unseal
done
exit
# Outside of the container

#!/bin/bash

# Provision a cluster
k3d cluster create

# Use the CFSSL to generate self signed TLS certificate to be used
# within the webhook server.

docker run -it -v --rm --volume ${PWD}:/work -w /work debian bash
# In the container
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
  -hostname="example-webhook,example-webhook.default.svc.cluster.local,example-webhook.default.svc,localhost,127.0.0.1" \
  -profile=default \
  ./tls/ca-csr.json | cfssljson -bare /tmp/example-webhook

# Make a secret
cat <<EOF >./tls/example-webhook-tls.secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: example-webhook-tls
type: Opaque
data:
  tls.crt: $(cat /tmp/example-webhook.pem | base64 | tr -d '\n')
  tls.key: $(cat /tmp/example-webhook-key.pem | base64 | tr -d '\n')
EOF

# Generate the CA Bundle + inject into template
ca_pem_b64="$(openssl base64 -A <"/tmp/ca.pem")"
sed -e 's@${CA_PEM_B64}@'"$ca_pem_b64"'@g' <"webhook-template.yaml" >webhook.yaml

# Out of the container

# Writing the webhook

cd src/
docker build . -t webhook
docker run -it --rm -p 8080:80 -v ${PWD}:/app webhook sh
# Inside the container
go mod init example-webhook

export CGO_ENABLED=0
go build -o webhook
./webhook
# Out of the container

# Running the webhook server container with the host network enabled so it can access
# The K3s cluster.
docker run -it --rm --net host -v ${HOME}/.kube:/root/.kube -v ${PWD}:/app webhook sh
# Inside the container
# Install kubectl
apk add --no-cache curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# It's important to get the compatible client-go version.
# Checkout https://github.com/kubernetes/client-go#compatibility-matrix
go get k8s.io/client-go@v0.21.0
go build

export USE_KUBECONFIG=true
./webhook
# Out of the container

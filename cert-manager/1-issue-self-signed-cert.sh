kubectl create ns cert-manager-test

kubectl apply -f self-signed/issuer.yaml

kubectl apply -f self-signed/certificate.yaml

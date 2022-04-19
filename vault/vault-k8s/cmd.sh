#!/bin/bash

# Create cluster
k3d cluster create --volume ${PWD}/data:/mnt/data --agents 2

# Deploy vault
k create ns vault-example
k apply -n vault-example -f ./server

k exec -it -n vault-example vault-example-0 -c vault -- sh
# Inside the container
vault operator init

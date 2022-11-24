#!/usr/bin/env bash

# Install CNI plugin binary to typical CNI location
# with fallback to CNI directory used by kube-up on OS

if ! mkdir -p $HOST_ROOT/opt/cni/bin; then
  if mkdir -p $HOST_ROOT/home/kubernetes/bin; then
    export WAVE_CNI_PLUGIN=$HOST_ROOT/home/kubernetes/bin
  else
    echo 'Failed to instal the Weave CNI plugin' >&2
    exit 1
  fi
fi
mkdir -p $HOST_ROOT/etc/cni/net.d
export HOST_ROOT
/home/weave/weave --local setup-cni

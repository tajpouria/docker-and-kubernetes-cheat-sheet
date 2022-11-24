#!/usr/bin/env bash

# Receives 10-my-cni-demo.conf from STDIN
# Receives required POD speciations as ENVIRONMENT variables
# CNI_CONTAINERID=b5521f2
# CNI_IFNAME=eth0
# CNI_COMMAND=ADD
# CNI_NETNS=/proc/6137/ns/net

case "${CNI_COMMAND}" in
ADD)
  # Configure networking for a new container

  podcidr=$(cat /dev/stdin | jq -r ".podcidr")   # 10.240.0.0/24
  podcidr_gw=$(echo $podcidr | sed "s:0/24:1:g") # 10.240.0.1
  brctl addr cni0                                # Create a new bridge (if doesn't exists), cni0
  ip link set cni0 up
  ip addr add "${podcidr_gw}/24" dev cni0 # Assign 10.240.0.1/24 to cni0

  host_ifname="veth$n" # n=1,2,3...
  ip link add $CNI_IFNAME type veth peer name $host_ifname
  ip link set $host_ifname up

  ip link set $host_ifname master cni0 # Connect veth1 to bridge
  ln -sfT $CNI_NETSNS /var/run/netns/$CNI_CONTAINERID
  ip link set $CNI_IFNAME netns $CNI_CONTAINERID # Move eth0 to pod ns

  # $ip=Calculate $ip...

  ip netns exec $CNI_CONTAINERID ip link set $CNI_IFNAME up
  ip netns exec $CNI_CONTAINERID ip addr add $ip/24 dev $CNI_IFNAME
  ip netns exec $CNI_CONTAINERID ip route add default vi $podcidr_gw dev $CNI_IFNAME
  ;;

DEL)
  # Cleanup when container is stopped
  ;;
GET) ;;
VERSION)
  # Get the plugin version
  ;;
esac

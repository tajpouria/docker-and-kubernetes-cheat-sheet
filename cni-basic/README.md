[Kubernetes Networking: How to Write a CNI Plugin From Scratch - Eran Yanay, Twistlock](https://www.youtube.com/watch?v=zmYxdtFzK6s)

What a CNI plugin is made of?

[cni-basic/my-cni-demo](cni-basic/my-cni-demo):

- CNI configuration
- CNI binary

And a DaemonSet with access to host network:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: weave
  namespace: default
  labels:
    app: weave
spec:
  selector:
    matchLabels:
      app: weave
  template:
    metadata:
      labels:
        app: weave
    spec:
      tolerations:
        - effect: NoSchedule
          operator: Exists
        - effect: NoExecute
          operator: Exists
      containers:
        - name: weave
          command:
            - /home/weave/launch.sh
          image: docker.io/weaveworks/weave-kube:2.5.1
          volumeMounts:
            - mountPath: /weavedb
              name: weavedb
            - mountPath: /host/opt
              name: cni-bin
            - mountPath: /host/home
              name: cni-bin2
            - mountPath: /host/etc
              name: cni-conf
hostNetwork: true
```

[cni-basic/wave-kube](cni-basic/wave-kube)

Here's how the scheduling a new Pod works:

API server:

- Receives the POD spec and sends it ot Kubelet

Kubelet:

- Provisions the container and setup the POD's networks namespace (At this point POD only has the loopback route)
- Calls the CNI plugin's `ADD`

CNI Plugin:

- Crete an eth0 interface on the host network an connect it to Pod namespace and assign it an IP address from the Node's internal `podcidr` fomr from the CNI config.

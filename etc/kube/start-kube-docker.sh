#!/bin/sh

set -Ee

docker run \
    -d \
    --volume=/:/rootfs:ro \
    --volume=/sys:/sys:ro \
    --volume=/dev:/dev \
    --volume=/var/lib/docker/:/var/lib/docker:rw \
    --volume=/var/lib/kubelet/:/var/lib/kubelet:rw,shared \
    --volume=/var/run:/var/run:rw \
    --net=host \
    --pid=host \
    --privileged=true \
    gcr.io/google_containers/hyperkube:v1.5.1 \
    /hyperkube kubelet \
        --containerized \
        --hostname-override="127.0.0.1" \
        --address="0.0.0.0" \
        --api-servers=http://localhost:8080 \
        --cluster_dns=10.0.0.10 \
        --cluster_domain=cluster.local \
        --config=/etc/kubernetes/manifests \
        --allow-privileged=true
until kubectl version 2>/dev/null >/dev/null; do sleep 5; done

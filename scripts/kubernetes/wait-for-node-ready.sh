#!/usr/bin/env sh

### Overview
# This script waits until one-or-more Kubernetes node(s) return(s) a
# status of 'Ready'.

### Usage
# This script expects to be passed one-or-more hostnames of any Kubernetes node
# e.g: ./scripts/kubernetes/wait-for-node-ready.sh k8s-cp01

### Configurable bits
# Number of seconds to sleep for each retry
sleep_time=20

# Number of retry attempts before giving up
retries=20

#################################################

attempt=1
status=0

while [ $attempt -le $retries ]; do
    kubectl wait --for=condition=Ready nodes/$1 --kubeconfig $2

    status=$?

    if [ $status -ne 0 ]; then
        printf "[home-ops] Node(s) not ready. Waiting ${sleep_time}-seconds before re-trying...\n"
        /bin/sleep ${sleep_time}s
    else
        printf "[home-ops] Node(s) now 'Ready'\n"
        exit 0
        break
    fi
    ((attempt=attempt+1))
done

# Ran out of retry attempts
exit 1

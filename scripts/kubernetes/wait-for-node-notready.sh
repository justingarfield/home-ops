#!/usr/bin/env sh

### Overview
# This script waits until a particular kubernetes node returns a
# status of 'NotReady'. When this occurs, we know that it's now
# safe to start the Cilium CNI installation.

### Usage
# This script expects to be passed the first control-plane node's hostname as the only argument
# e.g: ./scripts/kubernetes/wait-for-node-notready.sh k8s-cp01

### Configurable bits
# Number of seconds to sleep for each retry
sleep_time=20

# Number of retry attempts before giving up
retries=20

#################################################

attempt=1
status=0

while [ $attempt -le $retries ]; do
    kubectl wait --for=condition=Ready=false nodes/$1 --kubeconfig $2 1>&- 2>&-

    status=$?

    if [ $status -ne 0 ]; then
        printf "[home-ops] Node $1 is not queryable. Waiting ${sleep_time}-seconds before re-trying...\n"
        /bin/sleep ${sleep_time}s
    else
        printf "[home-ops] Node $1 is now 'NotReady'\n"
        exit 0
        break
    fi
    ((attempt=attempt+1))
done

# Ran out of retry attempts
exit 1

#!/bin/sh

### Overview
# This script waits until a particular kubernetes node returns a
# status of 'Ready'.

### Usage
# This script expects to be passed a Kubernetes node's hostname as the only argument
# e.g: ./wait-for-node-ready.sh k8s-cp02

### Configurable bits
# Number of seconds to sleep for each retry
sleep_time=45

# Number of retry attempts before giving up
retries=10

#################################################

attempt=1
status=0

while [ $attempt -le $retries ]; do
    kubectl wait --for=condition=Ready nodes/$1 1>&- 2>&-

    status=$?

    if [ $status -ne 0 ]; then
        printf "[home-ops] Node $1 is not queryable. Waiting ${sleep_time}-seconds before re-trying...\n"
        /usr/bin/sleep ${sleep_time}s
    else
        break
    fi
    ((attempt=attempt+1))
done

echo "[home-ops] Node $1 is now 'Ready'."

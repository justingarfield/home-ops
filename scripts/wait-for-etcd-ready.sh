#!/bin/sh

### Overview
# This script waits until the dmesg logs on a particular talos node return
# the phrase, "etcd is waiting to join the cluster". At this stage, the node
# is ready for etcd bootstrapping to be perfomed via talosctl.

### Usage
# This script expects to be passed the first control-plane node's hostname as the only argument
# e.g: ./wait-for-etcd-ready.sh k8s-cp01

### Configurable bits
# Number of seconds to sleep for each retry
sleep_time=45

# Number of retry attempts before giving up
retries=10

#################################################

attempt=1
status=0

while [ $attempt -le $retries ]; do
    # This call will throw the following error until it can properly query the node after boot...
    #   error getting dmesg: rpc error: code = Unavailable desc = connection error: desc = "transport: authentication handshake failed: EOF"
    talosctl dmesg --nodes $1 --follow --tail 2>/dev/null | grep -qe "etcd is waiting to join the cluster"

    status=$?

    if [ $status -ne 0 ]; then
        printf "[home-ops] Node $1 is not ready to bootstrap etcd. Waiting ${sleep_time}-seconds before re-trying...\n"
        /usr/bin/sleep ${sleep_time}s
    else
        printf "[home-ops] Node $1 is now ready to bootstrap etcd.\n"
        exit 0
        break
    fi
    ((attempt=attempt+1))
done

# Ran out of retry attempts
exit 1

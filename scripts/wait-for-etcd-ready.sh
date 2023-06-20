#!/bin/sh

### Configurable bits

# First Control Plane node name
node_name=k8s-cp01

# 5-mins of retries
retries=10

# Number of seconds to sleep for each retry
sleep_time=30

#################################################

now=1
status=0

while [ $now -le $retries ]; do
    # redirecting stderr to /dev/null. This call will throw the following
    # error until it can properly query the node after boot:
    #   error getting dmesg: rpc error: code = Unavailable desc = connection error: desc = "transport: authentication handshake failed: EOF"
    talosctl dmesg --nodes $node_name --follow --tail 2>/dev/null | grep -qe "etcd is waiting to join the cluster"

    status=$?
    if [ $status -ne 0 ]; then
        printf "[home-ops] Node ${node_name} is not ready to bootstrap etcd. Waiting ${sleep_time}-seconds before re-trying...\n"
        /usr/bin/sleep ${sleep_time}s
    else
        break
    fi
    ((now=now+1))
done

echo "[home-ops] Node ${node_name} is now ready to bootstrap etcd."

#!/bin/sh

printf "Waiting for required services on first control plane node...\n\n"

SERVICES_TO_WAIT_FOR="apid|containerd|cri|kubelet|machined|trustd|udevd"
SLEEP_TIME_IN_SECONDS=5

NUM_SERVICES_TO_WAIT_FOR=$(printf "$SERVICES_TO_WAIT_FOR" | tr -s '|' ' ' | wc -w)
SERVICES_WITH_OK_HEALTH=0

# TODO: Probably want to implement a short-circuit or timeout here
while [ $SERVICES_WITH_OK_HEALTH -lt $NUM_SERVICES_TO_WAIT_FOR ]
do
    SERVICES_WITH_OK_HEALTH=$(talosctl service --nodes 192.168.60.9 | tail -n +2 | grep -E $SERVICES_TO_WAIT_FOR | wc -l)
    sleep $SLEEP_TIME_IN_SECONDS
done

printf "Required services on first control plane node are ready.\n\n"

talosctl dmesg --nodes k8s-cp01 --follow --tail | grep -qe "etcd is waiting to join the cluster"

echo "etcd is ready to be bootstrapped.\n\n"

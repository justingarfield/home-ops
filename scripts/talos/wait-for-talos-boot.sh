#!/bin/sh

### Overview
# This script waits until talosctl can see the machined and udevd services
# both in an 'ok' status. At that point, the node is ready for its Talos
# machine configuration to be applied.

### Usage
# This script expects to be passed the first control-plane node's FQDN as the only argument
# e.g: ./scripts/talos/wait-for-talos-boot.sh k8s-cp01.staging.home.arpa

### Configurable bits
# Number of seconds to sleep for each retry
sleep_time=45

# Number of retry attempts before giving up
retries=10

#################################################

attempt=1
services_with_ok_health=0
services_to_wait_for="machined|udevd"
num_services_to_wait_for=$(printf "$services_to_wait_for" | tr -s '|' ' ' | wc -w)

while [ $attempt -le $retries ]; do
    # This call will throw the following error until the required services are up and listening...
    #   rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing: dial tcp 192.168.60.9:50000: i/o timeout"
    services_with_ok_health=$(talosctl get service --nodes $1 --insecure 2>/dev/null | tail -n +2 | grep -E $services_to_wait_for | wc -l)

    if [ $services_with_ok_health -ne $num_services_to_wait_for ]; then
        printf "[home-ops] Waiting for required services on Talos node $1...\n"
        /usr/bin/sleep ${sleep_time}s
    else
        printf "[home-ops] Required services on Talos node $1 are now ready.\n"
        exit 0
        break
    fi
    ((attempt=attempt+1))
done

# Ran out of retry attempts
exit 1

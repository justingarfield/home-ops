#!/bin/sh

### Overview
# This script waits until talosctl can see the machined and udevd services
# both in an 'ok' status. At that point, the node is ready for its Talos
# machine configuration to be applied.

### Usage
# This script expects to be passed the first control-plane node's FQDN as the only argument
# e.g: ./scripts/talos/wait-for-talos-boot.sh k8s-cp01.home.arpa

### Configurable bits
# Number of seconds to sleep for each retry
sleep_time=20

# Number of retry attempts before giving up
retries=20

#################################################

attempt=1
services_with_ok_health=0
time_status=false
services_to_wait_for="machined|udevd"
num_services_to_wait_for=$(printf "$services_to_wait_for" | tr -s '|' ' ' | wc -w)

while [ $attempt -le $retries ]; do
    services_response=$(talosctl get services.v1alpha1.talos.dev --nodes $1 --insecure 2>&1)
    if [ $? -ne 0 ]; then
        # This call will throw the following error until the required services are up and listening...
        #   rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing: dial tcp 192.168.60.9:50000: i/o timeout"
        if ! [ "grep -q \"i/o timeout\" <<< $services_response" ]; then
            printf "[home-ops] An unexpected error occurred attempting to retrieve Talos service status running on node \"$1\"\n\n"
            printf "[home-ops] ERROR: ${services_response}\n\n"
            exit 1
        fi
    else
        services_with_ok_health=$(printf "${services_response}" | tail -n +2 | grep -E $services_to_wait_for | wc -l)
    fi

    time_status_response=$(talosctl get timestatuses.v1alpha1.talos.dev --nodes $1 --insecure --output yaml 2>&1)
    if [ $? -ne 0 ]; then
        # Bail on non-timeout errors
        if ! [ "grep -q \"i/o timeout\" <<< $time_status_response" ]; then
            printf "[home-ops] An error occurred attempting to retrieve time-sync status running on node \"$1\"\n\n"
            printf "[home-ops] ERROR: ${time_status_response}\n\n"
            exit 1
        fi
    else
        time_status=$(printf "${time_status_response}" | yq .spec.synced)
    fi

    if [ $services_with_ok_health -ne $num_services_to_wait_for ] || ! [ $time_status ]; then
        printf "[home-ops] Waiting for required Talos services on node \"$1\"...\n"
        /bin/sleep ${sleep_time}s
    else
        printf "[home-ops] Required Talos services on node \"$1\" are now 'Ready'\n"
        exit 0
        break
    fi
    ((attempt=attempt+1))
done

printf "[home-ops] Exhausted maximum number of retries"
exit 1

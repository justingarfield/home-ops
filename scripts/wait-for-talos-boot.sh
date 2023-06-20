#!/bin/sh

printf "\n[home-ops] Waiting for required services on Talos node $1...\n"

SERVICES_TO_WAIT_FOR="machined|udevd"
SLEEP_TIME_IN_SECONDS=10

NUM_SERVICES_TO_WAIT_FOR=$(printf "$SERVICES_TO_WAIT_FOR" | tr -s '|' ' ' | wc -w)
SERVICES_WITH_OK_HEALTH=0

# TODO: Probably want to implement a short-circuit or timeout here
while [ $SERVICES_WITH_OK_HEALTH -lt $NUM_SERVICES_TO_WAIT_FOR ]
do
    SERVICES_WITH_OK_HEALTH=$(talosctl get service --nodes $1.$2 --insecure 2>/dev/null | tail -n +2 | grep -E $SERVICES_TO_WAIT_FOR | wc -l)
    sleep $SLEEP_TIME_IN_SECONDS
done

printf "[home-ops] Required services on Talos node $1 are now ready.\n"

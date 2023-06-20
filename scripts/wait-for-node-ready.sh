#!/bin/sh

### Configurable bits

# 5-mins of retries
retries=15

# Number of seconds to sleep for each retry
sleep_time=20

#################################################

now=1
status=0

while [ $now -le $retries ]; do
    kubectl wait --for=condition=Ready nodes/$1 1>&- 2>&-

    status=$?

    if [ $status -ne 0 ]; then
        printf "[home-ops] Node $1 is not queryable. Waiting ${sleep_time}-seconds before re-checking...\n"
        /usr/bin/sleep ${sleep_time}s
    else
        break
    fi
    ((now=now+1))
done

echo "[home-ops] Node $1 is now 'Ready'."

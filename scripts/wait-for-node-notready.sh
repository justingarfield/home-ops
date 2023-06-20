#!/bin/sh

### Configurable bits

# Duration to wait between polling attempts
sleep_time=30

# Number of retry attempts before bailing
retries=10

#################################################

now=1
status=0

while [ $now -le $retries ]; do
    kubectl wait --for=condition=Ready=false nodes/$1 1>&- 2>&-

    status=$?

    if [ $status -ne 0 ]; then
        printf "[home-ops] Node $1 is not queryable. Waiting ${sleep_time}-seconds before re-checking...\n"
        /usr/bin/sleep ${sleep_time}s
    else
        break
    fi
    ((now=now+1))
done

echo "[home-ops] Node $1 is now 'NotReady'."

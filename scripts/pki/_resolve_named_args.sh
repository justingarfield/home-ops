#!/usr/bin/env bash

# See: https://brianchildress.co/named-parameters-in-bash/

while [ $# -gt 0 ]; do
    if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        declare $v="$2"
        # echo $1 $2
    fi

    shift
done

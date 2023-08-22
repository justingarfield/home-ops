#!/usr/bin/env bash

# Note: With Talos Linux's 'talosconfig' file, you won't need the public 'sa.pub' file

CFSSL_LOG_LEVEL=${CFSSL_LOG_LEVEL:-2}
OUTPUT_FILENAME="${OUTPUT_FILENAME:?argument not defined or empty}"

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. "$DIR/../_resolve_named_args.sh"
. "$DIR/../_padded_message.sh"

CFSSL_BLANK_TEMPLATE="{ \"key\": { \"algo\": \"rsa\", \"size\": 4096 } }"

echo "$CFSSL_BLANK_TEMPLATE" | cfssl genkey -loglevel=$CFSSL_LOG_LEVEL - | yq .key > "$OUTPUT_FILENAME.key"

paddedMessage "Kubernetes Service Account key created" "$OUTPUT_FILENAME.key"

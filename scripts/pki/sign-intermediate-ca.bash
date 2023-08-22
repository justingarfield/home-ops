#!/usr/bin/env bash

CFSSL_LOG_LEVEL=${CFSSL_LOG_LEVEL:-2}
CFSSL_PROFILES=${CFSSL_PROFILES:-./pki/cfssl-profiles.json}
SIGNING_PUBLIC_KEY_FILENAME="${SIGNING_PUBLIC_KEY_FILENAME:?argument not defined or empty}"
SIGNING_PRIVATE_KEY_FILENAME="${SIGNING_PRIVATE_KEY_FILENAME:?argument not defined or empty}"
INTERMEDIATE_CA_FILENAME="${INTERMEDIATE_CA_FILENAME:?argument not defined or empty}"

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. "$DIR/../_resolve_named_args.sh"
. "$DIR/../_padded_message.sh"

cfssl sign -loglevel=$CFSSL_LOG_LEVEL -ca "$SIGNING_PUBLIC_KEY_FILENAME" -ca-key "$SIGNING_PRIVATE_KEY_FILENAME" \
    -config "$CFSSL_PROFILES" -profile intermediate-ca "$INTERMEDIATE_CA_FILENAME.csr" \
    | cfssljson -bare "$INTERMEDIATE_CA_FILENAME"

paddedMessage "Intermediate Certificate Authority signed" "$INTERMEDIATE_CA_FILENAME.csr"

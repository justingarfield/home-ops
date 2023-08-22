#!/usr/bin/env bash

CFSSL_LOG_LEVEL=${CFSSL_LOG_LEVEL:-2}
CFSSL_PROFILES=${CFSSL_PROFILES:-./pki/cfssl-profiles.json}
SIGNING_PUBLIC_KEY_FILENAME=${SIGNING_PUBLIC_KEY_FILENAME:-}
SIGNING_PRIVATE_KEY_FILENAME=${SIGNING_PRIVATE_KEY_FILENAME:-}
OUTPUT_FILENAME=${OUTPUT_FILENAME:-}

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. "$DIR/../_resolve_named_args.sh"
. "$DIR/../_yq_tokenization.sh"
. "$DIR/../_padded_message.sh"

yq_tokenize "./pki/cfssl-templates/client-certificate-csr.json" \
    | cfssl gencert -loglevel=$CFSSL_LOG_LEVEL -ca "$SIGNING_PUBLIC_KEY_FILENAME" -ca-key "$SIGNING_PRIVATE_KEY_FILENAME" -config "$CFSSL_PROFILES" -profile=client - \
    | cfssljson -bare "$OUTPUT_FILENAME"

paddedMessage "Client Certificate CSR created" "$OUTPUT_FILENAME.csr"
paddedMessage "Client Certificate Public key created" "$OUTPUT_FILENAME.pem"
paddedMessage "Client Certificate Private key created" "$OUTPUT_FILENAME-key.pem"

#!/usr/bin/env bash

CFSSL_LOG_LEVEL=${CFSSL_LOG_LEVEL:-2}
CFSSL_PROFILES=${CFSSL_PROFILES:-./pki/cfssl-profiles.json}
SIGNING_PUBLIC_KEY_FILENAME="${SIGNING_PUBLIC_KEY_FILENAME:?argument not defined or empty}"
SIGNING_PRIVATE_KEY_FILENAME="${SIGNING_PRIVATE_KEY_FILENAME:?argument not defined or empty}"
OUTPUT_FILENAME="${OUTPUT_FILENAME:?argument not defined or empty}"

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. "$DIR/../_resolve_named_args.sh"
. "$DIR/../_yq_tokenization.sh"
. "$DIR/../_padded_message.sh"

DIRNAME=$(dirname $OUTPUT_FILENAME)
if [ ! -d $DIRNAME ]; then
    mkdir -p $DIRNAME
fi

TOKENIZED_JSON=$(yq_tokenize "./pki/cfssl-templates/server-certificate-csr.json" --output-format=json)

if [ $EXTRA_SAN ]; then
    TOKENIZED_JSON=$(echo $TOKENIZED_JSON | yq ".hosts += \"$EXTRA_SAN\"")
fi

echo $TOKENIZED_JSON \
  | cfssl gencert -loglevel=$CFSSL_LOG_LEVEL -ca "$SIGNING_PUBLIC_KEY_FILENAME" -ca-key "$SIGNING_PRIVATE_KEY_FILENAME" -config "$CFSSL_PROFILES" -profile=server - \
  | cfssljson -bare "$OUTPUT_FILENAME"

BASENAME=$(basename $OUTPUT_FILENAME)
paddedMessage "Server Certificate CSR created" "$BASENAME.csr"
paddedMessage "Server Certificate Public key created" "$BASENAME.pem"
paddedMessage "Server Certificate Private key created" "$BASENAME-key.pem"

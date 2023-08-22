#!/usr/bin/env bash

CFSSL_LOG_LEVEL=${CFSSL_LOG_LEVEL:-2}
OUTPUT_FILENAME="${OUTPUT_FILENAME:?argument not defined or empty}"

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. "$DIR/../_resolve_named_args.sh"
. "$DIR/../_yq_tokenization.sh"
. "$DIR/../_padded_message.sh"

# YQ Replacement Tokens
ENVIRONMENT_NAME="${ENVIRONMENT_NAME:-Unknown}"
ORGANIZATION_ADMINISTRATIVE_EMAIL="${ORGANIZATION_ADMINISTRATIVE_EMAIL:-Unknown}"
ORGANIZATION_NAME="${ORGANIZATION_NAME:-Unknown}"
ORGANIZATION_LOCATION="${ORGANIZATION_LOCATION:-Unknown}"
ORGANIZATION_STATE_PROVINCE_CODE="${ORGANIZATION_STATE_PROVINCE_CODE:-Unknown}"
ORGANIZATION_COUNTRY_CODE="${ORGANIZATION_COUNTRY_CODE:-Unknown}"

yq_tokenize "./pki/cfssl-templates/root-ca-csr.json" --output-format=json \
    | cfssl gencert -initca=true -loglevel=$CFSSL_LOG_LEVEL - \
    | cfssljson -bare "$OUTPUT_FILENAME"

paddedMessage "Root Certificate Authority CSR created" "$OUTPUT_FILENAME.csr"
paddedMessage "Root Certificate Authority Public key created" "$OUTPUT_FILENAME.pem"
paddedMessage "Root Certificate Authority Private key created" "$OUTPUT_FILENAME-key.pem"

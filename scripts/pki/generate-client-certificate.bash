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

CERT_CN="${CERT_CN:-Unknown}"
ORGANIZATION_ADMINISTRATIVE_EMAIL="${ORGANIZATION_ADMINISTRATIVE_EMAIL:-Unknown}"
ORGANIZATION_NAME="${ORGANIZATION_NAME:-Unknown}"
ORGANIZATION_LOCATION="${ORGANIZATION_LOCATION:-Unknown}"
ORGANIZATION_STATE_PROVINCE_CODE="${ORGANIZATION_STATE_PROVINCE_CODE:-Unknown}"
ORGANIZATION_COUNTRY_CODE="${ORGANIZATION_COUNTRY_CODE:-Unknown}"

yq_tokenize "./pki/cfssl-templates/client-certificate-csr.json" --output-format=json \
    | cfssl gencert -loglevel=$CFSSL_LOG_LEVEL -ca "$SIGNING_PUBLIC_KEY_FILENAME" -ca-key "$SIGNING_PRIVATE_KEY_FILENAME" -config "$CFSSL_PROFILES" -profile=client - \
    | cfssljson -bare "$OUTPUT_FILENAME"

paddedMessage "Client Certificate CSR created" "$OUTPUT_FILENAME.csr"
paddedMessage "Client Certificate Public key created" "$OUTPUT_FILENAME.pem"
paddedMessage "Client Certificate Private key created" "$OUTPUT_FILENAME-key.pem"

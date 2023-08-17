#!/usr/bin/env bash

CFSSL_LOG_LEVEL=${CFSSL_LOG_LEVEL:-2}
CFSSL_PROFILES=${CFSSL_PROFILES:-./pki/cfssl-profiles.json}
SIGNING_PUBLIC_KEY_FILENAME=${SIGNING_PUBLIC_KEY_FILENAME:-}
SIGNING_PRIVATE_KEY_FILENAME=${SIGNING_PRIVATE_KEY_FILENAME:-}
OUTPUT_FILENAME=${OUTPUT_FILENAME:-}

# See: https://stackoverflow.com/questions/192292/how-best-to-include-other-scripts
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. "$DIR/../_resolve_named_args.sh"
. "$DIR/../_yq_tokenization.sh"
. "$DIR/../_padded_message.sh"

yq_tokenize "./pki/cfssl-templates/winrm-https-csr.json" \
    | cfssl gencert -loglevel=$CFSSL_LOG_LEVEL -ca "$SIGNING_PUBLIC_KEY_FILENAME" -ca-key "$SIGNING_PRIVATE_KEY_FILENAME" -config "$CFSSL_PROFILES" -profile=winrm - \
    | cfssljson -bare "$OUTPUT_FILENAME"

paddedMessage "WinRM SSL/TLS Certificate CSR created" "$OUTPUT_FILENAME.csr"
paddedMessage "WinRM SSL/TLS Certificate Public key created" "$OUTPUT_FILENAME.pem"
paddedMessage "WinRM SSL/TLS Certificate Private key created" "$OUTPUT_FILENAME-key.pem"

openssl pkcs12 -export -out "$OUTPUT_FILENAME.pfx" -inkey "$OUTPUT_FILENAME-key.pem" -in "$OUTPUT_FILENAME.pem" -certfile "$SIGNING_PUBLIC_KEY_FILENAME"
paddedMessage "WinRM SSL/TLS Certificate PFX file created" "$OUTPUT_FILENAME.pfx"

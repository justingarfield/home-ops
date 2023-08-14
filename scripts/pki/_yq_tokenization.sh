#!/usr/bin/env bash

YQ=$(which yq)
if [ ! $YQ ]; then
    exit 1
fi

# https://stackoverflow.com/questions/70032588/use-yq-to-substitute-string-in-a-yaml-file
YQ_TOKEN_REPLACEMENTS="
    (.. | select(tag == \"!!str\")) |= sub(\"<ORGANIZATION_COUNTRY_CODE>\", \"$ORGANIZATION_COUNTRY_CODE\")
    | (.. | select(tag == \"!!str\")) |= sub(\"<ORGANIZATION_STATE_PROVINCE_CODE>\", \"$ORGANIZATION_STATE_PROVINCE_CODE\")
    | (.. | select(tag == \"!!str\")) |= sub(\"<ORGANIZATION_LOCATION>\", \"$ORGANIZATION_LOCATION\")
    | (.. | select(tag == \"!!str\")) |= sub(\"<ORGANIZATION_NAME>\", \"$ORGANIZATION_NAME\")
    | (.. | select(tag == \"!!str\")) |= sub(\"<ORGANIZATION_ADMINISTRATIVE_EMAIL>\", \"$ORGANIZATION_ADMINISTRATIVE_EMAIL\")
    | (.. | select(tag == \"!!str\")) |= sub(\"<INTERMEDIARY_NAME>\", \"$INTERMEDIARY_NAME\")
    | (.. | select(tag == \"!!str\")) |= sub(\"<CERT_CN>\", \"$CERT_CN\")
    | (.. | select(tag == \"!!str\")) |= sub(\"<SERVER_NAME>\", \"$SERVER_NAME\")
    | (.. | select(tag == \"!!str\")) |= sub(\"<SERVER_IP>\", \"$SERVER_IP\")
    | (.. | select(tag == \"!!str\")) |= sub(\"<ENVIRONMENT_NAME>\", \"$ENVIRONMENT_NAME\")
    "

function yq_tokenize() {
    $YQ eval "$YQ_TOKEN_REPLACEMENTS" $1 --output-format=json
}

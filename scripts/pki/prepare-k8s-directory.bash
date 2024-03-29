#!/usr/bin/env bash

### Overview
#

### Usage
# This script expects to be passed the directory containing the cfssl-generated PKI files for Kubernetes
#
# e.g: KUBERNETES_PKI_DIR=$HOME/.out-folder/staging/pki/kubernetes ./scripts/pki/prepare-k8s-directory.bash

### Available arguments

# Directory containing the cfssl-generated PKI files for Kubernetes
KUBERNETES_PKI_DIR="${KUBERNETES_PKI_DIR:?argument not defined or empty}"

#################################################

# See: https://stackoverflow.com/questions/192292/how-best-to-include-other-scripts
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

. "$DIR/../_resolve_named_args.sh"
. "$DIR/../_padded_message.sh"

certificateFileNames=(
    "etcd/ca.pem"
    "etcd/ca-key.pem"
    "ca.pem"
    "ca-key.pem"
    "front-proxy-ca.pem"
    "front-proxy-ca-key.pem"
    "sa.key"
)

checkCertificatesExist() {
    paddedMessage "Checking that all required Kubernetes certificates exist" "Proceeding..."

    needToBail=false
    if [ ! -d "$KUBERNETES_PKI_DIR" ]; then
        paddedMessage "Provided Kubernetes PKI directory does not exist" "$KUBERNETES_PKI_DIR"
        exit 1
    fi

    for certificateFileName in ${certificateFileNames[@]}; do
        pathAndCertFileName="$KUBERNETES_PKI_DIR/$certificateFileName"

        # Test for .pem (original), .key (-key.pem renamed), and .crt (.pem renamed)
        if [ ! -f "$pathAndCertFileName" ] && [ ! -f ${pathAndCertFileName/.pem/.crt} ] && [ ! -f ${pathAndCertFileName/-key.pem/.key} ]; then
            needToBail=true
            paddedMessage "Could not find $pathAndCertFileName"
        fi
    done

    if [ $needToBail = true ]; then
        paddedMessage "Required Kubernetes certificate files were not found. Please check messages above."
        exit 1
    fi

    paddedMessage "Checking that all required Kubernetes certificates exist" "Done."
}

renameCertificates() {
    paddedMessage "Renaming Kubernetes certificates to prep for talosctl consumption" "Proceeding..."

    for certificateFileName in ${certificateFileNames[@]}; do

        pathAndCertFileName="$KUBERNETES_PKI_DIR/$certificateFileName"

        if [[ "$pathAndCertFileName" == *-key.pem ]] && [ ! -f ${pathAndCertFileName/-key.pem/.key} ]; then
            mv "$pathAndCertFileName" ${pathAndCertFileName/-key.pem/.key}
            continue
        fi

        if [[ "$pathAndCertFileName" == *.pem ]] && [ ! -f ${pathAndCertFileName/.pem/.crt} ]; then
            mv "$pathAndCertFileName" ${pathAndCertFileName/.pem/.crt}
            continue
        fi

    done

    paddedMessage "Renaming Kubernetes certificates to prep for talosctl consumption" "Done."
}

checkCertificatesExist
renameCertificates

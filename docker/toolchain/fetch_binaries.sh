#!/usr/bin/env bash
set -euxo pipefail

# cat versions.sh | sed -e 's/^/local /' > local_variables.sh
. /tmp/versions.sh

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

BINARIES_TMP=/tmp/binaries
OS=$(uname -s | tr "[:upper:]" "[:lower:]")
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH=amd64
        ;;
    aarch64)
        ARCH=arm64
        ;;
esac

get_age() {
    LINK="https://github.com/FiloSottile/age/releases/download/$AGE_VERSION/age-$AGE_VERSION-$OS-$ARCH.tar.gz"
    wget $LINK -O /tmp/age.tar.gz && \
    tar -xzf /tmp/age.tar.gz age/age
    mv age/age $BINARIES_TMP && \
    chmod +x $BINARIES_TMP/age
}

get_cilium_cli() {
    LINK="https://github.com/cilium/cilium-cli/releases/download/$CILIUM_CLI_VERSION/cilium-$OS-$ARCH.tar.gz"
    wget $LINK -O /tmp/cilium-cli.tar.gz && \
    tar -xzf /tmp/cilium-cli.tar.gz cilium
    mv cilium $BINARIES_TMP && \
    chmod +x $BINARIES_TMP/cilium
}

get_cfssl_certinfo() {
    STRIPPED_VERSION=${CFSSL_TOOLKIT_VERSION/v}
    LINK="https://github.com/cloudflare/cfssl/releases/download/${CFSSL_TOOLKIT_VERSION}/cfssl-certinfo_${STRIPPED_VERSION}_${OS}_${ARCH}"
    wget $LINK -O $BINARIES_TMP/cfssl-certinfo && \
    chmod +x $BINARIES_TMP/cfssl-certinfo
}

get_cfssl_cfssljson() {
    STRIPPED_VERSION=${CFSSL_TOOLKIT_VERSION/v}
    LINK="https://github.com/cloudflare/cfssl/releases/download/${CFSSL_TOOLKIT_VERSION}/cfssljson_${STRIPPED_VERSION}_${OS}_${ARCH}"
    wget $LINK -O $BINARIES_TMP/cfssljson && \
    chmod +x $BINARIES_TMP/cfssljson
}

get_cfssl_cfssl() {
    STRIPPED_VERSION=${CFSSL_TOOLKIT_VERSION/v}
    LINK="https://github.com/cloudflare/cfssl/releases/download/${CFSSL_TOOLKIT_VERSION}/cfssl_${STRIPPED_VERSION}_${OS}_${ARCH}"
    wget $LINK -O $BINARIES_TMP/cfssl && \
    chmod +x $BINARIES_TMP/cfssl
}

get_cfssl_mkbundle() {
    STRIPPED_VERSION=${CFSSL_TOOLKIT_VERSION/v}
    LINK="https://github.com/cloudflare/cfssl/releases/download/${CFSSL_TOOLKIT_VERSION}/mkbundle_${STRIPPED_VERSION}_${OS}_${ARCH}"
    wget $LINK -O $BINARIES_TMP/mkbundle && \
    chmod +x $BINARIES_TMP/mkbundle
}

get_cfssl_toolkit() {
    get_cfssl_certinfo
    get_cfssl_cfssljson
    get_cfssl_cfssl
    get_cfssl_mkbundle
}

get_clusterctl() {
    LINK="https://github.com/kubernetes-sigs/cluster-api/releases/download/${CLUSTERCTL_VERSION}/clusterctl-${OS}-${ARCH}"
    wget $LINK -O $BINARIES_TMP/clusterctl && \
    chmod +x $BINARIES_TMP/clusterctl
}

get_flux2() {
    STRIPPED_VERSION=${FLUX_VERSION/v}
    LINK="https://github.com/fluxcd/flux2/releases/download/${FLUX_VERSION}/flux_${STRIPPED_VERSION}_${OS}_${ARCH}.tar.gz"
    wget $LINK -O /tmp/flux.tar.gz && \
    tar -xzf /tmp/flux.tar.gz flux
    mv flux $BINARIES_TMP && \
    chmod +x $BINARIES_TMP/flux
}

get_github_cli() {
    STRIPPED_VERSION=${GITHUB_CLI_VERSION/v}
    LINK="https://github.com/cli/cli/releases/download/${GITHUB_CLI_VERSION}/gh_${STRIPPED_VERSION}_${OS}_${ARCH}.tar.gz"
    wget $LINK -O /tmp/gh.tar.gz && \
    tar -xzf /tmp/gh.tar.gz "gh_${STRIPPED_VERSION}_${OS}_${ARCH}/bin/gh"
    mv "gh_${STRIPPED_VERSION}_${OS}_${ARCH}/bin/gh" $BINARIES_TMP && \
    chmod +x $BINARIES_TMP/gh
}

get_helm() {
    LINK="https://get.helm.sh/helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz"
    wget $LINK -O /tmp/helm.tar.gz && \
    tar -xzf /tmp/helm.tar.gz "${OS}-${ARCH}/helm"
    mv "${OS}-${ARCH}/helm" $BINARIES_TMP && \
    chmod +x $BINARIES_TMP/helm
}

get_kubectl() {
    LINK="https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${OS}/${ARCH}/kubectl"
    wget $LINK -O $BINARIES_TMP/kubectl && \
    chmod +x $BINARIES_TMP/kubectl
}

get_sops() {
    LINK="https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.${OS}.${ARCH}"
    wget $LINK -O $BINARIES_TMP/sops && \
    chmod +x $BINARIES_TMP/sops
}

get_talosctl() {
    LINK="https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VERSION}/talosctl-${OS}-${ARCH}"
    wget $LINK -O $BINARIES_TMP/talosctl && \
    chmod +x $BINARIES_TMP/talosctl
}

get_tetragon() {
    LINK="https://github.com/cilium/tetragon/releases/download/${TETRAGON_VERSION}/tetra-${OS}-${ARCH}.tar.gz"
    wget $LINK -O $BINARIES_TMP/tetra && \
    chmod +x $BINARIES_TMP/tetra
}

get_hubble() {
    LINK="https://github.com/cilium/hubble/releases/download/${HUBBLE_VERSION}/hubble-${OS}-${ARCH}.tar.gz"
    wget $LINK -O /tmp/hubble.tar.gz && \
    tar -xzf /tmp/hubble.tar.gz hubble
    mv hubble $BINARIES_TMP && \
    chmod +x $BINARIES_TMP/hubble
}

get_terraform() {
    LINK="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OS}_${ARCH}.zip"
    wget $LINK -O /tmp/terraform.tar.gz && \
    unzip /tmp/terraform.tar.gz terraform
    mv terraform $BINARIES_TMP && \
    chmod +x $BINARIES_TMP/terraform
}

get_yq() {
    LINK="https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_${OS}_${ARCH}"
    wget $LINK -O $BINARIES_TMP/yq && \
    chmod +x $BINARIES_TMP/yq
}

get_task() {
    LINK="https://github.com/go-task/task/releases/download/${TASK_VERSION}/task_${OS}_${ARCH}.tar.gz"
    wget $LINK -O /tmp/task.tar.gz && \
    tar -xzf /tmp/task.tar.gz task
    mv task $BINARIES_TMP && \
    chmod +x $BINARIES_TMP/task
}

mkdir -p $BINARIES_TMP

get_age
get_cilium_cli
get_cfssl_toolkit
get_clusterctl
get_flux2
get_github_cli
get_helm
get_kubectl
get_sops
get_talosctl
get_tetragon
get_hubble
get_terraform
get_yq
get_task

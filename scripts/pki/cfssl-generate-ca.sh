#!/bin/sh

### Overview
# This script waits until the dmesg logs on a particular talos node return
# the phrase, "etcd is waiting to join the cluster". At this stage, the node
# is ready for etcd bootstrapping to be perfomed via talosctl.

### Usage
# This script expects to be passed the first control-plane node's hostname as the only argument
# e.g: ./scripts/talos/wait-for-etcd-ready.sh k8s-cp01

### Arrrrrrrgs
output_filename=$1
log_level=$2

#################################################
cfssl gencert -initca=true -loglevel=$log_level - \
    | cfssljson -bare $output_filename

printf "[home-ops] CA CSR created...............................  $output_filename.csr\n"
printf "[home-ops] CA Public key created........................  $output_filename.pem\n"
printf "[home-ops] CA Private key created.......................  $output_filename-key.pem\n"


#!/bin/sh

### Overview
# This script waits until the dmesg logs on a particular talos node return
# the phrase, "etcd is waiting to join the cluster". At this stage, the node
# is ready for etcd bootstrapping to be perfomed via talosctl.

### Usage
# This script expects to be passed the first control-plane node's hostname as the only argument
# e.g: ./scripts/talos/wait-for-etcd-ready.sh k8s-cp01

### Arrrrrrrgs
signing_cert_public_key=$1
signing_cert_private_key=$2
cfssl_profile_json=$3
cfssl_profile_name=$4
csr_filename=$5
output_filename=$6
log_level=$7

#################################################

cfssl sign -loglevel=$log_level -ca "$signing_cert_public_key" -ca-key "$signing_cert_private_key" \
          -config "$cfssl_profile_json" -profile $cfssl_profile_name "$csr_filename" \
          | cfssljson -bare "$output_filename"

printf "[home-ops] CA CSR created...............................  $output_filename.csr\n"
printf "[home-ops] CA Public key created........................  $output_filename.pem\n"
printf "[home-ops] CA Private key created.......................  $output_filename-key.pem\n"

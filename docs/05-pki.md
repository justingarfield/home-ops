# PKI

## Table of Contents

* [TBD](#)

## Kubernetes

This guide follows the [Single Root CA](https://kubernetes.io/docs/setup/best-practices/certificates/#single-root-ca) method, and provides K8s with Intermediate CAs, so that it can handle generating the rest of the certificates from there. This _will_ require the private keys of the Intermediate CAs be copied to the K8s nodes. If you require 100% no private keys on the K8s nodes, you'll need to kick-it-up-a-notch and follow the [All Certificates](https://kubernetes.io/docs/setup/best-practices/certificates/#all-certificates) method

```bash
sudo mkdir /etc/kubernetes
sudo mkdir /etc/kubernetes/pki
sudo mkdir /etc/kubernetes/pki/etcd

sudo mv /home/microk8s/k8s-base-intermediate-ca.crt /etc/kubernetes/pki/ca.crt
sudo mv /home/microk8s/k8s-base-intermediate-ca.key /etc/kubernetes/pki/ca.key
sudo mv /home/microk8s/k8s-etcd-intermediate-ca.crt /etc/kubernetes/pki/etcd/ca.crt
sudo mv /home/microk8s/k8s-etcd-intermediate-ca.key /etc/kubernetes/pki/etcd/ca.key
sudo mv /home/microk8s/k8s-front-proxy-intermediate-ca.crt /etc/kubernetes/pki/front-proxy-ca.crt
sudo mv /home/microk8s/k8s-front-proxy-intermediate-ca.key /etc/kubernetes/pki/front-proxy-ca.key
```

## Setting up PKI for your home

This document assumes you'll be using the CloudFlare `cfssl` tools written in Go. (*Fun fact*: The [LetsEncrypt](https://letsencrypt.org/) servers literally use the cfssl tools on their back-end to handle CSRs and CRLs) All commands and work done throughout this document were originally performed using [Ubuntu on Windows Subsystem for Linux (WSL)](https://ubuntu.com/wsl), but should work on any modern version of Linux.

### Prerequisite Checklist

Before we get started, it's important to think some things through and be prepared, so that you're not frustrated later on in the process.

#### Save your work in a script or make it easily repeatable

Even with my instructions, chances are you're going to f**k something up at least once or twice while getting used to how the cfssl tools interpret files, or you'll decide you want more security and introduce a secondary intermediate CA, or whatever the case may be. Even if you're just saving all the commands you type into Notepad++, just save them off while working through this tutorial.

#### Determine how you're going to handle your Root CA (important, seriously read this!!!)

Part of the process that follows will leave you with Certificate Authority (CA) Root Key and CSR file assets. IT IS MANDATORY THAT YOU KEEP THESE SECURE AND/OR OFFLINE THEM FULLY WHEN DONE WITH THIS PROCESS!!! I cannot stress this step enough!!! If you fail on this step, and someone gets hold of these files, your security is literally worthless!!! It would be literally handing an advesary the keys to your house! This also means, DO NOT PERFORM THIS ON A SYSTEM YOU BELIEVE MAY BE COMPROMISED IN EVEN THE LEAST BIT! (To get around this problem, I'll be covering how to do all of this with a YubiKey at a later date)

#### Determine how many Intermediary CAs you want

Since you need to offline the CA Root Key and CSR, you'll want to create at least one Intermediary CA that you can cut your daily-use certificates from; otherwise, you would always have to bring the Root CA online and risk someone compromising it. Think about functional boundaries, device types, what certificates will be in-play, etc. Some example Intermediate CAs I've built-out are:
* Administration (Web Admin UI SSL, SSH+TLS for remote management, etc.)
* Logging (syslog-ng w/ TLS)
* Services Communication
* Proxies (HTTPS through nginx)

#### Linux and Go installed

`PATH=$PATH:~/go/bin`

### Putting it all together

# #################################
# This is a work in progress. More to come after I hash out some remaining items in how I want to build this out completely.
# #################################

#### Generating the CA Root Public Key, Private Key, and CSR

`cfssl gencert -initca <org name>_root_ca_csr.json | cfssljson -bare <org name>_root_ca`

#### Generating the Intermediary CA Public Keys, Private Keys, and CSRs

* `cfssl gencert -initca <org name>_logging_intermediate_ca_csr.json | cfssljson -bare <org name>_logging_intermediate_ca`
* `cfssl sign -ca <org name>_root_ca.pem -ca-key <org name>_root_ca-key.pem -config cfssl-profiles.json -profile=ca-root <org name>_logging_intermediate_ca.csr | cfssljson -bare <org name>_logging_intermediate_ca`

* `cfssl gencert -initca <org name>_management_intermediate_ca_csr.json | cfssljson -bare <org name>_management_intermediate_ca`
* `cfssl sign -ca <org name>_root_ca.pem -ca-key <org name>_root_ca-key.pem -config cfssl-profiles.json -profile=tlscert <org name>_management_intermediate_ca.csr | cfssljson -bare <org name>_management_intermediate_ca`

#### Genrating Certificates for SSL and Devices

* `cfssl gencert -ca <org name>_management_intermediate_ca.pem -ca-key <org name>_management_intermediate_ca-key.pem -config cfssl-profiles.json -profile=sslserver sophos_firewall_csr.json | cfssljson -bare sophos_firewall`
* `cfssl gencert -ca <org name>_logging_intermediate_ca.pem -ca-key <org name>_logging_intermediate_ca-key.pem -config cfssl-profiles.json -profile=tlscert syslog_ng_csr.json | cfssljson -bare syslog_ng`
* `openssl ec -passout pass:<password> -in <org name>_management_intermediate_ca-key.pem -out <org name>_management_intermediate_ca.key`
* `openssl rsa -passout pass:<password> -in sophos_firewall-key.pem -out sophos_firewall.key`

### YubiKey Support Coming Soon

I plan on adding steps to work with a YubiKey in the mix eventually. For the interim, here's a link to check out what YubiKeys are: https://www.yubico.com/ (I can't afford a real FIP-compliant HSM, so this is going to be as good as it gets)

### References
* [CloudFlare's PKI/TLS toolkit](https://github.com/cloudflare/cfssl)
* [Certificate Authority with CFSSL](https://jite.eu/2019/2/6/ca-with-cfssl/)
* [How to build your own public key infrastructure](https://blog.cloudflare.com/how-to-build-your-own-public-key-infrastructure/)
* [How to use cfssl to create self signed certificates](https://medium.com/@rob.blackbourn/how-to-use-cfssl-to-create-self-signed-certificates-d55f76ba5781)
* [Creating your own PKI using Cloudflare's CFSSL](https://technedigitale.com/archives/639)
* [Building a Secure Public Key Infrastructure for Kubernetes](https://www.mikenewswanger.com/posts/2018/kubernetes-pki/)
* [A makefile for generating self signed ssl certificates for the current host with cfssl](https://github.com/rob-blackbourn/ssl-certs)
* [Key usage extensions and extended key usage](https://help.hcltechsw.com/domino/11.0.0/conf_keyusageextensionsandextendedkeyusage_r.html)
* [How to correctly add a path to PATH?](https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path)

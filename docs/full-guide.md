# Full Guide

1. Overview
2. Prepare a `.env` file
2. Install Tooling
3. PKI
4. Pull-through Cache
5. Virtual Box Lab
6. Talos Cluster
7. Flux CD and GitOps
8.

## Prepare a `.env` file

Over time, everyone's environments change...Things get modified, programs get added / removed / updated, things become out-of-date, etc.

A `.env` file is a way for you to inform all of the provided Task files with values that match your particular environment.

## PKI

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


## ARRRRRR setup

* Configure qBittorrent
  *
  *

* Configure FlareSolverr in Prowlarr
  * Name: `FlareSolverr`
  * Tags: `<none yet>`
  * Host: `http://flaresolverr.pvr.svc.<cluster domain>:8191/`

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

## Overview

My home lab has a _lot_ of moving parts, and would be near-impossible to describe in a few paragraphs, so I've broken it all up into a multi-section guide within this repository, so that you can dive-in and focus on the parts you find interesting or helpful.

## The Hardware

### Compute

* 2 x 1U Dell R320 appliance servers w/ 8GB RAM and 4 x 3TB 10k RPM SAS drives
* (Currently offline) 2 x 2U HP DL380 G6 boat anchors w/ 64GB RAM and 8 x 780GB SAS drives
* 3 x Raspberry Pi 4 Model B w/ 1TB SSDs via USB
* 1 x Custom Built x64 machine w/ 18-core Xeon, 128GB RAM, 2 x 1TB M.2 NVMes, and 4 x 1TB SSDs

### Storage

* 1 x Synology DS3617x w/ 64GB RAM and 12 x 10TB WD Red Pro 10k RPM SATA drives

### Network
* 1 x FS S5500-48T8SP 48-Port Gigabit L3 PoE+ Managed Switch with 8 SFP+
* 1 x FS S3900-24T4S 24-Port Gigabit Ethernet L2+ Switch, 24 x Gigabit RJ45, with 4 x 10Gb SFP+ Uplinks

## The Software

### Firewall / Other

* OPNsense
  * FRR (for BGP)
  * Unbound (for DNS)
  * Wireguard (for VPN)

### Kubernetes

* Talos Linux
* Cilium CNI
* Piraeus CSI
* Tetragon
* Hubble
*

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

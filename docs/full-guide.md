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

## Assumptions / Limitations

* I don't currently have a large budget to buy new hardware, so I'm using what I have available
* This is not a "template" like some of the other repositories out there, this is public for others to derive ideas and solutions from. Feel free to copy things out of here, but don't expect it all to work verbatim.
* I use custom PKI generated with cfssl, as I don't want to rely on cert-manager for everything (Kubernetes is an addition in my environment, not a pre-req)
* Some functionality on my OPNsense firewalls _could_ run in Kubernetes, but I'm keeping my Firewalls / Load Balancing, etc. separate from K8s so that I still have minimal functionality in the event I completely f**k-up my K8s cluster _(it's a home lab, I don't have a company Credit Card to spin-up 20 new VMs on for testing)_

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

## Virtualization

I currently run my 'staging' environment on Hyper-V VMs. The machine on which they run has an abundance of RAM, but limited CPU _(as its also my gaming machine at this point in-time)_.

I would not recommend running a 3-node CP / 2-node DP on anything less than an 8-core CPU and 64GB RAM. Even then, do not expect to run things like `rook-ceph` or solutions that require massive amounts of resources in-general _(e.g. giant-ass databases)_.

Remember, each VM is going to be requiring time-slices from your cores, and if too many requests are in-play, you can expect CPU stalls, timeouts, etc. which will _Michael Bay Explode™_ your cluster and/or cause Pods to start rescheduling like crazy and never coming back up.

For an actual 24/7 'Production' cluster, you're going to want much beefier hardware, and this type of setup should only be used to test your configurations and what-not.

### VirtualBox on Windows Notes

You have two options if running Windows 10/11 regarding VirtualBox usage...

#### Option 1: Don't use it

If you're a big fan of Windows Subsystem for Linux (WSL) and/or already using Hyper-V for VMs, make sure you don't install VirtualBox; the combo of software will constantly fight each other, lead to insane amounts of CPU stalling, poor memory management, and more.

#### Option 2: Disable Hyper-V and WSL

If you don't care about Hyper-V or WSL, and want to use VirtualBox on Windows 10/11, then you need to eliminate all Hyper-V and Virtualization options under Add/Remove Windows Features / Roles and reboot.

Note: One word of caution if you do use VirtualBox. When configuring your attached HDDs, make sure you know what `Use Host I/O Cache` is _really_ doing before you decide to check that box. If you have workloads running that are writing lots of data, you could potentially lose a buttload of data during an unexpected shut-down. It may _go faster_ with this option, but there are reasons.

#### My thoughts on Windows + VirtualBox

IMHO, giving up WSL2 + Docker Desktop integration simply isn't worth the trade-offs. If you need to run other virtualized workloads along-side your K8s Cluster on Windows Desktop, use straight-up Hyper-V or VMWare Workstation.

I honestly tried going the VirtualBox route for 3-months during development of this repository, and the issues don't surface at first, but once you start deploying applications and place load on your cluster(s), Virtual Box starts to have tons of CPU stalls due to 10s-of-millions of context-switches happening, and will blow-out your `vmmem` process in Windows choking your CPU.

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

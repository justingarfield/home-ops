# Home Ops -> Sidero Metal

## !! Notice !!

This folder is quite old at this point. I last tested Sidero Metal back when it was @ v0.4,
so chances are that the files in this folder will need updating to function with the latest version.

I left these files here for reference to anyone else looking for some ideas on how to layout a folder/file
structure to build their own environment(s) using Sidero Metal.

## Directory layout

```sh
📂 sidero-metal
├─📁 clusters                               #
├─📁 environments                           #
├─📁 serverclasses                          #
├─📁 servers                                #
├─📁 sidero-controller-manager              #
└─📄 patch-sidero-controlplane-config.yaml  #
```

## Clusters

| Filename | Function | Description |
|-|-|-|
| `hybrid.yaml` | General Use (craploads of CPU / RAM available) |  Generated using the `generate-hybrid-cluster-config` _Makefile_ target.<br />Mix of Raspberry Pis, Custom Builds, and some HP DL380s | Raspberry Pi 4 - Model B (d03114 v1.4)|

## Environments

| Filename | Description |
|-|-|
| `default.yaml` | Updates the OOTB *default* environment that Sidero provides. (e.g. bump the Talos version to boot) |
| `rpi-arm64-v1.3.6.yaml` | Adds an environment to boot Rpi 4's with arm64 binaries |

## Server Classes

| Filename | Description |
|-|-|
| `rpi4-d03114.yaml` | Targets the Pi 4 - Model D03114 |

## Servers

| Filename | Arch | Model (rev) |
|-|-|-|
| `00d03114-0000-0000-0000-e45f012acd19.yaml` | arm64 | Raspberry Pi 4 - Model B (d03114 v1.4) |
| `00d03114-0000-0000-0000-e45f012f2599.yaml` | arm64 | Raspberry Pi 4 - Model B (d03114 v1.4) |
| `00d03114-0000-0000-0000-e45f0128c8fe.yaml` | arm64 | Raspberry Pi 4 - Model B (d03114 v1.4) |
| `desktop-tower900.yaml`                     | amd64 | Custom-built desktop / worker with 18-core Xeon |

## sidero-controller-manager

| Filename | Description |
|-|-|
| `patch-tftp-raspberrypi4b-uefi.yaml` | Adds an initContainer to the `sidero-controller-manager/manager`<br />which will copy custom files into the `/tftp/` folder that gets served by sidero. |

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

## Additional Notes / Observations

**Note: These notes may no longer apply, and as many things have changed since I first worked with Sidero Metal over a year ago.**

### Custom RPI_EFI.fd per-serial

If I use the method of a custom `RPI_EFI.fd` per-serial number, I end up getting stuck on the rainbox color boot screen.

### start4.elf not found

If I allow a fresh Pi to perform 3 full reboot cycles with the Sidero Agent, the 3rd (and any further) EEPROM TFTP boot causes seven rapid green LED flashes on the Pi 4, which indicates it couldn't locate a valid `start4.elf` to boot into (aka "kernel not found").

If I restart the `sidero-controller-manager`, I can then get the sidero agent to boot twice again, and repeat the same on the 3rd and subsequent boots.

The sidero-controller-manager logs seem to always have the following in them when this happens:
```
2023/03/30 11:11:05 sending block 1: code=0, error: Early terminate
2023/03/30 11:11:05 sending block 1: code=0, error: Early terminate
2023/03/30 11:11:05 sending block 1: code=0, error: Early terminate
2023/03/30 11:11:39 Channel timeout: 192.168.68.2:33403
```

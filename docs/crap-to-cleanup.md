
## Folders and Stuff

| Folder | Description |
|-|-|
| `sidero-metal` | Files used to provision Sidero Metal related resources. |
| `talos-linux`  | Files used to provision Talos Linux related resources.  |
| `Makefile`     | Just my own scratch-pad of commands I've been screwing with to build this out (here for examples)<br />Be **_REALLLY_** careful if you decide to run any targets in here. |

## Observations

### Versions being used

| Product | Version |
|-|-|
| `raspberrypi/rpi-eeprom` | [`2023-01-11-vl805-000138c0`](https://github.com/raspberrypi/rpi-eeprom/releases/download/v2023.01.11-138c0/rpi-boot-eeprom-recovery-2023-01-11-vl805-000138c0-network.zip) |
| `pftf/RPi4` | [`v1.3.4`](https://github.com/pftf/RPi4/releases/download/v1.34/RPi4_UEFI_Firmware_v1.34.zip) |
| `talos` | [`v1.3.6`](https://github.com/siderolabs/talos/releases/download/v1.3.6/metal-rpi_generic-arm64.img.xz) |
| `talos bootstrap` | `v0.5.6` |
| `talos controlplane` | `v0.4.11` |
| `clusterapi` | `v1.3.5` |
| `talos installer` | `v1.3.6`
| `sidero infrastructure` | `v0.5.8` |
| `kubernetes` | `v1.26.3` |
| `clusterctl` | `v1.3.5` |
| `talosctl` | `v1.3.6` |
| `kubectl` | `v1.26.3` |

### Hang-ups

#### Custom RPI_EFI.fd per-serial

If I use the method of a custom `RPI_EFI.fd` per-serial, I end up getting stuck on the same screen as Michael

#### start4.elf not found

If I allow a fresh Pi to perform 3 full reboot cycles with the Sidero Agent, the 3rd (and any further) EEPROM TFTP boot causes seven rapid green LED flashes on the Pi 4, which indicates it couldn't locate a valid `start4.elf` to boot into (aka "kernel not found").

If I restart the `sidero-controller-manager`, I can then get the sidero agent to boot twice again, and repeat the same on the 3rd and subsequent boots.

The sidero-controller-manager logs seem to always have the following in them when this happens:
```
2023/03/30 11:11:05 sending block 1: code=0, error: Early terminate
2023/03/30 11:11:05 sending block 1: code=0, error: Early terminate
2023/03/30 11:11:05 sending block 1: code=0, error: Early terminate
2023/03/30 11:11:39 Channel timeout: 192.168.68.2:33403
```

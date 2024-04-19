## Installation

I'm installing this under Ubuntu 22.04 under WSL on Windows 11 Professional.

```shell
curl -s https://raw.githubusercontent.com/89luca89/distrobox/1.5.0.2/install | sh -s -- --prefix $HOME/.distrobox
export PATH=$PATH:$HOME/.distrobox/bin
```

## WSL Stuffs

```shell
# Can't utilize usage of multiple mounts on single line with Ubuntu version of 'mount'
sudo mount --make-shared /
sudo mount --make-shared /dev
sudo mount --make-shared /sys
```

See [shared-mounts-for-distrobox.sh](/scripts/wsl/shared-mounts-for-distrobox.sh) for a scripted version of this.

## Usage

Make sure Docker Desktop is running (if using vs. podman on Windows).

```shell
distrobox assemble create --file ./distrobox/toolchain-ubuntu.ini
distrobox assemble create --file ./distrobox/toolchain-alpine.ini
```

## Uninstallation

If you decide that distrobox is not for you, or just isn't working in your environment, you can uninstall with:

```shell
curl -s https://raw.githubusercontent.com/89luca89/distrobox/1.5.0.2/uninstall | sudo sh
```

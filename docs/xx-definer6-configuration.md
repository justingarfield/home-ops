# DefineR6 Configuration

## BitLocker

1. Make sure System volume is BitLocker Encrypted
2. Make sure Data volume is BitLocker Encrypted

## WSL

1. Install Windows Subsystem for Linux (WSL) using Ubuntu 24.04 (Noble) distribution
2. Setup username/password, run `sudo apt-get update -y && sudo apt-get upgrade -y`

## Docker Desktop Data SSD

1. In Windows Disk Management, format Docker Desktop Data Volume w/ NTFS (set to `D:` if possible)

## Docker Desktop

1. Install Docker Desktop w/ WSL Integration enabled
2. In Docker Desktop...

* Settings -> Resources -> Advanced -> Set **Disk image location** to `D:\DockerDesktopWSL`
* Settings -> Resources -> WSL integration -> Set **Enable integration with additional distros** enabled for Ubuntu 24.04

## Mounting a dedicated WSL Data SSD

1. Open Windows Disk Management and set WSL Data Disk SSD to "Offline"
5. Run `sudo apt-get install cryptsetup`
6. In an Elevated PowerShell Terminal: `GET-CimInstance -query "SELECT * from Win32_DiskDrive"` - find the WSL Data Disk SSD
7. `wsl --mount <drive from prior command> --bare` (e.g. `wsl --mount \\.\PHYSICALDRIVE1 --bare`)
8. `sudo fdisk -l` to find WSL Data Disk SSD on WSL side (e.g. `/dev/sde`)
9. `sudo cryptsetup luksFormat <drive from prior command>` (e.g. `sudo cryptsetup luksFormat /dev/sde`)
10. `sudo cryptsetup open /dev/sdc wsl-data-ssd` (`ls /dev/mapper` to verify)
11. `sudo mkfs.ext4 /dev/mapper/wsl-data-ssd`
12. `sudo blkid -o list`
13.
```bash
sudo mkdir /mnt/wsl-data-ssd
sudo mount -t ext4 /dev/mapper/wsl-data-ssd /mnt/wsl-data-ssd
sudo chown -R myuser:myuser /mnt/wsl-data-ssd
echo "hello" > /mnt/wsl-data-ssd/hello-world.txt
```
14.
```bash
sudo mkdir /etc/luks-keys
sudo dd if=/dev/urandom of=/etc/luks-keys/my_disk_secret_key bs=512 count=8
sudo chmod 0400 /etc/luks-keys/my_disk_secret_key
```
15. `sudo cryptsetup -v luksAddKey /dev/sdc /etc/luks-keys/my_disk_secret_key`
16. `sudo cryptsetup luksDump /dev/sdc`
17.
```bash
sudo umount /dev/mapper/wsl-data-ssd
sudo cryptsetup close wsl-data-ssd
sudo cryptsetup -v luksOpen /dev/sdc wsl-data-ssd --key-file=/etc/luks-keys/my_disk_secret_key
```
18. 

## Enable the `ssh-agent`

```powershell
<ensure elevated powershell>

Set-Service   ssh-agent -StartupType Automatic
Start-Service ssh-agent
```

## GitHub SSH Key

```powershell
ssh-keygen -t ed25519 -C "<YEAR>-<MONTH>-<DAY>-GitHub-<MACHINE NAME>" -f "$($Env:UserProfile)\.ssh\<YEAR>-<MONTH>-<DAY>-GitHub-<MACHINE NAME>"
```

## Mount SSH folder inside WSL

### Setup WSLENV

Here we'll instruct WSL to map the USERPROFILE environment variable into the running WSL Linux instance.

Note: A full `wsl --shutdown` is required to get this functioning

```powershell
setx WSLENV "USERPROFILE/p"
```

### Create /etc/fstab entry

Now add an entry to `/etc/fstab` to automatically mount the `/.ssh/` folder from Windows to WSL.

```bash
sudo -E ./scripts/wsl/fstab-config.bash
```

### ssh-agent

In `$HOME/.ssh/config`:

```config
Host github
    Hostname github.com
    IdentityFile ~/.ssh/2024-10-16-GitHub-DefineR6
    IdentitiesOnly yes
```

```bash
echo -e '\neval $(ssh-agent -s)' >> ~/.bashrc

ssh-add $HOME/.ssh/<YEAR>-<MONTH>-<DAY>-GitHub-<MACHINE NAME>
```

## References

* [Automatically Starting an External Encrypted SSD in Windows Subsystem (WSL)](https://medium.com/@stefan.berkner/automatically-starting-an-external-encrypted-ssd-in-windows-subsystem-wsl-6403c34e9680)

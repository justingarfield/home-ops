
### disk-nvme*

Modifies a machine to mount `/dev/nvme0n1` or `/dev/nvme1n1` to a mount-point of `/var/mnt/nvme0n1` or `/var/mnt/nvme1n1` respectively.

### disk-sd*

Modifies a machine to mount `/dev/sdb`, `/dev/sdc`, or `/dev/sdd` to a mount-point of `/var/mnt/sdb`, `/var/mnt/sdc`, or `/var/mnt/sdd` respectively.

### machine-cert-sans

Adds additional certificate SANs that represent my HA Proxy endpoint used for communications via `talosctl`.

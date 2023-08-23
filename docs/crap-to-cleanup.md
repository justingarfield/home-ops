## OPNsense Settings

### Unbound DNS

/usr/local/etc/unbound.opnsense.d/custom-config.conf
```
cache-max-negative-ttl: 1
```

* https://forum.opnsense.org/index.php?topic=23929.msg116959#msg116959

#### Overrides

| Hostname | Domain    | Type | Value | Description |
|-|-|-|-|-|
| k8s-cp01        | home.arpa         | A    | 192.168.x.x | Kubernetes Production Cluster - Control Plane Node 01               |
| k8s-cp02        | home.arpa         | A    | 192.168.x.x | Kubernetes Production Cluster - Control Plane Node 02               |
| k8s-cp03        | home.arpa         | A    | 192.168.x.x | Kubernetes Production Cluster - Control Plane Node 03               |
| k8s-wk01        | home.arpa         | A    | 192.168.x.x | Kubernetes Production Cluster - Data Plane Node 01                  |
| k8s-wk02        | home.arpa         | A    | 192.168.x.x | Kubernetes Production Cluster - Data Plane Node 02                  |
| talos-endpoints | home.arpa         | A    | 192.168.x.x | Kubernetes Production Cluster - Load balanced Talos Endpoints       |
| control-plane   | home.arpa         | A    | 192.168.x.x | Kubernetes Production Cluster - Load balanced Kubernetes API Server |
| k8s-cp01        | staging.home.arpa | A    | 192.168.x.x | Kubernetes Staging Cluster - Control Plane Node 01                  |
| k8s-cp02        | staging.home.arpa | A    | 192.168.x.x | Kubernetes Staging Cluster - Control Plane Node 02                  |
| k8s-cp03        | staging.home.arpa | A    | 192.168.x.x | Kubernetes Staging Cluster - Control Plane Node 03                  |
| k8s-wk01        | staging.home.arpa | A    | 192.168.x.x | Kubernetes Staging Cluster - Data Plane Node 01                     |
| k8s-wk02        | staging.home.arpa | A    | 192.168.x.x | Kubernetes Staging Cluster - Data Plane Node 02                     |
| talos-endpoints | staging.home.arpa | A    | 192.168.x.x | Kubernetes Staging Cluster - Load balanced Talos Endpoints          |
| control-plane   | staging.home.arpa | A    | 192.168.x.x | Kubernetes Staging Cluster - Load balanced Kubernetes API Server    |

## Observations

### Hang-ups

#### Custom RPI_EFI.fd per-serial

If I use the method of a custom `RPI_EFI.fd` per-serial number, I end up getting stuck on the same screen as Michael

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

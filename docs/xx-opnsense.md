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

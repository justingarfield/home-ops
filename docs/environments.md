# Environments

My home-ops environments will most likely look different than what you're used to seeing in a pristine Azure/AWS version of Docker. I'm not a millionaire, so I can't afford to have 20+ servers all matching perfectly with storage arrays backing them all.

My home-ops clusters are considered heterogeneous as they mix amd64 and ARM arechitectures; as well as using differing hardware between some nodes (mainly worker nodes).

## Development

I don't currently have a development environment for my home-ops build-out, as there's just no way I can handle running the vast amount of resources required to test everything properly.

I do sometimes use Kubernetes in Docker (KIND) to test new charts locally and anything that only consists of basic moving parts.

## Staging

My staging environment consists of Hyper-V VMs using Hyper-V Network Switches that bind to physical NICs and sit on a VLAN of their own.

This environment has mimic'ed firewall rules, HA Proxy and BGP configurations to allow _real_ testing of the environment before changes proceed to physical Production hardware.

Using this environment allows me to make as many mistakes as needed before actually pushing to Production; reducing the amount of headaches and downtime.

| VM Name | vCPU | Memory (in GB) | Description |
|-|-|-|-|
| k8s-cp01 | 4 | 8  | Using to mimic a physical Raspberry Pi 4 Model B |
| k8s-cp02 | 4 | 8  | Using to mimic a physical Raspberry Pi 4 Model B |
| k8s-cp03 | 4 | 8  | Using to mimic a physical Raspberry Pi 4 Model B |
| k8s-wk01 | 8 | 24 | Using to mimic a custom amd64 worker |
| k8s-wk02 | 4 | 8  | Using to mimic a physical Raspberry Pi 4 Model B |

## Production

| VM Name | vCPU | Memory (in GB) | Description |
|-|-|-|-|
| k8s-cp01 | 4 | 8  | Raspberry Pi 4 Model B |
| k8s-cp02 | 4 | 8  | Raspberry Pi 4 Model B |
| k8s-cp03 | 4 | 8  | Raspberry Pi 4 Model B |
| k8s-wk01 | 36 | 128 | Custom amd64 worker |
| k8s-wk02 | 4 | 8  | Raspberry Pi 4 Model B |

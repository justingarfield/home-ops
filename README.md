# Home Ops

This repository contains configurations, resources, and scripts used to build-out my home environment in a GitOps-based manner.

I currently support two environments that I call `staging` and `production`.

Staging is a virtualized cluster running in Hyper-V on my desktop PC where I can freely destroy, rebuild, test, and provision things before introducing them to my physical "production" cluster in my basement.

As-such, all scripts and configuration files in this repository have been tokenized where possible (or as far as I was willing to take it depending on context and value).

## Directory layout

```sh
📂 home-ops
├─📁 .archive        # Old files I keep around for reference purposes
├─📁 .ci             # Continuous Integration (CI) tooling configurations
├─📁 .github         # GitHub Workflow and template items
├─📁 .taskfiles      # This repo uses Taskfiles vs. Makefiles (see https://taskfile.dev)
├─📁 .vscode         # Recommended extensions and settings for this repo
├─📁 assets          # Random assets used in repo documentation / charts / graphs
├─📁 docker          # Docker Compose files used for a local Container Registry and Pull-through-caches
├─📁 docs            # Folder containing detailed documentation about this repository
├─📁 flux            # Flux kustomizations used to automatically deploy Kubernetes resources / applications
├─📁 pki             # Holds Profiles and Templates used with cfssl toolkit to generate self-signed PKI
├─📁 scripts         # Shell scripts used to aid Taskfiles, where Tasks weren't expressive/scriptable enough
├─📁 sidero-metal    # Files from a sidero-metal lab I built, waiting on future physical hardware to deploy
├─📁 talos-linux     # Patch files used when generating control-plane and worker configurations for Talos Linux
└─📁 terraform       # Terraform files to provision Cloudflare DNS and Azure / Oracle cloud accounts
```

See each sub-directory for an additional `README.md` that describes each area in greater detail.

## Usage

Outside of making sure you have VS Code installed locally, this entire repository can be worked on using what I call the "Home Ops Toolchain". This is a multi-architecture (`amd64`/`arm64`) container image that comes pre-installed with all the same versions of tooling, folder mappings, etc. that I used to work on this stack daily.

The main factor behind working this way, is that I reached my breaking point trying to work across a Windows Desktop PC _(amd64)_, M2 MacBook Air (arm64), and a Linux Laptop (amd64)...not to mention trying to keep all the tooling binary versions in-sync across them all. Now I can just simply run the same version of the container image across all of them, and simply map some volumes into the container to work exactly the same across them all.

For more information on the Hoem Ops Toolchain and its usage, please see: [`docker/toolchain/README.md`](docker/toolchain/README.md)

## Why does this exist?

When you have a few pieces of software to configure / install on your machine, each using different port numbers, and not really interacting/conflicting with each other...things aren't really a big deal, just simply re-install them if you have to wipe your machine and start fresh.

Eventually you get to a point where multiple applications need to work together, share areas of storage, access each other with secrets (e.g. API keys), bind to the same port as other processes, and/or launch in a certain order _(e.g. Database first, API second, UI third)_. Now things are starting to get a bit complex, so we move all of that into Docker Containers and use Docker Compose to make sure things are started in the right order and what-not.

Now think about tacking on Home Automation hubs, Networked Storage, TLS Certificates, DNS records to allow external consumption while on-the-road, multiple nodes to run applications on so you can perform maintenence without giant outages, etc. This is where I finally broke and invested time in learning Kubernetes, Flux, GitOps, and all the other resources included in this repository. I can now work much faster without fear of screwing it all up, even if I had to rebuild it all from scratch! It also allows me to share all of this publicly (thanks SOPS!) with you, and best-of-all, everything is audited along the way in this GitHub repo :)

## VirtualBox on Windows Notes

You have two options if running Windows 10/11 regarding VirtualBox usage...

### Option 1: Don't use it

If you're a big fan of Windows Subsystem for Linux (WSL) and/or already using Hyper-V for VMs, make sure you don't install VirtualBox; the combo of software will constantly fight each other, lead to insane amounts of CPU stalling, poor memory management, and more.

### Option 2: Disable Hyper-V and WSL

If you don't care about Hyper-V or WSL, and want to use VirtualBox on Windows 10/11, then you need to eliminate all Hyper-V and Virtualization options under Add/Remove Windows Features / Roles and reboot.

Note: One word of caution if you do use VirtualBox. When configuring your attached HDDs, make sure you know what `Use Host I/O Cache` is _really_ doing before you decide to check that box. If you have workloads running that are writing lots of data, you could potentially lose a buttload of data during an unexpected shut-down. It may "go faster" with this option, but there are reasons.

### My thoughts on Windows + VirtualBox

IMHO, giving up WSL2 + Docker Desktop integration simply isn't worth the trade-offs. If you need to run other virtualized workloads along-side your K8s Cluster on Windows Desktop, use straight-up Hyper-V or VMWare Workstation.

I honestly tried going the VirtualBox route for 3-months during development of this repository, and the issues don't surface at first, but once you start deploying applications and place load on your cluster(s), Virtual Box starts to have tons of CPU stalls due to 10s-of-millions of context-switches happening, and will blow-out your `vmmem` process in Windows choking your CPU.

## Inspired by

* https://github.com/toboshii/home-ops/tree/main/cluster/flux/flux-system
* https://github.com/siderolabs/talos/blob/main/Dockerfile
* https://github.com/onedr0p/home-ops
* https://github.com/bjw-s/home-ops
* https://k8s-at-home.com/

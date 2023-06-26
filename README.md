# Home Ops

This repository contains configurations, resources, and scripts used to build-out my home environment in a GitOps-based manner.

I currently support two environments that I call `staging` and `production`.

Staging is a virtualized cluster running in VirutalBox on my desktop PC where I can freely destroy, rebuild, test, and provision new things before introducing them to my physical "production" cluster in my basement.

As-such, all scripts and configuration files in this repository have been tokenized where possible (or as far as I was willing to take it depending on context and value).

## Directory layout

```sh
📂 home-ops
├─📁 .ci             # Continuous Integration (CI) tooling configurations
├─📁 .github         # GitHub Workflow and template items
├─📁 .taskfiles      # This repo uses Taskfiles vs. Makefiles (see https://taskfile.dev)
├─📁 assets          # Random assets used in repo documentation / charts / graphs
├─📁 docker          # Docker Compose files used for a local Container Registry and Pull-through-caches
├─📁 docs            # Folder containing detailed documentation about this repository
├─📁 flux            # Flux kustomizations used to automatically deploy Kubernetes resources / applications
├─📁 pki             # Holds Profiles and Templates used with cfssl toolkit to generate self-signed PKI
├─📁 scripts         # Shell scripts used to aid Taskfiles, where Tasks weren't expressive/scriptable enough
├─📁 sidero-metal    # Files from a sidero-metal lab I built, waiting on future physical hardware to deploy
├─📁 talos-linux     # Patch files used when generating control-plane and worker configurations for Talos Linux
└─📁 terraform       # Terraform files to provision Azure-backed State Storage and Cloudflare DNS
```

See each sub-directory for an additional `README.md` that describes that area more in-depth.

## Instructions

This repository assumes it's being run in an [Ubuntu 22.04](https://ubuntu.com/) w/ Bash environment _(or similar. I'm running all of this in Ubuntu 22.04 under Windows Subsystem for Linux)_. Your mileage may vary!

I have moved pretty much everything into [Task](https://taskfile.dev/) at this point. The Makefile assumes you have [Go](https://go.dev/) installed, and pretty much only covers installing Task to bootstrap with more-or-less.

```shell
make install-task

task
```

## Inspired by

* https://github.com/toboshii/home-ops/tree/main/cluster/flux/flux-system
* https://github.com/onedr0p/home-ops
* https://github.com/bjw-s/home-ops
* https://k8s-at-home.com/
das

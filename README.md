# Home Ops

This repository contains configurations, resources, and scripts used to build-out my home environment.

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

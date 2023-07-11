# infrastructure folder

## Overview

Everything contained under this folder pertains to infrastructure-level controllers / pods / configurations, etc.

This is where I place things that will be used cluster-wide and should only be touchable by an 'Operator/Admin'.

This should always be deployed / reconciled _before_ `apps` gets referenced; as `apps` will have many dependencies on these resources.

## Directory layout

```sh
📁 infrastructure
├─📁 base                      # Contains core files used to compose overlays and final resource deployments
│ ├─📁 authelia                # OSS authentication and authorization server and portal fulfilling IAM
│ ├─📁 cert-manager            # Cloud native certificate management
│ ├─📁 cilium                  # eBPF-based Networking, Observability, Security
│ ├─📁 csi-driver-smb          # Allows Kubernetes to access SMB server on both Linux and Windows nodes
│ ├─📁 external-dns            # Synchronizes exposed Kubernetes Services and Ingresses with DNS providers
│ ├─📁 flux-system
│ │ ├─📁 alerts                # Alerts used to send Flux-related notifications to Discord, Slack, etc.
│ │ └─📁 providers             # Providers used by Alerts as the "mechanism" to send their notifications
│ ├─📁 lldap                   # Lightweight auth server provides opinionated/simplified LDAP for authentication
│ ├─📁 node-feature-discovery  # A Kubernetes add-on for detecting hardware features and system configuration
│ ├─📁 piraeus                 # (have not tried yet) Cloud native datastore for Kubernetes
│ ├─📁 reloader                # Controller to watch changes in ConfigMap/Secrets and do rolling upgrades
│ ├─📁 rook-ceph               # File, Block, and Object Storage Services for your Cloud-Native Environments
│ ├─📁 tetragon                # eBPF-based Security Observability and Runtime Enforcement
│ └─📁 weave-gitops            # https://github.com/weaveworks/weave-gitops (easier to just see their overview)
└─📁 overlays
  ├─📁 production              # Overlay used to deploy infrastructure base in my Production environment
  └─📁 staging                 # Overlay used to deploy infrastructure base in my Staging environment
```

## Notes

### Directory Layout Decisions

This flux folder layout started by following the [official Flux multi-cluster example repository](https://github.com/fluxcd/flux2-kustomize-helm-example), but I had some considerations that I also wanted to address while working through my build-out, so this is where I ended-up for now.

One aspect I wanted to address, was making sure that resources were split based-upon Responsibility/Role and also Domain/Functional Area.

As far as Responsibility/Role goes, anything under this `infrastructure` folder is expected to be performed by an Ops/Administrator role; where-as all resources under the `./apps/` folder is expected to be deployed by Engineers/Devs, etc. Of course this is a bit different with private home clusters, but I figured keeping the separation of concerns may pay-off down the road when I start doing more in-depth network/device hardening.

Re: Domain/Functional Area, this is the reasoning behind having SOPS secrets sit along-side each individual deployment, application, and what-have-you. It may add another layer or two of indirecation/abstraction, but makes for easy cleanup down the road, and also keeps things sane when trying to focus on fixing a particular piece of the puzzle.

Don't feel you need to adhere to these structures if you're using this as reference for your own project(s). Flux CD was designed to let you compose things however you may need, so there's certainly no one-size-fits-all solution.

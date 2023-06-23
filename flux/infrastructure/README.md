# infrastructure folder

## Overview

Everything contained under this folder pertains to infrastructure-level controllers / pods / configurations, etc.

This is where I place things that will be used cluster-wide and should only be touchable by an 'Operator/Admin'.

This should always be run / complete / reconciled before 'Apps' loads, as Apps will have many dependencies on these resources.

## Directory layout

```sh
📁 infrastructure
├─📁 alerts            # alerts are used to send flux-related notifications to Discord, Slack, etc.
├─📁 config            # configuration resources that are used by the infrastructure controllers
├─📁 controllers       # the actual infrastructure controller helmrelease definitions / configurations
├─📁 crds              # crds that are required by the controllers under here
├─📁 namespaces        # namespaces created before any of these resources (allows security labels to be applied)
├─📁 providers         # providers are used by alerts as the "mechanism" to send their notifications
└─📁 repositories      # repositoty definitions that are used to download charts, raw git repos, etc.
```

## Notes

I tried my best at conforming to the [official Flux multi-cluster example repository](https://github.com/fluxcd/flux2-kustomize-helm-example), but some things needed more refactoring due to security, configuration, and race-condition related reasons.

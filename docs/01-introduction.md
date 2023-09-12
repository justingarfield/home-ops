# Introduction

My home lab has a _lot_ of moving parts, and would be near-impossible to describe in a few paragraphs, so I've broken it all up into a multi-section guide within this repository, so that you can dive-in and focus on the parts you find interesting or helpful.

## Assumptions / Limitations

* I don't currently have a large budget to buy new hardware, so I'm using what I have available
* This is not a "template" like some of the other repositories out there, this is public for others to derive ideas and solutions from. Feel free to copy things out of here, but don't expect it all to work verbatim
* I use custom PKI generated with the Cloudflare `cfssl` toolkit, as I don't want to rely on `cert-manager`` for everything _(Kubernetes is an addition in my environment, not a pre-req)_
* Some functionality on my OPNsense firewalls _could_ run in Kubernetes, but I'm keeping my Firewalls / Load Balancing, etc. separate from K8s so that I still have minimal functionality in the event I completely f**k-up my K8s cluster _(it's a home lab, I don't have a company Credit Card to spin-up 20 new VMs on for testing)_

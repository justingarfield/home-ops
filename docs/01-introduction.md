# Introduction

My home lab has a _lot_ of moving parts, and would be near-impossible to describe in a few paragraphs, so I've broken it all up into a multi-section guide within this repository, so that you can dive-in and focus on the parts you find interesting or helpful.

## Why does this repository exist?

When you have a few pieces of software to configure / install on your machine, each using different port numbers, and not really interacting/conflicting with each other...things aren't really a big deal, just simply re-install them if you have to wipe your machine and start fresh.

Eventually you get to a point where multiple applications need to work together, share areas of storage, access each other with secrets (e.g. API keys), bind to the same port as other processes, and/or launch in a certain order _(e.g. Database first, API second, UI third)_. Now things are starting to get a bit complex, so we move all of that into Docker Containers and use Docker Compose to make sure things are started in the right order and what-not.

Now think about tacking on Home Automation hubs, Networked Storage, TLS Certificates, DNS records to allow external consumption while on-the-road, multiple nodes to run applications on so you can perform maintenence without giant outages, etc. This is where I finally broke and invested time in learning Kubernetes, Flux, GitOps, and all the other resources included in this repository. I can now work much faster without fear of screwing it all up, even if I had to rebuild it all from scratch! It also allows me to share all of this publicly (thanks SOPS!) with you, and best-of-all, everything is audited along the way in this GitHub repo :)

## Usage

Outside of making sure you have VS Code installed locally, this entire repository can be worked on using what I call the "Home Ops Toolchain". This is a multi-architecture (`amd64`/`arm64`) container image that comes pre-installed with all the same versions of tooling, folder mappings, etc. that I used to work on this stack daily.

The main factor behind working this way, is that I reached my breaking point trying to work across a Windows Desktop PC _(amd64)_, M2 MacBook Air _(arm64)_, and a Linux Laptop _(amd64)_...not to mention trying to keep all the tooling binary versions in-sync across them all. Now I can just simply run the same version of the container image across all of them, and simply map some volumes into the container to work exactly the same across them all.

For more information on the Home Ops Toolchain and its usage, please see: [`docker/toolchain/README.md`](docker/toolchain/README.md)

## Assumptions / Limitations

* I don't currently have a large budget to buy new hardware, so I'm using what I have available
* This is not a "template" like some of the other repositories out there, this is public for others to derive ideas and solutions from. Feel free to copy things out of here, but don't expect it all to work verbatim
* I use custom PKI generated with the Cloudflare `cfssl` toolkit, as I don't want to rely on `cert-manager`` for everything _(Kubernetes is an addition in my environment, not a pre-req)_
* Some functionality on my OPNsense firewalls _could_ run in Kubernetes, but I'm keeping my Firewalls / Load Balancing, etc. separate from K8s so that I still have minimal functionality in the event I completely f**k-up my K8s cluster _(it's a home lab, I don't have a company Credit Card to spin-up 20 new VMs on for testing)_
* I live in an area that's somewhat away from the city, therefore my environment must be prepared for power outages in the winter months

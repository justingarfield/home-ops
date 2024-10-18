# Introduction

My home lab has a _lot_ of moving parts, and would be near-impossible to describe in a few paragraphs, so I've broken it all up into a multi-section guide within this repository, so that you can dive-in and focus on the parts you find interesting or helpful.

## Table of Contents

* [Why does this repository exist?](#why)
* [Directory Layouts](#wsl)
* [Environments](#environments)
  * [Development](#environments-development)
  * [Staging](#environments-staging)
  * [Production](#environments-production)
* [Assumptions / Limitations](#assumptions-and-limitations)

## <a id="why"></a>Why does this repository exist?

When you have a few pieces of software to configure / install on your machine, each using different port numbers, and not really interacting/conflicting with each other...things aren't really a big deal, just simply re-install them if you have to wipe your machine and start fresh.

Eventually you get to a point where multiple applications need to work together, share areas of storage, access each other with secrets (e.g. API keys), bind to the same port as other processes, and/or launch in a certain order _(e.g. Database first, API second, UI third)_. Now things are starting to get a bit complex, so we move all of that into Docker Containers and use Docker Compose to make sure things are started in the right order and what-not.

Now think about tacking on Home Automation hubs, Networked Storage, TLS Certificates, DNS records to allow external consumption while on-the-road, multiple nodes to run applications on so you can perform maintenence without giant outages, etc. This is where I finally broke and invested time in learning Kubernetes, Flux, GitOps, and all the other resources included in this repository. I can now work much faster without fear of screwing it all up, even if I had to rebuild it all from scratch! It also allows me to share all of this publicly _(thanks SOPS!)_ with you, and best-of-all, everything is audited along the way in this GitHub repo :)

## <a id="directory-layouts"></a>Directory Layouts

Each directory in the root of the repository has its own README.md to help break-down what the folders / files in each do.

If you're already familiar with building out Kubernetes clusters, infrastructure as code (IaC), etc. that's probably the easiest place to start if you're just looking to see how I implemented a particular piece of the overall puzzle.

## <a id="environments"></a>Environments

My home-ops environments will most likely look different than what you're used to seeing in a pristine Azure/AWS environment. I'm not a millionaire, so I can't afford to have 20+ servers all matching perfectly with storage arrays backing them all.

My home-ops clusters are considered heterogeneous as they mix amd64 and ARM arechitectures; as well as using differing hardware between some nodes (mainly worker nodes).

### <a id="environments-development"></a>Development

I don't currently have a development environment for my home-ops build-out, as there's just no way I can handle running the vast amount of resources required to test everything properly.

### <a id="environments-staging"></a>Staging

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

### <a id="environments-production"></a>Production

| VM Name | vCPU | Memory (in GB) | Description |
|-|-|-|-|
| k8s-cp01 | 4 | 8  | Raspberry Pi 4 Model B |
| k8s-cp02 | 4 | 8  | Raspberry Pi 4 Model B |
| k8s-cp03 | 4 | 8  | Raspberry Pi 4 Model B |
| k8s-wk01 | 36 | 128 | Custom amd64 worker |
| k8s-wk02 | 4 | 8  | Raspberry Pi 4 Model B |

## <a id="assumptions-and-limitations"></a>Assumptions / Limitations

* I don't currently have a large budget to buy new hardware, so I'm using what I have available
* This is not a "template" like some of the other repositories out there, this is public for others to derive ideas and solutions from. Feel free to copy things out of here, but don't expect it all to work verbatim
* I use custom PKI generated with the Cloudflare `cfssl` toolkit, as I don't want to rely on `cert-manager`` for everything _(Kubernetes is an addition in my environment, not a pre-req)_
* Some functionality on my OPNsense firewalls _could_ run in Kubernetes, but I'm keeping my Firewalls / Load Balancing, etc. separate from K8s so that I still have minimal functionality in the event I completely f**k-up my K8s cluster _(it's a home lab, I don't have a company Credit Card to spin-up 20 new VMs on for testing)_
* I live in an area that's somewhat away from the city, therefore my environment must be prepared for power outages in the winter months

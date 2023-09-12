
## Virtualization

I currently run my 'staging' environment on Hyper-V VMs. The machine on which they run has an abundance of RAM, but limited CPU _(as its also my gaming machine at this point in-time)_.

I would not recommend running a 3-node CP / 2-node DP on anything less than an 8-core CPU and 64GB RAM. Even then, do not expect to run things like `rook-ceph` or solutions that require massive amounts of resources in-general _(e.g. giant-ass databases)_.

Remember, each VM is going to be requiring time-slices from your cores, and if too many requests are in-play, you can expect CPU stalls, timeouts, etc. which will _Michael Bay Explode™_ your cluster and/or cause Pods to start rescheduling like crazy and never coming back up.

For an actual 24/7 'Production' cluster, you're going to want much beefier hardware, and this type of setup should only be used to test your configurations and what-not.

### VirtualBox on Windows Notes

You have two options if running Windows 10/11 regarding VirtualBox usage...

#### Option 1: Don't use it

If you're a big fan of Windows Subsystem for Linux (WSL) and/or already using Hyper-V for VMs, make sure you don't install VirtualBox; the combo of software will constantly fight each other, lead to insane amounts of CPU stalling, poor memory management, and more.

#### Option 2: Disable Hyper-V and WSL

If you don't care about Hyper-V or WSL, and want to use VirtualBox on Windows 10/11, then you need to eliminate all Hyper-V and Virtualization options under Add/Remove Windows Features / Roles and reboot.

Note: One word of caution if you do use VirtualBox. When configuring your attached HDDs, make sure you know what `Use Host I/O Cache` is _really_ doing before you decide to check that box. If you have workloads running that are writing lots of data, you could potentially lose a buttload of data during an unexpected shut-down. It may _go faster_ with this option, but there are reasons.

#### My thoughts on Windows + VirtualBox

IMHO, giving up WSL2 + Docker Desktop integration simply isn't worth the trade-offs. If you need to run other virtualized workloads along-side your K8s Cluster on Windows Desktop, use straight-up Hyper-V or VMWare Workstation.

I honestly tried going the VirtualBox route for 3-months during development of this repository, and the issues don't surface at first, but once you start deploying applications and place load on your cluster(s), Virtual Box starts to have tons of CPU stalls due to 10s-of-millions of context-switches happening, and will blow-out your `vmmem` process in Windows choking your CPU.

# Windows PowerShell Desired State Configuration (DSC)

This folder contains PowerShell Desired State Configuration (DSC) files to configure a Talos Linux Hyper-V Lab.

**SecureBoot Note**: This will only work with VMs that have SecureBoot disabled. Hyper-V _still_ doesn't allow
importing your own PK / KEK keys in Hyper-V at the time of this writing. If you want the full Secure Boot
experience with Talos v1.5.1+ you'll need to use something like QEMU or VMWare Desktop Professional (Paid).

## Directory layout

```shell
📂 windows-dsc
├─📄 HyperVDscPreRequisites.ps1   # Provisions the prerequisites required to use the HyperVDsc module
├─📄 LCMConfiguration.ps1         # Optional file to configure the Local Configuration Manager (LCM)
└─📄 TalosLinuxCluster.ps1        # Provisions a local Hyper-V Talos lab / staging environment
```

## StartingMacPrefix

The `$controlPlaneNodes` and `$dataPlaneNodes` hash-table params control basic settings for the Talos VMs.

One of the properties inside of these is named `StartingMacPrefix`.

I use Static MAC Addresses for VMs in my environment, so that I can control Static IP DHCP Leases for them via my OPNsense firewalls.

The default in my DSC script is to start Control Plane Nodes with `0013371337<node num>` (e.g. `001337133701`, `001337133702`, `001337133703`)

The default in my DSC script is to start Data Plane Nodes with `0013371338<node num>` (e.g. `001337133801`, `001337133802`, `001337133803`)

If you would rather have dynamic MACs assigned by Hyper-V, simply comment out the `MACAddress` proeprty on the `VMHyperV` resources.

## Usage

On a Windows 11 Professional machine, with Windows Updates applied, run the following scripts in an 'older' (e.g. _PowerShell 5.1_) PowerShell session. _(Hyper-V cmdlets do not support newer cross-platform PowerShell)._

```shell
. .\HyperVDscPreRequisites.ps1

# Adjust $controlPlaneNodes and $dataPlaneNodes params to your liking
# Make sure that the StartingMacPrefix won't screw with your existing environment
# Set $AttachIsoFile to $true when VMs are created and ready for Talos installer ISO and re-run this
. .\TalosLinuxCluster.ps1
```

## Limitations

* The `HyperVDsc` module currently has issues with the `VMDvdDrive` resource for VMs that don't currently exist yet in Hyper-V. To get around this limitation, I added an `$AttachIsoFile` flag that can be toggled `$true` or `$false` to add/remove the DVD Drive / ISO Install file _after_ an initial run of the script to create the VMs.
* The script(s) currently support up to 99 of each node type (control plane / data plane) due to the way naming works. _(This can be easily adjusted, although 99 nodes of either type in a Lab Setup would be a bit insane)_

## References

* https://github.com/dsccommunity/HyperVDsc/wiki
* https://learn.microsoft.com/en-us/powershell/gallery/powershellget/update-powershell-51?view=powershellget-2.x
* https://learn.microsoft.com/en-us/powershell/dsc/getting-started/wingettingstarted?view=dsc-1.1

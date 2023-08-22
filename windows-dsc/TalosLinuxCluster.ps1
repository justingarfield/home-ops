#####
#
# Configures Hyper-V with:
#   - Control Plane vSwitch (External)
#   - Data Plane vSwitch (External)
#   - 3 x Control Plane VMs (with static MACs)
#   - 2 x Data Plane VMs (with static MACs)
#
# Note: Make sure you've installed the prerequisites using HyperVDscPreRequisites.ps1 prior to using this.
#
# . .\TalosLinuxCluster.ps1
# Test-DscConfiguration -Path .\TalosLinuxCluster
# Start-DscConfiguration -Path .\TalosLinuxCluster -Wait -Verbose -Force
#
#####

Configuration TalosLinuxCluster
{
    param
    (
        [Parameter()]
        [string]
        [ValidateNotNullorEmpty()]
        $NodeName = "localhost",

        [Parameter()]
        [string]
        [ValidateNotNullorEmpty()]
        $TalosLinuxIso = "F:\temp\talos-v1.5.0-custom-metal-amd64.iso",

        # Because simple things never work in PowerShell DSC modules
        [Parameter()]
        [bool]
        $AttachIsoFile = $true,

        [Parameter()]
        [HashTable]
        $controlPlaneNodes = @{
            Count = 3
            VirtualHardDiskPath = "C:\Hyper-V\Talos"
            VirtualMachinePath  = "C:\Hyper-V\Talos"
            SystemDiskSizeInGB  = 100  # This is recommended size, minimum is 10GB
            MemorySizeInMB      = 4096 # This is recommended size, minimum is 2GB
            Cores               = 4    # This is recommended count, minimum is 2-cores
            StartingMacPrefix   = "0013371337"
        },

        [Parameter()]
        [HashTable]
        $dataPlaneNodes = @{
            Count = 2
            VirtualHardDiskPath = "F:\Hyper-V\Talos"
            VirtualMachinePath  = "F:\Hyper-V\Talos"
            SystemDiskSizeInGB  = 100  # This is recommended size, minimum is 10GB
            MemorySizeInMB      = 2048 # This is recommended size, minimum is 1GB
            Cores               = 2    # This is recommended count, minimum is 1-core
            StartingMacPrefix   = "0013371338"
        }
    )

    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName "HyperVDsc"

    Node $NodeName
    {
        #**********************************************************
        # Local configuration manager settings
        #
        # This section contains settings for the LCM of the host
        # that this configuration is applied to
        #**********************************************************
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        # Install HyperV feature, if not installed - Server SKU only
        WindowsOptionalFeature HyperV {
            Name =  "Microsoft-Hyper-V-All"
            Ensure = "Enable"
        }

        VMSwitch ControlPlaneSwitch
        {
            Type                     = "External"
            NetAdapterName           = @("K8sStagingCp")
            AllowManagementOS        = $false
            Ensure                   = "Present"
            Name                     = "K8sStaging-ControlPlane"
            DependsOn                = "[WindowsOptionalFeature]HyperV"
        }

        VMSwitch DataPlaneSwitch
        {
            Type                     = "External"
            NetAdapterName           = @("K8sStagingDp")
            AllowManagementOS        = $false
            Ensure                   = "Present"
            Name                     = "K8sStaging-DataPlane"
            DependsOn                = "[WindowsOptionalFeature]HyperV"
        }

        # Control Plane Nodes
        For ($nodeNum=1; $nodeNum -le $controlPlaneNodes.Count; $nodeNum++) {

            $vmNamePrefix = "TalosStagingCp"
            $paddedNodeNum = $nodeNum.tostring().padleft(2, "0")
            $vmName = "${vmNamePrefix}${paddedNodeNum}"
            $macAddress = $controlPlaneNodes.StartingMacPrefix + $paddedNodeNum

            Vhd $vmName
            {
                Name             = "$vmName-SystemDisk.vhdx"
                Path             = $controlPlaneNodes.VirtualHardDiskPath
                # ParentPath     = Not using Checkpoints or Differencing Disks since this is a repeatable IaC Lab
                MaximumSizeBytes = $controlPlaneNodes.SystemDiskSizeInGB * 1048576
                Generation       = "vhdx"
                Ensure           = "Present"
                Type             = "Dynamic"
                DependsOn        = "[VMSwitch]ControlPlaneSwitch"
            }

            $vhdPath = (Join-Path -Path $controlPlaneNodes.VirtualHardDiskPath -ChildPath "$vmName-SystemDisk.vhdx")
            VMHyperV $vmName
            {
                Name                        = $vmName
                VhdPath                     = $vhdPath
                SwitchName                  = "K8sStaging-ControlPlane"
                # State                     = Leaving this as a manual operation
                Path                        = $controlPlaneNodes.VirtualMachinePath
                Generation                  = 2
                StartupMemory               = $controlPlaneNodes.MemorySizeInMB * 1048576
                MinimumMemory               = 512 * 1048576
                MaximumMemory               = 1048576 * 1048576
                MACAddress                  = $macAddress
                ProcessorCount              = $controlPlaneNodes.Cores
                # WaitForIP                 =
                # RestartIfNeeded           =
                Ensure                      = "Present"
                Notes                       = "Talos Linux Control Plane Node"
                SecureBoot                  = $false
                EnableGuestService          = $false # Talos doesn't support Hyper-V Guest Services
                AutomaticCheckpointsEnabled = $false
                DependsOn                   = "[Vhd]$vmName"
            }

            If ($AttachIsoFile) {
                VMDvdDrive $vmName
                {
                    Ensure             = If ($AttachIsoFile) {"Present"} Else {"Absent"}
                    VMName             = $vmName
                    ControllerNumber   = 0
                    ControllerLocation = 1
                    Path               = $TalosLinuxIso
                    DependsOn          = "[VMHyperV]$vmName"
                }
            }
        }

        # Data Plane Nodes
        For ($nodeNum=1; $nodeNum -le $dataPlaneNodes.Count; $nodeNum++) {

            $vmNamePrefix = "TalosStagingDp"
            $paddedNodeNum = $nodeNum.tostring().padleft(2, "0")
            $vmName = "${vmNamePrefix}${paddedNodeNum}"
            $macAddress = $dataPlaneNodes.StartingMacPrefix + $paddedNodeNum

            Vhd $vmName
            {
                Name             = "$vmName-SystemDisk.vhdx"
                Path             = $dataPlaneNodes.VirtualHardDiskPath
                # ParentPath     = Not using Checkpoints or Differencing Disks since this is a repeatable IaC Lab
                MaximumSizeBytes = $dataPlaneNodes.SystemDiskSizeInGB * 1048576
                Generation       = "vhdx"
                Ensure           = "Present"
                Type             = "Dynamic"
                DependsOn        = "[VMSwitch]DataPlaneSwitch"
            }

            $vhdPath = (Join-Path -Path $dataPlaneNodes.VirtualHardDiskPath -ChildPath "$vmName-SystemDisk.vhdx")
            VMHyperV $vmName
            {
                Name                        = $vmName
                VhdPath                     = $vhdPath
                SwitchName                  = "K8sStaging-DataPlane"
                # State                     = Leaving this as a manual operation
                Path                        = $dataPlaneNodes.VirtualMachinePath
                Generation                  = 2
                StartupMemory               = $dataPlaneNodes.MemorySizeInMB * 1048576
                MinimumMemory               = 512 * 1048576
                MaximumMemory               = 1048576 * 1048576
                MACAddress                  = $macAddress
                ProcessorCount              = $dataPlaneNodes.Cores
                # WaitForIP                 =
                # RestartIfNeeded           =
                Ensure                      = "Present"
                Notes                       = "Talos Linux Data Plane Node"
                SecureBoot                  = $false
                EnableGuestService          = $false # Talos doesn't support Hyper-V Guest Services
                AutomaticCheckpointsEnabled = $false
                DependsOn                   = "[Vhd]$vmName"
            }

            If ($AttachIsoFile) {
                VMDvdDrive $vmName
                {
                    Ensure             = If ($AttachIsoFile) {"Present"} Else {"Absent"}
                    VMName             = $vmName
                    ControllerNumber   = 0
                    ControllerLocation = 1
                    Path               = $TalosLinuxIso
                    DependsOn          = "[VMHyperV]$vmName"
                }
            }
        }
    }
}

# Creates corresponding the MOF file
TalosLinuxCluster

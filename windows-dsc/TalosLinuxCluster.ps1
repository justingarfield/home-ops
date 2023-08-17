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
# Start-DscConfiguration -Path .\TalosLinuxCluster -Wait -Verbose
#
#####

Configuration TalosLinuxCluster
{
    param
    (
        [Parameter()]
        [string]
        [ValidateNotNullorEmpty()]
        $NodeName = 'localhost'
    )

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'HyperVDsc'

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
            Type                     = 'External'
            NetAdapterName           = @('K8sStagingCp')
            AllowManagementOS        = $false
            Ensure                   = 'Present'
            Name                     = 'K8sStaging-ControlPlane'
            DependsOn                = '[WindowsOptionalFeature]HyperV'
        }

        VMSwitch DataPlaneSwitch
        {
            Type                     = 'External'
            NetAdapterName           = @('K8sStagingDp')
            AllowManagementOS        = $false
            Ensure                   = 'Present'
            Name                     = 'K8sStaging-DataPlane'
            DependsOn                = '[WindowsOptionalFeature]HyperV'
        }
    }
}

$configurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'

            # https://docs.microsoft.com/en-us/powershell/dsc/pull-server/secureMOF
            PSDscAllowPlainTextPassword = $true
        }
    )
}

TalosLinuxCluster -ConfigurationData $configurationData

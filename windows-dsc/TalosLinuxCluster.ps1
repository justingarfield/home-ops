#####
# Please read this to avoid confusion and frustration...Because Microsoft hasn't made PowerShell enough of a shit-show over the years...
#
# "With the release of PowerShell 7.2, the PSDesiredStateConfiguration module is no longer included in the PowerShell package."
# - DSC 2.0 is supported for use with Azure Automanage's machine configuration feature. Other scenarios, such as directly calling DSC Resources with Invoke-DscResource, may be functional but aren't the primary intended use of this version.
# - If you aren't using Azure Automanage's machine configuration feature, you should use DSC 1.1.
# - DSC 3.0 is available in public beta and should only be used with Azure machine configuration (which supports it) or for non-production environments to test migrating away from DSC 1.1.
#
# Since I'm at the point of wanting to stab things in the face with my adventure of provisioning Hyper-V VMs with IaC, and things are working for my personal needs, I'm just using PowerShell 7.2 + DSC 2.0, even though I have no Azure Automanage machine config...blahblahblah involved in my environment.
#
# With all that said...Here's the TLDR;...
#
# Install-Module -Name PSDesiredStateConfiguration -Repository PSGallery -MaximumVersion 2.99
# Install-Module -Name HyperVDsc -Repository PSGallery -AllowPrerelease
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
    Import-DscResource -ModuleName HyperVDsc'

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
        WindowsFeature HyperV
        {
            Ensure = 'Present'
            Name   = 'Hyper-V'
        }

        WindowsFeature HyperVTools
        {
            Ensure    = 'Present'
            Name      = 'RSAT-Hyper-V-Tools'
            DependsOn = '[WindowsFeature]HyperV'
        }

        # Ensures a VM with Load Balancing Algorithm 'Hyper-V Port"
        VMSwitch ExternalSwitch
        {
            Ensure                  = 'Present'
            Name                    = $SwitchName
            Type                    = 'External'
            NetAdapterName          = $NetAdapterNames
            EnableEmbeddedTeaming   = $true
            LoadBalancingAlgorithm  = 'HyperVPort'
            DependsOn               = '[WindowsFeature]HyperVTools'
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

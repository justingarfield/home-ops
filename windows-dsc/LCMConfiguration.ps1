#####
#
# I use this file to allow the Desired State Configuration (DSC) Local
# Configuration Manager (LCM) to reboot the localhost node if required.
#
# Create a corresponding Management Object Format (MOF) file with:
#
#   . .\LCMConfiguration.ps1
#
#
# Apply the MOF file with:
#
#   Set-DscLocalConfigurationManager -Path .\LCMConfiguration
#
#
#####

[DSCLocalConfigurationManager()]
Configuration LCMConfiguration
{
    Node localhost
    {
        Settings
        {
            RebootNodeIfNeeded = $true
        }
    }
}

# Creates corresponding the MOF file
LCMConfiguration

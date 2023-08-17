#####
#
# IMPORTANT: I didn't end up using the Terraform HyperV Provider, as its backing
#            Python library requires configuring 'WinRM/Config/Service/Auth' to
#            'Basic' and 'WinRM/Config/Service:AllowUnencrypted' to '$true' which
#            is a really dumb move in today's security posture.
#
# This script is for use on a local Windows Desktop 10+ or Windows Server 2016+ instance.
#
# It adds a Local User named 'terraform', to be used by Terraform for provisioning Hyper-V VMs.
#
#####

param (
    [Parameter(Position = 0, Mandatory)]
    [string]
    $Username = "terraform",

    [Parameter(Position = 1, Mandatory)]
    [SecureString]
    $Password = (Read-Host -AsSecureString),

    [Parameter(Position = 2, Mandatory)]
    [SecureString]
    $FullName = "Terraform User",

    # I find it humorous that built-in account descriptions are > 48-chars, but we're not allowed more
    [Parameter(Position = 3, Mandatory)]
    [SecureString]
    [ValidateLength(0,48)]
    $Description = "Used by Terraform for provisioning Hyper-V VMs."
)

process {
    $ErrorActionPreference = "Stop"

    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
        Write-Error "This script MUST be run as Administrator!"
        return
    }

    if (Get-LocalUser $Username) {
        Write-Output "User $Username already exists. Skipping..."
        return
    }

    New-LocalUser $Username -Password $Password -FullName $FullName -Description $Description

    Add-LocalGroupMember -Group "Administrators" -Member $Username
}

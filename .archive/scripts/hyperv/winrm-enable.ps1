#####
#
# IMPORTANT: I didn't end up using the Terraform HyperV Provider, as its backing
#            Python library requires configuring 'WinRM/Config/Service/Auth' to
#            'Basic' and 'WinRM/Config/Service:AllowUnencrypted' to '$true' which
#            is a really dumb move in today's security posture.
#
# This script is for use on a local Windows Desktop 10+ or Windows Server 2016+ instance.
#
# It enables WinRM with negotiate authentication support.
#
#####

param (
    [Parameter(Position = 0)]
    [string]
    $ComputerName = "localhost"
)

process {
    $ErrorActionPreference = "Stop"

    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
        Write-Error "This script MUST be run as Administrator!"
        return
    }

    if (Test-WSMan -ComputerName $ComputerName -ErrorAction SilentlyContinue) {
        Write-Output "WinRM is already enabled."
    } else {
        Enable-PSRemoting -SkipNetworkProfileCheck -Force
    }

    if ((Get-WSManInstance WinRM/Config/WinRS).MaxMemoryPerShellMB -eq 1024) {
        Write-Output "WinRM/Config/WinRS:MaxMemoryPerShellMB already set to 1024. Skipping..."
    } else {
        Write-Output "WinRM/Config/WinRS:MaxMemoryPerShellMB not set to 1024. Configuring..."
        Set-WSManInstance WinRM/Config/WinRS -ValueSet @{MaxMemoryPerShellMB = 1024}
    }

    if ((Get-WSManInstance WinRM/Config).MaxTimeoutms -eq 1800000) {
        Write-Output "WinRM/Config:MaxTimeoutms already set to 1800000. Skipping..."
    } else {
        Write-Output "WinRM/Config:MaxTimeoutms not set to 1800000. Configuring..."
        Set-WSManInstance WinRM/Config -ValueSet @{MaxTimeoutms = 1800000}
    }

    if ((Get-WSManInstance WinRM/Config/Client).TrustedHosts -eq '*') {
        Write-Output "WinRM/Config/Client:TrustedHosts already set to '*'. Skipping..."
    } else {
        Write-Output "WinRM/Config/Client:TrustedHosts not set to '*'. Configuring..."
        Set-WSManInstance WinRM/Config/Client -ValueSet @{TrustedHosts = '*'}
    }

    if ((Get-WSManInstance WinRM/Config/Service/Auth).Negotiate -eq $true) {
        Write-Output "WinRM/Config/Service/Auth:Negotiate already set to $true. Skipping..."
    } else {
        Write-Output "WinRM/Config/Service/Auth:Negotiate not set to $true. Configuring..."
        Set-WSManInstance WinRM/Config/Service/Auth -ValueSet @{Negotiate = $true}
    }

    #=== These are required by the python library backing the Terraform HyperV Provider (so I'm not using it)

    # if ((Get-WSManInstance WinRM/Config/Service/Auth).Basic -eq $true) {
    #     Write-Output "WinRM/Config/Service/Auth:Basic already set to $true. Skipping..."
    # } else {
    #     Write-Output "WinRM/Config/Service/Auth:Basic not set to $true. Configuring..."
    #     Set-WSManInstance WinRM/Config/Service/Auth -ValueSet @{Basic = $true}
    # }

    # if ((Get-WSManInstance WinRM/Config/Service).AllowUnencrypted -eq $true) {
    #     Write-Output "WinRM/Config/Service:AllowUnencrypted already set to $true. Skipping..."
    # } else {
    #     Write-Output "WinRM/Config/Service:AllowUnencrypted not set to $true. Configuring..."
    #     Set-WSManInstance WinRM/Config/Service -ValueSet @{AllowUnencrypted = $true}
    # }
}

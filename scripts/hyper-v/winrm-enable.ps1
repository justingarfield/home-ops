#####
#
# This script is for use on a local Windows Desktop 10+ or Windows Server 2016+ instance.
#
# It enables WinRM with negotiate authentication supportm, so that Hyper-V may be provisioned using Terraform.
#
#####

param (
    [Parameter(Position = 0, Mandatory)]
    [string]
    $ComputerName = "localhost"
)

process {
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
}

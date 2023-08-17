###
#
# PowerShell has turned into a glorious shit-show with the introduction of PowerShell x-platform, DSC 1.1, 2.x, and 3.x
# spread-across many forums and articles, with many differing solutions depending on system state(s), patch levels, etc.
#
# This script will install the prerequisites to use the HyperVDsc module from the DSC Community on a FRESH Windows 11
# Professional install with Windows Updates applied.
#
# Run this script in an elevated instance of "old" PowerShell. HyperV does not support newer PowerShell cmdlets and DSC
# resources at the time of this writing. Don't even go down that rabbit hole unless you want to rip your hair out.
#
# Last tested on a fresh Windows 11 Pro VM on 2023-08-17.
#
###

param (
    [Parameter()]
    [string]
    [ValidateNotNullorEmpty()]
    $AddPSGalleryTrust = $true
)

# Required for newer PowerShellGet module
Set-ExecutionPolicy RemoteSigned CurrentUser -Force

# Make sure NuGet package provider >= 2.8 is installed
#
# Don't use -Name on Get-PackageProvider...will throw error vs. blank response for missing NuGet provider
#
# A 3.x copy of NuGet gets installed after you install NuGet 2.x to install PowerShellGet, because why not?...*sigh*
$nuget3x = Get-PackageProvider -ListAvailable | Where-Object -FilterScript { $_.Name -eq "NuGet" -and $_.Version.Major -eq 3 }
if ($null -ne $nuget3x) {
    Write-Output "Found Nuget package provider version $($nuget3x.Version.ToString()) already installed. Skipping..."

} else {
    # Handle installing 2.x NuGet so we can install PowerShellGet
    $nuget = Get-PackageProvider -ListAvailable | Where-Object -FilterScript { $_.Name -eq "NuGet" }
    if ($null -eq $nuget -or ($nuget.Version.Major -lt 2 -and $nuget.Version.Minor -lt 8)) {
        Install-PackageProvider -Name NuGet -Force
    } else {
        Write-Output "Found Nuget package provider version $($nuget.Version.ToString()) already installed. Skipping..."
    }
}

# Make sure the latest PowerShellGet module is installed
# This installs its own 3.x version of NuGet...because...PowerShell?...I seriously hate this shell.
$powerShellGet = Get-Module -ListAvailable | Where-Object -FilterScript { $_.Name -eq "PowerShellGet" -and $_.Version.Major -gt 1 }
if ($null -eq $powerShellGet -or ($powerShellGet.Version.Major -lt 2)) {
    Install-Module PowerShellGet -Force
    Write-Host -ForegroundColor Yellow "Please restart your PowerShell instance so that PowerShellGet > 2.x can load fully."
    return
} else {
    Write-Output "Found PowerShellGet module version $($powerShellGet.Version.ToString()) already installed. Skipping..."
}

if ($AddPSGalleryTrust) {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

try {
    $hyperVDsc = Get-Module -ListAvailable | Where-Object -FilterScript { $_.Name -eq "HyperVDsc" }
    if ($null -eq $hyperVDsc) {
        Install-Module -Name HyperVDsc -AllowPrerelease -Force
    } else {
        Write-Output "Found HyperVDsc module version $($hyperVDsc.Version.ToString()) already installed. Skipping..."
    }
} catch {
    $exceptionMessage = $_.Exception.Message.ToLower()
    if ($exceptionMessage -like "*parameter cannot be found*" -and $exceptionMessage -like "*allowprerelease*") {
        Write-Host -ForegroundColor Yellow "Please restart your PowerShell instance so that PowerShellGet > 2.x can load fully."
        return
    }
}

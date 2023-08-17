###
#
#
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

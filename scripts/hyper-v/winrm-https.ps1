#####
# This script is for use on a local Windows Desktop 10+ or Windows Server 2016+ instance.
#
# It enables HTTPS communication for WinRM, so that Hyper-V may be provisioned using Terraform.
#
# It's assumed that you have generated PKI files using CFSSL already, with a Root CA or Intermediary CA ready to-go.
#
# See: https://github.com/taliesins/terraform-provider-hyperv#setting-up-server-for-provider-usage
#
#####

# Note: I still need to do a cleanup pass on this to allow proper usage of Params, etc.

param (
    [Parameter(Position = 0, Mandatory)]
    [string]
    $WinRmHttpsCertificateThumbprint = "E9D1AE463E3982A18270CAECEAB8AFBA3A4E63D6"
)

process {
  $ErrorActionPreference = "Stop"

  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  if (-not ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
      Write-Error "This script MUST be run as Administrator!"
      return
  }

  $winRmHttpsCertificate = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {$_.Thumbprint -eq $winRmHttpsCertificateThumbprint}
  if ($null -eq $signingCert) {
    Write-Error "Unable to find a Certificate with a Thumbprint of $SignerCertThumbprint"
    return
  }

  Get-ChildItem wsman:\localhost\Listener\ | Where-Object -Property Keys -eq 'Transport=HTTPS' | Remove-Item -Recurse
  New-Item -Path WSMan:\localhost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $($winRmHttpsCertificate.Thumbprint) -Force -Verbose

  Restart-Service WinRM -Verbose

  New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "WinRMHTTPSIn" -Profile Any -LocalPort 5986 -Protocol TCP -Verbose
}

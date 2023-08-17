#####
#
# IMPORTANT: I didn't end up using the Terraform HyperV Provider, as its backing
#            Python library requires configuring 'WinRM/Config/Service/Auth' to
#            'Basic' and 'WinRM/Config/Service:AllowUnencrypted' to '$true' which
#            is a really dumb move in today's security posture.
#
# This script is for use on a local Windows Desktop 10+ or Windows Server 2016+ instance.
#
# It enables HTTPS communication for WinRM, so that Hyper-V may be provisioned using Terraform.
#
# It's assumed that you have generated PKI files using CFSSL already, with a Root CA or Intermediary CA ready to-go.
#
# See: https://github.com/taliesins/terraform-provider-hyperv#setting-up-server-for-provider-usage
#
#####

param (
    [Parameter(Position = 0, Mandatory)]
    [string]
    $WinRmHttpsCertificateThumbprint = ""
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

  if (Get-NetFirewallRule -Name "WinRMHTTPSIn") {
    Write-Output "WinRMHTTPSIn firewall rule already exists. Skipping..."
    return
  }

  New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "WinRMHTTPSIn" -Profile Any -LocalPort 5986 -Protocol TCP -Verbose
}

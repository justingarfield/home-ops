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
    $SignerCertThumbprint = "E2E742150117BB5809277AD42D7492C79970C754"
)

process {
  $ErrorActionPreference = "Stop"

  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  if (-not ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
      Write-Error "This script MUST be run as Administrator!"
      return
  }

  $signingCert = Get-ChildItem -Path Cert:\CurrentUser\CA | Where-Object {$_.Thumbprint -eq $SignerCertThumbprint}
  if ($null -eq $signingCert) {
    Write-Error "Unable to find a Certificate with a Thumbprint of $SignerCertThumbprint"
    return
  }

  #Create host certificate using CA
  $hostName = [System.Net.Dns]::GetHostName()
  $hostPassword = ConvertTo-SecureString "P@ssw0rd" -asplaintext -force
  $hostCertificate = Get-ChildItem cert:\LocalMachine\My |?{$_.subject -eq "CN=$hostName"}
  if (!$hostCertificate){
    if (Test-Path .\$hostName.cer) {
      remove-item .\$hostName.cer -force
    }
    if (Test-Path .\$hostName.pfx) {
      remove-item .\$hostName.pfx -force
    }
    $dnsNames = @($hostName, "localhost", "127.0.0.1") + [System.Net.Dns]::GetHostByName($env:computerName).AddressList.IpAddressToString

    $params = @{
      Type = 'Custom'
      DnsName = $dnsNames
      Subject = "CN=$hostName"
      KeyExportPolicy = 'Exportable'
      CertStoreLocation = 'Cert:\LocalMachine\My'
      KeyUsageProperty = 'All'
      KeyUsage = @('KeyEncipherment','DigitalSignature','NonRepudiation')
      TextExtension = @("2.5.29.37={text}1.3.6.1.5.5.7.3.1,1.3.6.1.5.5.7.3.2")
      Signer = $signingCert
      # Provider = 'Microsoft Strong Cryptographic Provider'
      Provider = 'Microsoft Enhanced RSA and AES Cryptographic Provider'
      KeySpec = 'KeyExchange'
      KeyLength = 2048
      HashAlgorithm = 'SHA256'
      KeyAlgorithm = 'RSA'
      NotAfter = (Get-date).AddYears(2)
    }
    $hostCertificate = New-SelfSignedCertificate @params
    Export-Certificate -Cert $hostCertificate -FilePath .\$hostName.cer -Verbose
    Export-PfxCertificate -Cert $hostCertificate -FilePath .\$hostName.pfx -Password $hostPassword -Verbose
    Get-ChildItem cert:\LocalMachine\My |?{$_.subject -eq "CN=$hostName"} | remove-item -force
    Import-PfxCertificate -FilePath .\$hostName.pfx -CertStoreLocation Cert:\LocalMachine\My -password $hostPassword -Exportable -Verbose
    $hostCertificate = Get-ChildItem cert:\LocalMachine\My |?{$_.subject -eq "CN=$hostName"}
  }
  return
  Get-ChildItem wsman:\localhost\Listener\ | Where-Object -Property Keys -eq 'Transport=HTTPS' | Remove-Item -Recurse
  New-Item -Path WSMan:\localhost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $($hostCertificate.Thumbprint) -Force -Verbose

  Restart-Service WinRM -Verbose

  New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "WinRMHTTPSIn" -Profile Any -LocalPort 5986 -Protocol TCP -Verbose
}

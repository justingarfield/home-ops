#####
# This script is for use on a local Windows Desktop 10+ or Windows Server 2016+ instance.
#
# It enables HTTPS communication for WinRM, so that Hyper-V may be provisioned using Terraform.
#
# It's assumed that you have generated PKI files using CFSSL already, with a Root CA ready to-go.
#####

# Note: I still need to do a cleanup pass on this to allow proper usage of Params, etc.

#Create CA certificate
$rootCaName = "DevRootCA"
$rootCaPassword = ConvertTo-SecureString "P@ssw0rd" -asplaintext -force
$rootCaCertificate = Get-ChildItem cert:\LocalMachine\Root |?{$_.subject -eq "CN=$rootCaName"}
if (!$rootCaCertificate){
  Get-ChildItem cert:\LocalMachine\My |?{$_.subject -eq "CN=$rootCaName"} | remove-item -force
  if (Test-Path .\$rootCaName.cer) {
    remove-item .\$rootCaName.cer -force
  }
  if (Test-Path .\$rootCaName.pfx) {
    remove-item .\$rootCaName.pfx -force
  }
  $params = @{
    Type = 'Custom'
    DnsName = $rootCaName
    Subject = "CN=$rootCaName"
    KeyExportPolicy = 'Exportable'
    CertStoreLocation = 'Cert:\LocalMachine\My'
    KeyUsageProperty = 'All'
    KeyUsage = 'None'
    Provider = 'Microsoft Strong Cryptographic Provider'
    KeySpec = 'KeyExchange'
    KeyLength = 4096
    HashAlgorithm = 'SHA256'
    KeyAlgorithm = 'RSA'
    NotAfter = (Get-Date).AddYears(5)
  }
  $rootCaCertificate = New-SelfSignedCertificate @params

  Export-Certificate -Cert $rootCaCertificate -FilePath .\$rootCaName.cer -Verbose
  Export-PfxCertificate -Cert $rootCaCertificate -FilePath .\$rootCaName.pfx -Password $rootCaPassword -Verbose
  Get-ChildItem cert:\LocalMachine\My |?{$_.subject -eq "CN=$rootCaName"} | remove-item -force
  Import-PfxCertificate -FilePath .\$rootCaName.pfx -CertStoreLocation Cert:\LocalMachine\Root -password $rootCaPassword -Exportable -Verbose
  Import-PfxCertificate -FilePath .\$rootCaName.pfx -CertStoreLocation Cert:\LocalMachine\My -password $rootCaPassword -Exportable -Verbose
  $rootCaCertificate = Get-ChildItem cert:\LocalMachine\My |?{$_.subject -eq "CN=$rootCaName"}
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
    Signer = $rootCaCertificate
    Provider = 'Microsoft Strong Cryptographic Provider'
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

Get-ChildItem wsman:\localhost\Listener\ | Where-Object -Property Keys -eq 'Transport=HTTPS' | Remove-Item -Recurse
New-Item -Path WSMan:\localhost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $($hostCertificate.Thumbprint) -Force -Verbose

Restart-Service WinRM -Verbose

New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "WinRMHTTPSIn" -Profile Any -LocalPort 5986 -Protocol TCP -Verbose

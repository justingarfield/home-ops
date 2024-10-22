< write powershell script to use Enable-BitLocker cmdlet and poll for "drive readiness" after application >

Enable-BitLocker -MountPoint "C:" -EncryptionMethod XtsAes256 -TpmProtector -UsedSpaceOnly
Restart-Computer
Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryKeyProtector -RecoveryKeyPath "D:\"

Enable-BitLocker -MountPoint "D:" -EncryptionMethod XtsAes256 -UsedSpaceOnly -PasswordProtector
Enable-BitLockerAutoUnlock -MountPoint "D:"
Enable-BitLocker -MountPoint "F:" -EncryptionMethod XtsAes256 -UsedSpaceOnly -PasswordProtector
Enable-BitLockerAutoUnloc

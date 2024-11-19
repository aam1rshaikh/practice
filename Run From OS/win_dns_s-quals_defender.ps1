Uninstall-WindowsFeature -Name Windows-Defender
ipconfig /registerdns
Add-LocalGroupMember -Group "Administrators" -Member "krft\s-qualys"
Start-Service -Name "RemoteRegistry"

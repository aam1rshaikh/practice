# SAP group
Add-LocalGroupMember -Group "Administrators" -Member "krft\MDLZ Global SAP Admin"
Add-LocalGroupMember -Group "Administrators" -Member "krft\MDLZ Global SAP_SID_GlobalAdmin"

##pagefile
# Get RAM size
$ramSizeGB = [math]::Ceiling((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB)

# Set no paging file for C drive
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'PagingFiles' -Value 'C:\pagefile.sys 0 0'

# Set custom paging file for D drive
$InitialSize = [math]::ceiling($ramSizeGB * 1024)
$MaximumSize = [math]::ceiling($ramSizeGB * 1024 * 1.5)

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'PagingFiles' -Value "D:\pagefile.sys $($InitialSize)MB $($MaximumSize)MB"


# Common tasks
Uninstall-WindowsFeature -Name Windows-Defender
ipconfig /registerdns
 
#Firewall disbale
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False -Verbose
 
#Windows License Addition
cscript c:\windows\system32\slmgr.vbs -skms MDZUSTULWUTL004
cscript c:\windows\system32\slmgr.vbs -ato
 
############################ Registery service start ##################################
Get-Service -Name RemoteRegistry | Start-Service
  
##WSUS
 
$regpath1= "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
 
 
 
        if(!(Test-Path $regpath1))
        {  
            New-Item -Path $regpath1 -Force | Out-Null
            New-ItemProperty -Path $regpath1 -Name NoAutoUpdate -PropertyType DWORD -Value 0 -Force | Out-Null
            New-ItemProperty -Path $regpath1 -Name UseWUServer -PropertyType DWORD -Value 1 -Force | Out-Null
            New-ItemProperty -Path $regpath1 -Name DetectionFrequency -PropertyType DWORD -Value 1 -Force | Out-Null
            New-ItemProperty -Path $regpath1 -Name DetectionFrequencyEnabled -PropertyType DWORD -Value 1 -Force | Out-Null
            New-ItemProperty -Path $regpath1 -Name AUOptions -PropertyType DWORD -Value 2 -Force | Out-Null
 
        }
        else
        {
            New-ItemProperty -Path $regpath1 -Name NoAutoUpdate -PropertyType DWORD -Value 0 -Force | Out-Null
            New-ItemProperty -Path $regpath1 -Name UseWUServer -PropertyType DWORD -Value 1 -Force | Out-Null
            New-ItemProperty -Path $regpath1 -Name DetectionFrequency -PropertyType DWORD -Value 1 -Force | Out-Null
            New-ItemProperty -Path $regpath1 -Name DetectionFrequencyEnabled -PropertyType DWORD -Value 1 -Force | Out-Null
            New-ItemProperty -Path $regpath1 -Name AUOptions -PropertyType DWORD -Value 2 -Force | Out-Null
        }   
 
##wazuh
#param($ipaddress)
#$ipaddress="170.162.65.236"
#$password = "H0UBikexrEs7VEJWEaJh0xBoHuJ7cNmS"
 
 
$return = Start-Process "msiexec.exe" -ArgumentList '/i C:\wazuh\wazuh-agent-4.4.3-1.msi /q WAZUH_MANAGER="170.162.65.236" WAZUH_REGISTRATION_SERVER="170.162.65.236" WAZUH_REGISTRATION_PASSWORD="H0UBikexrEs7VEJWEaJh0xBoHuJ7cNmS" WAZUH_AGENT_GROUP="windows,it-site,accenture,azure"' -Wait -passthru
#$return = Msiexec /i C:\wazuh\wazuh-agent-4.2.2-1.msi /q WAZUH_MANAGER="170.162.65.236" WAZUH_REGISTRATION_SERVER="170.162.65.236" WAZUH_REGISTRATION_PASSWORD=$password
 
If (@(0,3010) -contains $return.exitcode) { sc.exe query wazuhsvc } else {write-error $return.exitcode }
 
Start-Service -Name "wazuh"
 
# Disable IPv6 on all network adapters
Get-NetAdapter | ForEach-Object {
    Disable-NetAdapterBinding -InterfaceAlias $_.Name -ComponentID "ms_tcpip6"
}
 
# Function to disable Internet Explorer Enhanced Security Configuration
Function Disable-IEEnhancedSecurity {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
 
    # Disable for Administrators
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
 
    # Disable for Users
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
}
 
# Disable Internet Explorer Enhanced Security Configuration
Disable-IEEnhancedSecurity

#Restart
Restart-Computer -Force
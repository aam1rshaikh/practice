$CrashDump = Get-WmiObject -Class Win32_OSRecoveryConfiguration

####################################Set Registry Values ################################

reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v EnableLogFile /t REG_DWORD /d 1 /f
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v DumpLogLevel /t REG_DWORD /d 1 /f
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v AutoReboot /t REG_DWORD /d 1 /f

############################# Auto Reboot Enabled ################################

if ($CrashDump.AutoReboot -eq $False)
{
 $AutoReboot = $CrashDump | Set-WmiInstance -Arguments @{ AutoReboot= $true}
 if($AutoReboot.AutoReboot -eq $True)
 {
 $Reboot = "Enabled"
 Write-Host "AutoReboot Enabled"
 }
}
else
{Write-Host "AutoReboot Already Enabled"}

########################### Enable Complete Memory Dump ##########################

if( $CrashDump.DebugInfoType -ne 1)
{
$CrashDump.DebugInfoType = 1
$Dump = "Enabled"
Write-Host "Enabled"
}
elseif( $CrashDump.DebugInfoType -eq 1)
{
$Dump = "Already Enabled"
Write-Host "Already Enabled"
}

########################## Set Memory Dump Location ##################################
New-Item -ItemType Directory -Path C:\MemoryDump -Verbose -ErrorAction SilentlyContinue
$DebugPath = $CrashDump | Set-WmiInstance -Arguments @{ DebugFilePath= 'C:\MemoryDump\MEMORY.DMP'}
$Loc = $DebugPath.DebugFilePath
Write-Host "MemoryDump Location changed to" $DebugPath.DebugFilePath

############################ Registery service start ##################################
Get-Service -Name RemoteRegistry | Start-Service

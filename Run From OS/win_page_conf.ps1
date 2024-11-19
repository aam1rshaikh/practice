wmic COMPUTERSYSTEM set AutomaticManagedPagefile=true
$m = Get-WmiObject win32_operatingsystem -ComputerName $env:COMPUTERNAME | foreach {"{0:N2}" -f ($_.TotalVisibleMemorySize)/1mb}
$PageFileInitialSize= ($m * 1024)
$PageFileMaxSize = ($m * 1024) * 1.5
Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{Name="D:\pagefile.sys"; InitialSize = $PageFileInitialSize; MaximumSize = $PageFileMaxSize}

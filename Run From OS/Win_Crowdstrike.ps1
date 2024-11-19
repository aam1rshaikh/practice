$SourceCrowdStrikeExecutablePath= "\\170.162.88.9\c$\agents\Crowdstrike_WindowsSensor_6-38\WindowsSensor_6-38.exe"

$path = "C:\install"
If(!(test-path $path))
{
      # Creating Install folder under C drive in the current server
      New-Item -ItemType Directory -Force -Path $path -Verbose
}

# Copying agent files from Jump Server (170.162.88.9) to Current Machine

Get-ChildItem -Path $SourceCrowdStrikeExecutablePath | Copy-Item -Destination $path -Verbose

# Changing the location to install path
cd "C:\install\"

# Below script line install Crowd Strike
C:\install\WindowsSensor_6-38.exe /install /norestart ProvNoWait=1 PROXYDISABLE=1 CID=7A236230D4EE45AF9B9B183A92402B56-40 /quiet 
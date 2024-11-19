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
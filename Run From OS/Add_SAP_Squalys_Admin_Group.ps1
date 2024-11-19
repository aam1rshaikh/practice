
Add-LocalGroupMember -Group "Administrators" -Member "krft\MDLZ Global SAP Admin"
Add-LocalGroupMember -Group "Administrators" -Member "krft\MDLZ Global SAP_SID_GlobalAdmin"
Add-LocalGroupMember -Group "Administrators" -Member "krft\s-qualys"
Start-Service -Name "RemoteRegistry"
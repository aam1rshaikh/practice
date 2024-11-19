$username="krft\S-SRV_WIN_Mondelez"
$password=(ConvertTo-SecureString -String '38pLGQQ$96' -AsPlainText -Force)

$ou_name = Read-Host -Prompt 'Enter OU Name'

$cred = New-Object System.Management.Automation.PsCredential($username,$password)

#domain ADd
Add-Computer -DomainName "krft.net" -Credential $cred -OUPath "ou=$ou_name,ou=servers,OU=azure,DC=krft,DC=net"

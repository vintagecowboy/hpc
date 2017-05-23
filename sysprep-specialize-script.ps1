############################################################

## Title: Example start-up / sysprep script for HPC workers
## Author: richradley@google.com
## Date: 09-May-2017
############################################################
Add-PSSnapIn Microsoft.HPC

$domain = "[domain]"
$computer_name = [System.Net.Dns]::GetHostName()
$domain_user = "johndoe"
$domain_username = "$domain\$domain_user"
$domain_pass = "[pwd]"
$secpass = $domain_pass|ConvertTo-SecureString -AsPlainText -Force
$domain_cred = New-Object System.Management.Automation.PSCredential $domain_username,$secpass

$hostname = Get-GceMetadata -Path "instance/name"
$netbiosname = $hostname -replace '-',''

Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses "10.1.1.1"

if ($computer_name -ne $netbiosname) {
   # Perform the rename with appropriate credentials and restart the computer.
   Rename-Computer -NewName $netbiosname -DomainCredential $domain_cred -Force -PassThru
   Add-Computer -DomainName $domain -Credential $domain_cred -NewName $netbiosname -Force -Restart
}

Get-HpcNode -HealthState Unapproved -Name $netbiosname | Assign-HpcNodeTemplate -Name "Default ComputeNode Template" -Async -confirm:$False
Get-HpcNode -State Offline -Name $netbiosname | Set-HpcNodestate -State online

############################################################
## Title: Example start-up / sysprep script for HPC workers
## Author: richradley:google.com
## Date: 09-May-2017
############################################################

$domain = "hpc.rich-lab.com"

$user = "johndoe"
$username = "$domain\$user"
$password = "[pwd]"
$secpass=$password|ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $username,$secpass

# Set allowed ASCII character codes to Uppercase letters (65..90),
$charcodes = 65..90

# Convert allowed character codes to characters
$allowedChars = $charcodes | ForEach-Object { [char][byte]$_ }

$LengthOfName = 10
# Generate computer name
# $host = Get-GceMetadata -Path "instance/name"
$host = ($allowedChars | Get-Random -Count $LengthOfName) -join ""

Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses "10.1.1.1"
Add-Computer -DomainName $domain -Credential $credential
Rename-Computer -NewName $host -DomainCredential $credential -Force
Restart-Compute
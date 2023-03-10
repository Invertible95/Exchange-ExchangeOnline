## EXO = Exchange Online
## ADUC = Active Directory - Users and Computers
# This script will create a shared mailbox on-prem and automatically sync it to EXO using AAD-Sync
# This is useful if your company is using an hybrid enviorment
# The script also works fine with Active Roles
# Feedback is welcome and encouraged

# Connect to Exchange on-premises
$ExchangeServer = "Enter name of your exchange server"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$ExchangeServer/powershell -Authentication Kerberos -Credential (Get-Credential)
Import-PSSession $Session -DisableNameChecking -AllowClobber -ErrorAction Stop

# Set the shared mailbox properties
$SharedMailboxName = Read-Host "Enter the name of the shared mailbox"
$SharedMailboxAlias = Read-Host "Enter the alias of the shared mailbox" # Can not contain spaces or Nordic letters
$SharedMailboxUPN = Read-Host "Enter the mailadress of the shared mailbox"
$SharedMailboxRemoteRoutingAddress = "$SharedMailboxAlias@contoso.mail.onmicrosoft.com"
$SharedMailboxOrganizationalUnit = "Enter AD path for storing"

$SharedMailbox = @{
    Name = $SharedMailboxName
    Alias = $SharedMailboxAlias
    UserPrincipalName = $SharedMailboxUPN
    RemoteRoutingAddress = $SharedMailboxRemoteRoutingAddress
    PrimarySmtpAddress = $SharedMailboxUPN
    Shared = $true
    OnPremisesOrganizationalUnit = $SharedMailboxOrganizationalUnit
}

# Create the shared mailbox on-premises
New-RemoteMailbox @SharedMailbox | fl Name, UserPrincipalName, RemoteRoutingAddress

# Clean up session - Disconnect from Exchange on-prem
Remove-PSSession $Session


##Disclaimer##
# Please test scripts found online in a test setting before taking it to production
# For any questions you might have, feel free to contact me

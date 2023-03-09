
# Connect to the on-premise Exchange Server
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm:$false
$ExchangeServer = "EXCSRV004.falkadm.se"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$ExchangeServer/powershell -Authentication Kerberos -Credential (Get-Credential)
Import-PSSession $Session -DisableNameChecking -AllowClobber -ErrorAction Stop

# Define AD-Group details
$GroupName = Read-Host -Prompt "Enter the name of the security group starting with Equipment_"
$GroupDisplayName = Read-Host -Prompt "Enter the display name of the security group"
$GroupEmailAddress = Read-Host -Prompt "Enter the email address of the security group"

# Define the room details
$OnPremiseOrganizationalUnit = "OU=Users,OU=Resources,OU=Data,DC=falkadm,DC=se"
$EquipmentName = Read-Host -Prompt "Enter name for equipment"
$EquipmentAlias = Read-Host -Prompt "Enter alias for equipment" # Can't contain nordic letters or spaces
$EquipmentEmailAddress = Read-Host -Prompt "Enter email address for equipment" # e.g. awesometest@falkenberg.se
$RemoteRoutingAddress = "$EquipmentAlias@falkenbergskommun.mail.onmicrosoft.com"

# Create the Equipment
$RemoteMailboxProperties = @{
    Name = $EquipmentName
    DisplayName = $EquipmentName
    Alias = $EquipmentAlias
    UserPrincipalName = $EquipmentEmailAddress
    RemoteRoutingAddress = $RemoteRoutingAddress
    Equipment = $true
    OnPremisesOrganizationalUnit = $OnPremiseOrganizationalUnit
}

New-RemoteMailbox @RemoteMailboxProperties | fl Name, WhenCreated, UserPrincipalName -ErrorAction Stop
Set-RemoteMailbox $GroupEmailAddress -EmailAddresses $EquipmentEmailAddress -EmailAddressPolicyEnabled:$false

# Create AD-Group (Mail-Enabled for access rights)
$GroupProperties = @{
    Name = $GroupName
    DisplayName = $GroupDisplayName
    GroupCategory = 'Security'
    GroupScope = 'Universal'
    Path = "OU=Generella,OU=Groups,OU=Resources,OU=Data,DC=falkadm,DC=se"
    SamAccountName = $GroupName
}

New-ADGroup @GroupProperties -PassThru
Set-ADGroup $GroupName -Add  @{'proxyAddresses'="SMTP:$groupEmailAddress"}

# Clean up the session
Remove-PSSession $Session
Write-Host "Removed Exchange Session"

# Run AD-sync on APPSRV103 after script is completed for faster synk
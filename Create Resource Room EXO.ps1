
# Connect to the on-premise Exchange Server
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm:$false
$ExchangeServer = "Enter the name of your on-premise exchange server"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$ExchangeServer/powershell -Authentication Kerberos -Credential (Get-Credential)
Import-PSSession $Session -DisableNameChecking -AllowClobber -ErrorAction Stop

# Define AD-Group details
$GroupName = Read-Host -Prompt "Enter the name of the security group starting with Room_"
$GroupDisplayName = Read-Host -Prompt "Enter the display name of the security group"
$GroupEmailAddress = Read-Host -Prompt "Enter the email address of the security group"

# Define the room details
$OnPremiseOrganizationalUnit = "Enter AD path for storing"
$RoomName = Read-Host -Prompt "Enter name for room"
$RoomEmailAddress = Read-Host -Prompt "Enter email address for room" # e.g. awesometest@contoso.se
$RoomAlias = Read-Host -Prompt "Enter Alias for room" # Can't contain nordic letters or spaces
$RemoteRoutingAddress = "$RoomAlias@contoso.mail.onmicrosoft.com" 

# Create the room
$RemoteMailboxProperties = @{
    Name = $RoomName
    DisplayName = $RoomName
    Alias = $RoomAlias
    UserPrincipalName = $RoomEmailAddress
    RemoteRoutingAddress = $RemoteRoutingAddress
    Room = $true
    OnPremisesOrganizationalUnit = $OnPremiseOrganizationalUnit
}

New-RemoteMailbox @RemoteMailboxProperties | fl Name, WhenCreated, UserPrincipalName -ErrorAction Stop
Set-RemoteMailbox $GroupEmailAddress -EmailAddresses $RoomEmailAddress -EmailAddressPolicyEnabled:$false

# Create AD-Group (Mail-Enabled for access rights)
$GroupProperties = @{
    Name = $GroupName
    DisplayName = $GroupDisplayName
    GroupCategory = 'Security'
    GroupScope = 'Universal'
    Path = "Enter AD path for storing"
    SamAccountName = $GroupName
}

New-ADGroup @GroupProperties -PassThru
Set-ADGroup $GroupName -Add  @{'proxyAddresses'="SMTP:$groupEmailAddress"}

# Clean up the session
Remove-PSSession $Session
Write-Host "Removed Exchange Session"

# Run AD-sync on APPSRV103 after script is completed for faster synk



$Name = Read-Host -Prompt "Enter name for dist-list, start with @"
$Type = "Distribution"
$ManagedBy = Read-Host -Prompt "Enter name manager"
$PrimarySmtpAddress = Read-Host -Prompt "Enter primary address, e.g Awesometest@contoso.com"
$DistGroup = $Name
    
# If a group with this name already exists the script will stop. If the script stops, please doublecheck your AD for any unexpected error group.
 
 # Exchange connect
 $ExchangeServer = "Enter name of your exchange server"
 $Credentials = (Get-Credential)
 $ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$ExchangeServer/PowerShell/ -Authentication Kerberos -Credential $Credentials    
 Import-PSSession $ExchangeSession -DisableNameChecking -AllowClobber -ErrorAction Stop
 Write-Host "Imported Exchange Session"


 try {
    $NewDistGroup = @{
        Name = $Name
        Type = $Type
        ManagedBy = $ManagedBy
        PrimarySmtpAddress = $PrimarySmtpAddress
        }
}
finally {
    Write-Host 'Distribution group processing...'
}
New-DistributionGroup @NewDistGroup -ErrorAction stop | fl Name, email
Write-Host "Group created"

# Only if your organization is using Active Roles, if you're using regular ADUC, scip this.
# Modifies ARS QAD Attribute to allow managers to add and remove members
Set-QADObject $DistGroup -ObjectAttributes @{edsaManagerCanUpdateMembershipList = $true}

# Clean up
Remove-PSSession $ExchangeSession -Confirm:$false
Write-Host "Removed Exchange session"



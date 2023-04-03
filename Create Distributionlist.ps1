## EXO = Exchange Online
# This script will create a new distribution group on you on-prem server and make it available in EXO automatically


$Name = Read-Host -Prompt "Enter name for distribution group, start with @"
$Type = "Distribution"
$ManagedBy = Read-Host -Prompt "Enter username for manager"
$PrimarySmtpAddress = Read-Host -Prompt "Enter primary address, e.g Awesometest@contoso.com"
$DistGroup = $Name
 
function ConnectEXO {
    # Exchange connect
    $ExchangeServer = "Enter name of your exchange server"
    $Credentials = (Get-Credential)
    $ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$ExchangeServer/PowerShell/ -Authentication Kerberos -Credential $Credentials    
    Import-PSSession $ExchangeSession -DisableNameChecking -AllowClobber -ErrorAction Stop
    Write-Host "Imported Exchange Session"
    
}


function CreateDistGroup {
    # If a group with this name already exists the script will stop. If the script stops, please doublecheck your AD for any unexpected error group
    try {
        $NewDistGroup = @{
            Name               = $Name
            Type               = $Type
            ManagedBy          = $ManagedBy
            PrimarySmtpAddress = $PrimarySmtpAddress
        }
    }
    finally {
        Write-Host 'Distribution group processing...'
    }
    New-DistributionGroup @NewDistGroup -ErrorAction stop | fl Name, email
    Write-Host "Group created"

    # Only if your organization is using Active Roles, if you're using regular ADUC, scip this
    # Modifies ARS QAD Attribute to allow managers to add and remove members
    Set-QADObject $DistGroup -ObjectAttributes @{edsaManagerCanUpdateMembershipList = $true }
}

try {
    ConnectEXO
    CreateDistGroup
}
catch {
    throw $_
}


# Clean up
Remove-PSSession $ExchangeSession -Confirm:$false
Write-Host "Removed Exchange session"


##Disclaimer##
# Please test scripts found online in a test setting before taking it to production
# For any questions you might have, feel free to contact me


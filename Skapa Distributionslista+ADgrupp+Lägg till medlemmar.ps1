
##This script creates one(1) distribution list(Not M365), 
##creates a corresponding ADUC group and populates both groups with members defined with .csv.
    
##Connect to ExchangeOnline before executing script
##If you have an On-Premise enviorment, please use Exchange Management Shell on the server.

BeforeAll{Connect-ExchangeOnline}

                                                   ##Import correct .csv fil
$Users = Import-Csv -Path 'Enter Path to .csv here' -Header samAccountName
$ADGroup = '@Test5678'

    ##Please change -Name, -PrimarySmtpAddress and -ManagedBy
    ##!!!If a group with this name already exists the script will stop!!!
try {
$NewDistGroup = @{
        Name = "@Test"
        Type = "Distribution"
        ManagedBy = "CoolTestManager"
        PrimarySmtpAddress = "coolTestaddress@contoso.com"
        }
New-DistributionGroup @NewDistGroup -ErrorAction stop        
        }
catch {
            Write-Host 'Check error message'
} 


##Change the following to your liking in regards to name standard, Owner and OU
$NewADGroup = @{
Name = "@Test5678"
GroupCategory = "Distribution"
GroupScope = "Global"
DisplayName = "@Test5678"
ManagedBy = "victest"
Path = "OU=Distribution Groups,OU=Groups,OU=Resources,OU=Data,DC=falkadm,DC=se"
Description = "Test5678"
}
New-ADGroup @NewADGroup

foreach($samAccountName in $Users) {

    Add-ADGroupMember -Identity $ADGroup -Members $samAccountName.samAccountName
    ##Modifies ARS QAD Attribut to allow owner to add/remove members
    Set-QADObject $ADGroup -ObjectAttributes @{edsaManagerCanUpdateMembershipList = $true }
}
{
   # Add-DistributionGroupMember -Identity $ADGroup -Member $samAccountName.samAccountName
}


##Please be careful with scripts you didn't write yourself. Always try outside prod-enviorment before going sharp. 
##Use scripts found online at your own discretion.
##Author is not responsible for any error caused by altering the script.

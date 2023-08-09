#Assign access rights to resource groups
##DRAFT##

#Following the change Microsoft made to the Exchange administration GUI in august 2023
#This script allows you to assign rights to resource groups without having to first give yourself access to the resource
#All you need is Exchange Administrator role and connect to exchange online using Connect-ExchangeOnline

$Resource = Read-Host "Enter name of room or equipment"
$SecurityGroup = Read-Host "Enter name of AD security group"


$CalProp = @{
    AutomateProcessing = 'AutoAccept'

    AllBookInPolicy = $false
    AllRequestInPolicy = $false
    AllRequestOutOfPolicy = $false
    ResourceDelegates = $null

    BookInPolicy = $SecurityGroup

    AddAdditionalResponse = $true
    AdditionalResponse = "You do not have correct Permissions to book this resource, please contact IT-Service"

}


Set-CalendarProcessing -Identity $Resource @CalProp
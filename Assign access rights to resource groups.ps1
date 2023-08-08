#Assign access rights to resource groups
##DRAFT##


$Resource = "Test-Room"
#Users
$Users = "Access Group"


$CalProp = @{
    AutomateProcessing = 'AutoAccept'

    AllBookInPolicy = $false
    AllRequestInPolicy = $false
    AllRequestOutOfPolicy = $false
    ResourceDelegates = $null

    BookInPolicy = $Users

    AddAdditionalResponse = $true
    AdditionalResponse = "Test message"

}


Set-CalendarProcessing -Identity $Resource @CalProp
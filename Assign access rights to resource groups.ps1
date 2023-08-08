#Assign access rights to resource groups
##DRAFT##


$Resource = "miljon@falkenberg.se"
#Users
$Users = "Room_Stadshus"


$CalProp = @{
    AutomateProcessing = 'AutoAccept'

    AllBookInPolicy = $false
    AllRequestInPolicy = $false
    AllRequestOutOfPolicy = $false
    ResourceDelegates = $null

    BookInPolicy = $Users

    AddAdditionalResponse = $true
    AdditionalResponse = "Endast avsedd för stadshuset"

}


Set-CalendarProcessing -Identity $Resource @CalProp
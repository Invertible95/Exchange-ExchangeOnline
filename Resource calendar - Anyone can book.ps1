# Script Description:
# This PowerShell script sets calendar processing properties for a specified room or equipment resource.
# The script prompts the user to enter the name of the room or equipment, and then applies the specified
# calendar processing settings using the Set-CalendarProcessing cmdlet.

# Notes:
# - The 'AutomateProcessing' property is set to 'AutoAccept' to enable automatic processing of meeting requests.
# - 'AllBookInPolicy' is set to $true to allow all meeting requests to be automatically accepted.
# - 'AllRequestInPolicy' and 'AllRequestOutOfPolicy' are set to $false to restrict the types of requests processed.
# - 'ResourceDelegates', 'BookInPolicy', 'RequestInPolicy', and 'RequestOutOfPolicy' are set to $null initially.

$Resource = Read-Host "Enter name of room or equipment"

$CalProp = @{
    AutomateProcessing    = 'AutoAccept'
    AllBookInPolicy       = $true
    AllRequestInPolicy    = $false
    AllRequestOutOfPolicy = $false
    ResourceDelegates     = $null
    BookInPolicy          = $null
    RequestInPolicy       = $null
    RequestOutOfPolicy    = $null
}

Set-CalendarProcessing $Resource @CalProp

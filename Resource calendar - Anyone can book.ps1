

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
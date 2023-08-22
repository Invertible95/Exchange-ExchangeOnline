# Assign access rights to resource groups
###IN PROGRESS###

# Following the change Microsoft made to the Exchange administration GUI in august 2023
# This script allows you to assign rights to resource groups without having to first give yourself access to the resource
# All you need is Exchange Administrator role and connect to exchange online using Connect-ExchangeOnline

# To first check if there already is a group assigned run below function and then type Check-AlreadyAssignedGroup in your console
# If a group is already assigned (Mail-enabled security group), you can add the person to the correct AD-group

# Variables
$Resource = Read-Host "Enter name of room or equipment"
$SecurityGroup = Read-Host "Enter name of AD security group"

function Check-AlreadyAssignedGroup {
    $Mailbox = $Resource
    $CalendarFolder = $Mailbox
    $CalendarFolder += ':\'
    $CalendarFolder += [string](Get-mailboxfolderstatistics $Mailbox -folderscope calendar).Name
    Get-MailboxFolderPermission -Identity $CalendarFolder
}
Check-AlreadyAssignedGroup

# Settings
$CalProp = @{
    AutomateProcessing    = 'AutoAccept'

    AllBookInPolicy       = $false
    AllRequestInPolicy    = $false
    AllRequestOutOfPolicy = $false
    RequestInPolicy       = $null
    RequestOutOfPolicy    = $null
    ResourceDelegates     = $null

    BookInPolicy          = $SecurityGroup

    AddAdditionalResponse = $true
    AdditionalResponse    = "You do not have the neccessary permissions to book this resource, please contact your IT department"

}

# Set access
Set-CalendarProcessing -Identity $Resource @CalProp
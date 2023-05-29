# Find mailboxes based on RecipientTypeDetails (e.g Room or User etc.)
# Can also add the -and operator if you want to filter even further down

$EPath = Read-Host "Enter path for saving .csv file" # e.g C:\Users\Download\file.csv
Get-EXOMailbox -resultsize Unlimited -Filter "(RecipientTypeDetails -eq 'RoomMailbox, EquipmentMailbox') -and (UserPrincipalName -like '*vivab.info')" `
| Select Name, UserPrincipalName, RecipientTypeDetails | Export-Csv -Path $EPath -Delimiter ";" -Encoding utf8
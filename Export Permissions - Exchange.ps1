# Export Permissions
Connect-ExchangeOnline -Credential (Get-Credential)
$Mailbox = "Byt ut detta mot namnet på lådan"
$EPath = "Byt ut detta mot sökväg till dit du vill lägga excelfilen + Vad den ska heta" #C:\users\downloads\exceltest.csv

Get-EXOMailboxPermission -Identity $Mailbox | Select Identity, User, AccessRights `
| Export-Csv -Path $EPath -Delimiter ";" -Encoding utf8
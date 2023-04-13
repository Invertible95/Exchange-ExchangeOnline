
##Set CalenderProcessing collection

# "First alternative, These users can submit a request for owner approval if the resource is available."
Set-CalendarProcessing -Identity "Resource UPN" -AllRequestInPolicy $true/$false

# "Second alternative, These users can submit a request for owner approval if the resource is available."
# Removes list of Users for approval and auto accept if resource is available and not in conflict with policies 
Set-CalendarProcessing -Identity "Resource UPN" -RequestInPolicy $true/$false


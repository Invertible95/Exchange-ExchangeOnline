
##Set & Get CalenderProcessing collection

# For seeing policies and processing use below and see switch-parameter >>> ## | fl* for all | fl *policy*, to specify 
Get-CalenderProcessing - Identity "Resource Name" | fl *

# "First alternative, These users can submit a request for owner approval if the resource is available."
Set-CalendarProcessing -Identity "Resource UPN" -AllRequestInPolicy $true/$false

# "Second alternative, These users can submit a request for owner approval if the resource is available."
# Removes list of Users for approval and auto accept if resource is available and not in conflict with policies 
Set-CalendarProcessing -Identity "Resource UPN" -RequestInPolicy $true/$false

# To make calendar show who booked a timeslot and not only busy/free
Set-CalendarProcessing -Identity "Resource Name" -AddOrganizerToSubject:$true


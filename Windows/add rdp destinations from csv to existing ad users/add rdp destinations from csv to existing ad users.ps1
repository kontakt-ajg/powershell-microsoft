# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from Users.csv in the $Users variable
#CSV: FirstName,LastName,Username,Password,Computers
#NO DOUBLE QUOATES FOR IPs etc.
$users = Import-Csv "C:\my\path\add rdp destinations from csv to existing ad users.csv"
########EXAMPLE#############
#FirstName,LastName,Username,Password,Computers
#John,Smith,smithj,mypass123,"1.1.1.1,2.2.2.2"
#Tom,Tim,timt,yourpass123,"1.1.1.2,2.2.2.3"

# Define UPN (AD domain)
$UPN = "my.lab"

# Loop through each row containing user details in the CSV file
foreach ($user in $users) {

    #Read user data from each field in each row and assign the data to a variable as below
    $username = $User.Username
	$computers = $User.Computers -split ","
	
    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # If user does exist, add the new RDP entry
        Set-ADUser `
            -Identity $username `
			-Add @{'url'=@($computers)}

		# If RDP entry is added, show a message
		Write-Host "New RDP entries added to user account $username ." -ForegroundColor Cyan	
    }
    else {

        # User does not exist then give a warning
		Write-Warning "A user account with username $username does not exist in Active Directory."
    }
}

Read-Host -Prompt "Press Enter to exit"
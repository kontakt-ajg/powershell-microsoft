# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from Users.csv in the $Users variable
#CSV: FirstName,LastName,Username,Password,Computers
#NO DOUBLE QUOATES FOR IPs etc.
$users = Import-Csv "C:\temp\change rdp of existing AD users with rdp destinations from csv.csv"
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
        
        # If user does exist, replace RDP entries
        Set-ADUser `
            -Identity $username `
			-Replace @{'url'=@($computers)}

		# If RDP entries are replaced, show a message
		Write-Host "Replaced RDP entries of user account $username ." -ForegroundColor Cyan	
    }
    else {

        # User does not exist then give a warning
		Write-Warning "A user account with username $username does not exist in Active Directory."
    }
}

Read-Host -Prompt "Press Enter to exit"
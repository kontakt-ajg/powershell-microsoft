# Import active directory module for running AD cmdlets
Import-Module ActiveDirectory
  
# Store the data from Users.csv in the $Users variable
#CSV: FirstName,LastName,Username,Password,Computers
#NO DOUBLE QUOATES FOR IPs etc.
$users = Import-Csv "C:\my\path\create new AD users from csv and add rdp destination.csv"
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
    $password = $User.Password
    $firstname = $User.FirstName
    $lastname = $User.LastName
	$computers = $User.Computers -split ","
	
    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        
        # If user does exist, give a warning
        Write-Warning "A user account with username $username already exists in Active Directory."
    }
    else {

        # User does not exist then proceed to create the new user account
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UPN" `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) `
			-OtherAttributes @{'url'=@($computers)}

        # If user is created, show message.
        Write-Host "The user account $username is created." -ForegroundColor Cyan
    }
}

Read-Host -Prompt "Press Enter to exit"
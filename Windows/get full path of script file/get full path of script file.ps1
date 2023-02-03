#get full path of script file
$myPS1 = (Get-Item $PSCommandPath).FullName
echo $myPS1
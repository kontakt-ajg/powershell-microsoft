#get full path of scripts csv file
$myCSV = (Get-Item $PSCommandPath ).DirectoryName+"\"+(Get-Item $PSCommandPath ).BaseName+".csv"
echo $myCSV
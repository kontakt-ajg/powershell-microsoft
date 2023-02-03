$ExcelObj = New-Object -comobject Excel.Application
$ExcelWorkBook = $ExcelObj.Workbooks.Open("C:\Users\myuser\myworkbook.xlsx")
$ExcelWorkSheet = $ExcelWorkBook.Sheets.Item("myworksheet")
$StartCellNumber = 43
$RowsBetweenValues = 22

$csv = "C:\Users\myuser\myworkbook.csv"

Import-Csv $csv | Foreach-Object { 
    echo $_.name
    echo $StartCellNumber
    $ExcelWorkSheet.Columns.Item(11).Rows.Item($StartCellNumber) = $_.name
    $StartCellNumber = $StartCellNumber + $RowsBetweenValues
}

$ExcelWorkBook.Save()
$ExcelWorkBook.close($true)
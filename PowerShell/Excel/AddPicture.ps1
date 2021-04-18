# Excel Constants

# MsoTriState
Set-Variable msoFalse 0 -Option Constant -ErrorAction SilentlyContinue
Set-Variable msoTrue 1 -Option Constant -ErrorAction SilentlyContinue

# own Constants
# cell width and height in points
Set-Variable cellWidth 48 -Option Constant -ErrorAction SilentlyContinue
Set-Variable cellHeight 15 -Option Constant -ErrorAction SilentlyContinue

$xl = New-Object -ComObject Excel.Application -Property @{
    Visible = $true
    DisplayAlerts = $false
}

$wb = $xl.WorkBooks.Add()
$sh = $wb.Sheets.Item('Sheet1')

# arguments to insert the image through the Shapes.AddPicture Method
$imgPath = 'C:\Users\webbleen\Desktop\DISPLAY1_2021-04-18-00-54-02.jpg'

$LinkToFile = $msoFalse
$SaveWithDocument = $msoTrue

$Left = $cellWidth * 2
$Top = $cellHeight * 2
$Width = $cellWidth * 2
$Height = $cellHeight * 4

# add image to the Sheet
$img = $sh.Shapes.AddPicture($imgPath, $LinkToFile, $SaveWithDocument, $Left, $Top, $Width, $Height)
$xl.Speech.Speak('Add an image to the Sheet through the Add Picture Method.')

$excelName = 'C:\Users\webbleen\Desktop\DISPLAY1_2021-04-18-00-54-02.xlsx'
$wb.SaveAS($excelName)

# close without saving the workbook
$wb.Close($false)
$xl.Quit()
Remove-ComObject
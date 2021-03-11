Read-Host "初期状態"

$app = New-Object -ComObject Excel.Application
$books = $app.Workbooks
$book = $books.Open("$PWD\test.xlsx")
$sheets = $book.Sheets
$sheet = $sheets["Sheet1"]
$cells = $sheet.Cells
$cell = $cells[1,1]
Write-Host $cell.Text
#Write-Host $cell.Value # Variant Value (Variant)が表示される
#$cell.Value = "TEST"
#Write-Host $cell.Text

$book.Close()
Read-Host "①起動済み"

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($cell) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($cells) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheets) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($book) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($books) | Out-Null
Read-Host "②ReleaseComObject"

$cell = $null
Remove-Variable cell -ErrorAction SilentlyContinue
$cells = $null
Remove-Variable cells -ErrorAction SilentlyContinue
$sheet = $null
Remove-Variable sheet -ErrorAction SilentlyContinue
$sheets = $null
Remove-Variable sheets -ErrorAction SilentlyContinue
$book = $null
Remove-Variable book -ErrorAction SilentlyContinue
$books = $null
Remove-Variable books -ErrorAction SilentlyContinue


[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
[System.GC]::Collect()

$app.Quit();


[System.Runtime.Interopservices.Marshal]::ReleaseComObject($app) | Out-Null
$app = $null
Remove-Variable app -ErrorAction SilentlyContinue

[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
[System.GC]::Collect()
Read-Host "すべて終了"
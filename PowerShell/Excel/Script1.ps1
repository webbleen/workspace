# Test.xlsxを新規作成する
try {
    $app = New-Object -ComObject Excel.Application    # Excel起動
    $app.Visible = $false                             # 表示する・しない
    $book = $app.Workbooks.Add()

    $sheet = $book.Sheets(1)
    $sheet.Cells.Item(1, 1) = 100

    $book.SaveAS("${PWD}\Test.xlsx")
    $book.Close()

    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($book) | Out-Null

    $sheet = $null
    Remove-Variable sheet -ErrorAction SilentlyContinue
    $book = $null
    Remove-Variable book -ErrorAction SilentlyContinue
}
finally {
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    [System.GC]::Collect()

    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($app) | Out-Null
    $app = $null
    Remove-Variable app -ErrorAction SilentlyContinue

    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    [System.GC]::Collect()
}
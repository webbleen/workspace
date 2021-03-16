# Test.xlsxを新規作成する
try {
    $app = New-Object -ComObject Excel.Application    # Excel起動
    $app.Visible = $false                             # 表示する・しない
    $book = $app.Workbooks.Open([string](Resolve-Path (Get-ChildItem "Sample.xlsm")))                      # ブックを開く

    # マクロ実行
    $app.Run("Increment")
    # $app.Run("Reset")

    $book.Save()
    $book.Close()

    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($book) | Out-Null
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
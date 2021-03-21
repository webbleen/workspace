<# 
filename:73JUT
author:webbleen
#>

[CmdletBinding()]
param()

class CCaseNo {
    [Int] $LargeNo
    [Int] $MiddleNo
    [Int] $SmallNo

    CCaseNo() {
        $this.LargeNo, $this.MiddleNo, $this.SmallNo = 0
    }

    CCaseNo($LargeNo, $MiddleNo, $SmallNo) {
        $this.LargeNo = $LargeNo
        $this.MiddleNo = $MiddleNo
        $this.SmallNo = $SmallNo
    }

    [String]ToString() {
        return ($this.LargeNo,$this.MiddleNo,$this.SmallNo) -join '-'
    }

    FromString($caseNoStr) {
        $infos = $caseNoStr -split '-'
        if ($null -ne $infos[0]) {
            $this.LargeNo = $infos[0].Trim()
        } else {
            $this.LargeNo = 0
        }
        if ($null -ne $infos[1]) {
            $this.MiddleNo = $infos[1].Trim()
        } else {
            $this.MiddleNo = 0
        }
        if ($null -ne $infos[2]) {
            $this.SmallNo = $infos[2].Trim()
        } else {
            $this.SmallNo = 0
        }
    }

    [bool]Check() {
        if (($this.LargeNo -eq 0) -or ($this.MiddleNo -eq 0) -or ($this.SmallNo -eq 0)) {
            return $false
        }
        return $true
    }
}

# $73J_CCaseNoA = New-Object CCaseNo
# $73J_CCaseNoA.Check()
# $73J_CCaseNoA.FromString("1-1")
# $73J_CCaseNoA.Check()
# $73J_CCaseNoA.FromString("1-1-")
# $73J_CCaseNoA.Check()
# $73J_CCaseNoA.FromString("1-1-3")
# $73J_CCaseNoA.Check()
# $73J_CCaseNoA.ToString()
# 
# $73J_CCaseNoB = New-Object CCaseNo 1,2,3
# $73J_CCaseNoB.Check()
# $73J_CCaseNoB.ToString()

class CDataContainer {
    [String] $_name
    [String] $_type
    [System.Data.DataSet] $_dataSet

    CDataContainer() {
        $this._dataSet = [System.Data.DataSet]::New()
    }
}

class C73JUT {
    $_excel
    [XML]$_config

    [System.Collections.Generic.List[CDataContainer]] $_testData
    [System.Collections.Generic.List[CDataContainer]] $_expectData
    [System.Collections.Generic.List[CDataContainer]] $_rejectData

    C73JUT() {
        $this._config = Get-Content (Get-ChildItem "config.xml").FullName

        $this._excel = New-Object -ComObject Excel.Application    # Excel起動
        $this._excel.Visible = $false                             # 表示する・しない

        $this._testData = [System.Collections.Generic.List[CDataContainer]]::New()
        $this._expectData = [System.Collections.Generic.List[CDataContainer]]::New()
        $this._rejectData = [System.Collections.Generic.List[CDataContainer]]::New()
    }

    [void] Hello() {
        Write-Host "Hello C73JUT"
        Write-Verbose "JobName:$($this._config.ut.jobName)"
    }

    [hashtable] ReadShootNumber() {
        $book = $this._excel.Workbooks.Open([string](Resolve-Path (Get-ChildItem $this._config.ut.shootNumber)))                      # ブックを開く
    
        $sheet = $book.Sheets(1)
        $shootTable = @{}
        for($i=6; $i -le $sheet.UsedRange.Rows.Count; $i++)
        {
            $caseNo = $sheet.Range("E$($i)").Text
            $shootNo = $sheet.Range("F$($i)").Text
            if (($caseNo.Trim() -ne "") -or ($shootNo.Trim() -ne "")) {
                $shootTable[$caseNo] = $shootNo
            }
        }

        $book.Close()
    
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($book) | Out-Null
        $book = $null
        Remove-Variable book -ErrorAction SilentlyContinue
        
        return $shootTable
    }

    [Void] ReadTestData() {
        Write-Host "ReadTestData"
        $book = $this._excel.Workbooks.Open([string](Resolve-Path (Get-ChildItem $this._config.ut.testData)))                      # ブックを開く
        
        $book.Worksheets | ForEach-Object {
            if ($_.Name -contains "テストデータ") {
                
            }
            Write-Host $_.Name
            $startRow = 12
            $startColumn = 4

            $tableName = $_.Range("C$($startRow-4)").Text
            Write-Host $tableName

            # 获取字段名
            $columnNameCell = $_.Cells.Item($startRow-2, $startColumn)
            $index = 0
            $columnNameStr  = ""
            while ($columnNameCell.Text -ne "") {
                $columnNameStr = $columnNameStr + $columnNameCell.Text
                $index++
                $columnNameCell = $_.Cells.Item($startRow-2, $startColumn+$index)
            }
            Write-Host "columnNameStr:$($columnNameStr)"

            # 获取CaseNo
            $caseNumberCell = $_.Range("B$($startRow)")
            $index = 0
            while ($caseNumberCell.Text -ne "") {
                Write-Host $caseNumberCell.Text
                Write-Host "{$($caseNumberCell.MergeArea.Row),$($caseNumberCell.MergeArea.Column),$($caseNumberCell.MergeArea.Rows.Count),$($caseNumberCell.MergeArea.Columns.Count)}"

                $index = $index + $caseNumberCell.MergeArea.Rows.Count
                $caseNumberCell = $_.Range("B$($startRow+$index)")
            }

        }
        
        $book.Close()
    
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($book) | Out-Null
        $book = $null
        Remove-Variable book -ErrorAction SilentlyContinue
    }

    [void] Clear() {
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        [System.GC]::Collect()

        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($this._excel) | Out-Null
        $this._excel = $null
        Remove-Variable excel -ErrorAction SilentlyContinue

        $this._config = $null
        Remove-Variable config -ErrorAction SilentlyContinue

        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        [System.GC]::Collect()
    }

    static [C73JUT] Create() {
        $object = [C73JUT]::New()

        Write-Host "Create"

        return $object
    }

    static [C73JUT] PowerShell() {
        $object = [C73JUT]::New()

        Write-Host "PowerShell"

        return $object
    }
}


Clear-Host

$utObj = New-Object C73JUT
<#
$objects = "Create", "PowerShell"
$currentObject = 1
$utObj = [C73JUT]::($objects[$currentObject]).Invoke()
#>

try {
    $utObj.Hello()
    $shootTable = $utObj.ReadShootNumber()
    # $shootTable | ConvertTo-Json
    $utObj.ReadTestData()
}
catch [Exception] {
    Write-Host $_.Exception.Message
    exit 1
}
finally {
    $utObj.Clear()
    "Finish!"
}


<# 
filename:73JUT
author:webbleen
#>

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

class C73JUT {
    $excel
    [XML]$config

    C73JUT() {
        $this.config = Get-Content (Get-ChildItem "config.xml").FullName

        $this.excel = New-Object -ComObject Excel.Application    # Excel起動
        $this.excel.Visible = $false                             # 表示する・しない
    }

    Hello() {
        Write-Host "Hello C73JUT"
        Write-Host "JobName:$($this.config.ut.jobName)"
    }

    [hashtable]ReadShootNo() {
        Trap {"Trap Error: $($_.Exception.Message)"; Continue}

        $book = $this.excel.Workbooks.Open([string](Resolve-Path (Get-ChildItem $this.config.ut.shootNoName)))                      # ブックを開く
    
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

    Clear() {
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        [System.GC]::Collect()

        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($this.excel) | Out-Null
        $this.excel = $null
        Remove-Variable excel -ErrorAction SilentlyContinue

        $this.config = $null
        Remove-Variable config -ErrorAction SilentlyContinue

        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        [System.GC]::Collect()
    }
}


$utObj = New-Object C73JUT

try {
    $utObj.Hello()
    $shootTable = $utObj.ReadShootNo()
    $shootTable | ConvertTo-Json
}
catch {
    "Error in a Try block." 
}
finally {
    $utObj.Clear()
    "Finish!"
}


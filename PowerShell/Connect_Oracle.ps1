using namespace Oracle.ManagedDataAccess.Client
Add-Type -Path 'Oracle.ManagedDataAccess.dll'

function Using-Object
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [AllowNull()]
        [Object]
        $InputObject,

        [Parameter(Mandatory = $true)]
        [scriptblock]
        $ScriptBlock
    )

    try
    {
        . $ScriptBlock
    }
    finally
    {
        if ($null -ne $InputObject -and $InputObject -is [System.IDisposable])
        {
            $InputObject.Dispose()
        }
    }
}

Using-Object ($conn = New-Object OracleConnection('user id=system;password=oracle;data source=(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.99.102)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))')) {
	$conn.Open()
	Using-Object ($cmd = New-Object OracleCommand('truncate table test_tbl', $conn)) {
		$cmd.ExecuteNonQuery() | Out-Null
	}

	Using-Object ($cmd = New-Object OracleCommand('INSERT INTO test_tbl (user_name, age) VALUES (:userName, :age)', $conn)) {
		$param = New-Object OracleParameter("userName", "明日のジョー")
		$cmd.Parameters.Add( $param ) | Out-Null
		$param = New-Object OracleParameter("age", 17)
		$cmd.Parameters.Add( $param ) | Out-Null
		$cmd.ExecuteNonQuery() | Out-Null
	}

	Using-Object ($cmd = New-Object OracleCommand("SELECT user_name, age FROM test_tbl", $conn)) {
		Using-Object ($reader = $cmd.ExecuteReader()){
		    while ($reader.Read())
		    {
		        Write-Host $reader.GetString(0)  $reader.GetInt32(1).ToString()
		    }
		}
	}
	
	Write-Host "================================================="
	Write-Host "トランザクション（ロールバック）"
	Using-Object ($tran = $conn.BeginTransaction()) {
	    Using-Object ($cmd = New-Object OracleCommand('INSERT INTO test_tbl (user_name, age) VALUES (:userName, :age)', $conn)) {
			$param = New-Object OracleParameter("userName", "丹下さくら")
			$cmd.Parameters.Add( $param ) | Out-Null
			$param = New-Object OracleParameter("age", 43)
			$cmd.Parameters.Add( $param ) | Out-Null
			$cmd.ExecuteNonQuery() | Out-Null
	    }
	    $tran.Rollback()
	}
	Using-Object ($cmd = New-Object OracleCommand("SELECT user_name, age FROM test_tbl", $conn)) {
		Using-Object ($reader = $cmd.ExecuteReader()){
		    while ($reader.Read())
		    {
		        Write-Host $reader.GetString(0)  $reader.GetInt32(1).ToString()
		    }
		}
	}
	Write-Host "================================================="
	Write-Host "トランザクション（コミット）"
	Using-Object ($tran = $conn.BeginTransaction()) {
	    Using-Object ($cmd = New-Object OracleCommand('INSERT INTO test_tbl (user_name, age) VALUES (:userName, :age)', $conn)) {
			$param = New-Object OracleParameter("userName", "丹下さくら")
			$cmd.Parameters.Add( $param ) | Out-Null
			$param = New-Object OracleParameter("age", 43)
			$cmd.Parameters.Add( $param ) | Out-Null
			$cmd.ExecuteNonQuery() | Out-Null
	    }
	    $tran.Commit()
	}
	Using-Object ($cmd = New-Object OracleCommand("SELECT user_name, age FROM test_tbl", $conn)) {
		Using-Object ($reader = $cmd.ExecuteReader()){
		    while ($reader.Read())
		    {
		        Write-Host $reader.GetString(0)  $reader.GetInt32(1).ToString()
		    }
		}
	}
	$conn.Close()
}
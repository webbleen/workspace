using namespace System.Data.SqlClient

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

Using-Object ($conn = New-Object SqlConnection('Data Source=.;Initial Catalog=test;User ID=sa;Password=123456')) {
	$conn.Open()
	Using-Object ($cmd = New-Object SqlCommand('truncate table test_tbl', $conn)) {
		$cmd.ExecuteNonQuery() | Out-Null
	}

	Using-Object ($cmd = New-Object SqlCommand('INSERT INTO test_tbl (user_name, age) VALUES (@user, @age)', $conn)) {
		$cmd.Parameters.AddWithValue("@user", "明日のジョー") | Out-Null
		$cmd.Parameters.AddWithValue("@age", 17) | Out-Null
		$cmd.ExecuteNonQuery() | Out-Null
	}

	Using-Object ($cmd = New-Object SqlCommand("SELECT user_name, age FROM test_tbl", $conn)) {
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
	    Using-Object ($cmd = New-Object SqlCommand("INSERT INTO test_tbl (user_name, age) VALUES (@user, @age)", $conn, $tran)) {
	        $cmd.Parameters.AddWithValue("@user", "丹下さくら") | Out-Null
	        $cmd.Parameters.AddWithValue("@age", 43) | Out-Null
	        $cmd.ExecuteNonQuery() | Out-Null
	    }
	    $tran.Rollback()
	}
	Using-Object ($cmd = New-Object SqlCommand("SELECT user_name, age FROM test_tbl", $conn)) {
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
	    Using-Object ($cmd = New-Object SqlCommand("INSERT INTO test_tbl (user_name, age) VALUES (@user, @age)", $conn, $tran)) {
	        $cmd.Parameters.AddWithValue("@user", "丹下さくら") | Out-Null
	        $cmd.Parameters.AddWithValue("@age", 43) | Out-Null
	        $cmd.ExecuteNonQuery() | Out-Null
	    }
	    $tran.Commit()
	}
	Using-Object ($cmd = New-Object SqlCommand("SELECT user_name, age FROM test_tbl", $conn)) {
		Using-Object ($reader = $cmd.ExecuteReader()){
		    while ($reader.Read())
		    {
		        Write-Host $reader.GetString(0)  $reader.GetInt32(1).ToString()
		    }
		}
	}

	Write-Host "================================================="
	Write-Host "ストアド"
	Using-Object ($cmd = New-Object SqlCommand('EXEC test_sp @from, @to', $conn)) {
		$cmd.Parameters.AddWithValue("@from", 10) | Out-Null
		$cmd.Parameters.AddWithValue("@to", 19) | Out-Null
		$cmd.ExecuteNonQuery() | Out-Null
	}

	Using-Object ($cmd = New-Object SqlCommand("SELECT user_name, age FROM test_tbl", $conn)) {
		Using-Object ($reader = $cmd.ExecuteReader()){
		    while ($reader.Read())
		    {
		        Write-Host $reader.GetString(0)  $reader.GetInt32(1).ToString()
		    }
		}
	}
	$conn.Close()
}
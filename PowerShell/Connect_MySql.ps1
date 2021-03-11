using namespace MySql.Data.MySqlClient
Add-Type -Path "MySql.Data.dll"

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


Using-Object ($conn = New-Object MySqlConnection('server=127.0.0.1;port=3306;user=webbleen;password=123456;database=w_osadmin')) {
    $conn.Open()
    Using-Object ($cmd = New-Object MySqlCommand("select version() as version,count(*) as count", $conn)) {
		Using-Object ($reader = $cmd.ExecuteReader()){
		    while ($reader.Read())
		    {
		        Write-Host $reader.GetString(0)  $reader.GetInt32(1).ToString()
		    }
		}
	}

	$conn.Close()
}


# Demonstrating the usage of Using-Object
 
Using-Object ($streamWriter = New-Object System.IO.StreamWriter("$pwd\newfile.txt")) {
    $streamWriter.WriteLine('Line written inside Using block.')
}
 
# The second call to $streamWriter.WriteLine() produces an error, because
# the stream is already closed.
 
#$streamWriter.WriteLine('Line written outside Using block.')
 
Get-Content .\newfile.txt
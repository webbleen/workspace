#Script to gather geolocation data provided by colsw from StackOverflow @ https://stackoverflow.com/a/46287884
Add-Type -AssemblyName System.Device #Required to access System.Device.Location namespace
$GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher #Create the required object
$GeoWatcher.Start() #Begin resolving current locaton

while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {
    Start-Sleep -Milliseconds 100 #Wait for discovery.
}  

if ($GeoWatcher.Permission -eq 'Denied'){
    [System.Windows.MessageBox]::Show("Access Denied for Location Information", "Error", "Ok", "Error")
    break
} else {
    $LatLong = $GeoWatcher.Position.Location | Select Latitude,Longitude #Select the relevent results.
    }

try {
    #Store latitude and longitude to variable
    $Latitude=$LatLong.Latitude
    $Longitude=$LatLong.Longitude

    #Retrieve weather information based on current location
    $uri="https://api.weather.gov/points/$Latitude,$Longitude"
    $WeatherJSON=Invoke-RestMethod -Method GET -Uri $uri 
        
    #Retrieve forecast information
    $uri=$WeatherJSON.properties.forecast
    $script:ForecastJson=Invoke-RestMethod -Method GET -Uri $uri

} Catch {
    [System.Windows.MessageBox]::Show("Error accessing Weather.gov`r`n`r`nMore Details: $_", "Error", "Ok", "Error")
    break
}

$weatherdata = @{}
for ($i=1; $i -le 5; $i++) {
    $CurrentPeriod = $ForecastJson.properties.periods | Where-Object {$_.number -eq $i}
    $weatherdata["$i"]=@{}

    # Used information from the following links to write the images to memory
    # https://social.technet.microsoft.com/Forums/windowsserver/en-US/b11d845c-ff6a-4b44-adec-47d56b40fa1e/get-base64-encoded-string-of-a-web-image?forum=winserverpowershell
    # https://www.alkanesolutions.co.uk/2013/04/19/embedding-base64-image-strings-inside-a-powershell-application/
    $icon_uri = $CurrentPeriod.icon
    [byte[]]$icon_b = (Invoke-WebRequest -Method GET -Uri $icon_uri -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer)).Content
    $ms = New-Object IO.MemoryStream($icon_b, 0, $icon_b.Length)
    $ms.Write($icon_b, 0, $icon_b.Length);
    $icon_data = [System.Drawing.Image]::FromStream($ms, $true)

    $weatherdata["$i"]["name"]=$CurrentPeriod.name
    $weatherdata["$i"]["temp"]=[string]$CurrentPeriod.temperature + [char]0x00B0 + $CurrentPeriod.temperatureUnit
    $weatherdata["$i"]["wind"]=[string]$CurrentPeriod.windSpeed + " " + $CurrentPeriod.windDirection
    $weatherdata["$i"]["icon"]=$icon_data
    $weatherdata["$i"]["forecast"]=$CurrentPeriod.shortForecast
}
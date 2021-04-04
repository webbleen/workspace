<# This form was created using POSHGUI.com  a free online gui designer for PowerShell #>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework

[System.Windows.Forms.Application]::EnableVisualStyles()

# Run the logic file
. "$PSScriptRoot\logic.ps1"

$Form = New-Object system.Windows.Forms.Form -Property @{
    Text = "Weather"
    TopMost = $true
    MinimumSize = New-Object System.Drawing.Size(600,600)
    Padding = New-Object -TypeName System.Windows.Forms.Padding -ArgumentList (20,20,20,20)
    AutoScroll = $true
}

# Period 1
$Image1 = New-Object system.Windows.Forms.PictureBox -Property @{
    Width = 150
    Height = 150
    Location = New-Object System.Drawing.Point(20,20)
    image = $weatherdata."1"."icon"
    SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::zoom
}

$Time_Label1 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."1"."name"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,35)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
}

$Label1 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Temperature:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,75)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Temp_Label1 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."1"."temp"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,75)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Label2 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Wind:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,100)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Wind_Label1 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."1"."wind"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,100)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Label3 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Forecast:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,125)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Forecast_Label1 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."1"."forecast"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,125)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

# Period 2
$Image2 = New-Object system.Windows.Forms.PictureBox -Property @{
    Width = 150
    Height = 150
    Location = New-Object System.Drawing.Point(20,190)
    image = $weatherdata."2"."icon"
    SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::zoom
}

$Time_Label2 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."2"."name"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,205)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
}

$Label4 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Temperature:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,245)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Temp_Label2 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."2"."temp"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,245)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Label5 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Wind:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,270)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Wind_Label2 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."2"."wind"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,270)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Label6 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Forecast:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,295)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Forecast_Label2 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."2"."forecast"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,295)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

# Period 3
$Image3 = New-Object system.Windows.Forms.PictureBox -Property @{
    Width = 150
    Height = 150
    Location = New-Object System.Drawing.Point(20,360)
    image = $weatherdata."3"."icon"
    SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::zoom
}

$Time_Label3 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."3"."name"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,375)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
}

$Label7 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Temperature:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,415)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Temp_Label3 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."3"."temp"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,415)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Label8 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Wind:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,440)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Wind_Label3 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."3"."wind"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,440)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Label9 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Forecast:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,465)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Forecast_Label3 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."3"."forecast"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,465)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

# Period 4
$Image4 = New-Object system.Windows.Forms.PictureBox -Property @{
    Width = 150
    Height = 150
    Location = New-Object System.Drawing.Point(20,530)
    image = $weatherdata."4"."icon"
    SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::zoom
}

$Time_Label4 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."4"."name"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,545)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
}

$Label10 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Temperature:"
    Autosize = $true
    Location = New-Object System.Drawing.Point(180,585)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Temp_Label4 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."4"."temp"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,585)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Label11 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Wind:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,610)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Wind_Label4 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."4"."wind"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,610)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Label12 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Forecast:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,635)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Forecast_Label4 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."4"."forecast"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,635)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

#Period 5
$Image5 = New-Object system.Windows.Forms.PictureBox -Property @{
    Width = 150
    Height = 150
    Location = New-Object System.Drawing.Point(20,700)
    image = $weatherdata."5"."icon"
    SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::zoom
}

$Time_Label5 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."5"."name"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,715)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
}

$Label13 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Temperature:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,755)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Temp_Label5 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."5"."temp"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,755)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Label14 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Wind:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,780)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Wind_Label5 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."5"."wind"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,780)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Label15 = New-Object system.Windows.Forms.Label -Property @{
    Text = "Forecast:"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(180,805)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Forecast_Label5 = New-Object system.Windows.Forms.Label -Property @{
    Text = $weatherdata."5"."forecast"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(300,805)
    Font = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
}

$Form.controls.AddRange(@(
    $Image1,$Time_Label1,$Label1,$Temp_Label1,$Label2,$Wind_Label1,$Label3,$Forecast_Label1,
    $Image2,$Time_Label2,$Label4,$Temp_Label2,$Label5,$Wind_Label2,$Label6,$Forecast_Label2,
    $Image3,$Time_Label3,$Label7,$Temp_Label3,$Label8,$Wind_Label3,$Label9,$Forecast_Label3,
    $Image4,$Time_Label4,$Label10,$Temp_Label4,$Label11,$Wind_Label4,$Label12,$Forecast_Label4,
    $Image5,$Time_Label5,$Label13,$Temp_Label5,$Label14,$Wind_Label5,$Label15,$Forecast_Label5))

$Form.ShowDialog()
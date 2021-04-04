<#
[string] $location = "C:\log\"
[int] $quality = 100
[switch] $allscreen

Add-Type -AssemblyName System.Windows.Forms
if ($allscreen.IsPresent) {
    $capture = [System.Windows.Forms.Screen]::AllScreens
} else {
    $capture = [System.Windows.Forms.Screen]::PrimaryScreen
}

if ($AllScreen) {
    $capture = [System.Windows.Forms.Screen]::AllScreens
} else {
    $capture = [System.Windows.Forms.Screen]::PrimaryScreen
}

foreach ($C in $capture) {
    $filename = $location + (Get-Date).ToString("yyyy-MM-dd-HH-mm-ss") + ".jpg"
    $bitmap = New-Object System.Drawing.Bitmap($C.Bounds.Width, $C.Bounds.Height)
    $G = [System.Drawing.Graphics]::FromImage($bitmap)
    $G.CopyFromScreen($C.Bounds.Location, (New-Object System.Drawing.Point(0, 0)), $C.Bounds.Size)
    $G.Dispose()

    $encodeParam = [System.Drawing.Imaging.Encoder]::Quality
    $encodeParamSet = New-Object System.Drawing.Imaging.EncoderParameter($encodeParam, $quality)
    $jpgCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $bitmap.Save($filename, $jpgCodec, $encodeParamSet)
}

#>

[Reflection.Assembly]::LoadWithPartialName("System.Drawing")
function screenshot([Drawing.Rectangle]$bounds, $path) {
   $bitmap = New-Object Drawing.Bitmap $bounds.width, $bounds.height
   $graphics = [Drawing.Graphics]::FromImage($bitmap)

   $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.Size)
   $graphics.Dispose()

   $bitmap.Save($path)
   $bitmap.Dispose()
}

$location = "${HOME}\Desktop\"

$capture = [System.Windows.Forms.Screen]::PrimaryScreen

foreach ($C in $capture) {
   $filename = $location + "$($C.DeviceName)_$((Get-Date).ToString("yyyy-MM-dd-HH-mm-ss")).jpg"
   $bounds = [Drawing.Rectangle]::FromLTRB(0, 0, $C.Bounds.Width, $C.Bounds.Height)
   screenshot $bounds $filename
}

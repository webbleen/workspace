Add-Type -AssemblyName System.Windows.Forms

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

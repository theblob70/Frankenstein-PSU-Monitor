# RP Console Repairs - Bench PSU Live OBS Dashboard
# Requires AtomS3 running RP_INA226_Live_Monitor.ino.
# EDIT THIS to match your Windows Device Manager COM port (Rob's was COM10).
$portName = 'COM10'

$ErrorActionPreference = 'Stop'
$outputFile = Join-Path $env:USERPROFILE 'RP_PSU_DISPLAY.txt'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$culture = [System.Globalization.CultureInfo]::InvariantCulture

function Set-Display([string]$message) {
    [System.IO.File]::WriteAllText($outputFile, $message, $utf8)
}
function Format-Reading([string]$raw) {
    $number = [double]::Parse($raw, $culture)
    # Prevent a tiny negative value being shown as -0.000, but retain -0.001 etc.
    if ([math]::Abs($number) -lt 0.0005) { $number = 0.0 }
    return $number.ToString('F3', $culture)
}

Set-Display 'CONNECTING TO ATOMS3...'
$serial = [System.IO.Ports.SerialPort]::new($portName, 115200)
$serial.NewLine = "`n"
$serial.ReadTimeout = 5000
$statusOnExit = 'MONITOR STOPPED'

try {
    $serial.Open()
    Write-Host "RP PSU monitor running on $portName. Keep this window open."
    Start-Sleep -Seconds 2
    while ($true) {
        try {
            $line = $serial.ReadLine().Trim()
        }
        catch [System.TimeoutException] {
            Set-Display "NO LIVE DATA`r`nCHECK $portName"
            continue
        }
        if ($line -match 'V:\s*(-?\d+(?:\.\d+)?)\s+A:\s*(-?\d+(?:\.\d+)?)\s+W:\s*(-?\d+(?:\.\d+)?)') {
            $voltage = Format-Reading $Matches[1]
            $current = Format-Reading $Matches[2]
            $power = Format-Reading $Matches[3]
            $display = "VOLTAGE   $voltage V`r`nCURRENT   $current A`r`nPOWER     $power W"
            Set-Display $display
        }
    }
}
catch {
    $statusOnExit = 'SERIAL CONNECTION ERROR'
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    if ($serial.IsOpen) { $serial.Close() }
    $serial.Dispose()
    Set-Display $statusOnExit
}

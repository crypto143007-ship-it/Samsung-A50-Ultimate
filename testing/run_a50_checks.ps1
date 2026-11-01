[CmdletBinding()]
param(
    [string]$Serial,
    [string]$OutputDirectory = (Join-Path $env:TEMP ("upa50-a50-checks-" + [guid]::NewGuid().ToString("N")))
)

$adbCommand = Get-Command adb -ErrorAction Stop
$adbPath = $adbCommand.Source
$deviceOutput = & $adbPath devices
if ($LASTEXITCODE -ne 0) {
    throw "adb devices failed with exit code $LASTEXITCODE"
}

$authorizedDevices = @(
    $deviceOutput |
        Where-Object { $_ -match '^\S+\s+device$' } |
        ForEach-Object { ($_ -split '\s+')[0] }
)

if ($Serial) {
    if ($authorizedDevices -notcontains $Serial) {
        throw "ADB serial '$Serial' is not connected and authorized."
    }
} elseif ($authorizedDevices.Count -eq 1) {
    $Serial = $authorizedDevices[0]
} else {
    throw "Expected one authorized ADB device; found $($authorizedDevices.Count). Use -Serial to select one."
}

if (Test-Path -LiteralPath $OutputDirectory) {
    throw "Output directory already exists; choose a new path: $OutputDirectory"
}
New-Item -ItemType Directory -Path $OutputDirectory -ErrorAction Stop | Out-Null
$logPath = Join-Path $OutputDirectory "device-diagnostics.txt"
@(
    "UPA50 Galaxy A50 diagnostic collection"
    "Date: $(Get-Date -Format o)"
    "ADB serial: $Serial"
    "Collection only: no flashing, settings changes, or benchmark stress tests."
    ""
) | Set-Content -LiteralPath $logPath -Encoding UTF8

function Invoke-DeviceCheck {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string[]]$Arguments
    )

    Add-Content -LiteralPath $logPath -Value "=== $Name ===" -Encoding UTF8
    Add-Content -LiteralPath $logPath -Value "Command: adb -s $Serial $($Arguments -join ' ')" -Encoding UTF8
    $output = & $adbPath -s $Serial $Arguments 2>&1
    $exitCode = $LASTEXITCODE
    if ($output) {
        $output | Add-Content -LiteralPath $logPath -Encoding UTF8
    }
    Add-Content -LiteralPath $logPath -Value "Exit code: $exitCode" -Encoding UTF8
    Add-Content -LiteralPath $logPath -Value "" -Encoding UTF8
}

$checks = @(
    @{ Name = "Device model"; Arguments = @("shell", "getprop", "ro.product.model") }
    @{ Name = "Device variant"; Arguments = @("shell", "getprop", "ro.product.device") }
    @{ Name = "Android build"; Arguments = @("shell", "getprop", "ro.build.fingerprint") }
    @{ Name = "Boot completion"; Arguments = @("shell", "getprop", "sys.boot_completed") }
    @{ Name = "Kernel release"; Arguments = @("shell", "uname", "-a") }
    @{ Name = "SELinux mode"; Arguments = @("shell", "getenforce") }
    @{ Name = "Root availability (may prompt for authorization)"; Arguments = @("shell", "su", "-c", "id") }
    @{ Name = "Battery state"; Arguments = @("shell", "dumpsys", "battery") }
    @{ Name = "Thermal status"; Arguments = @("shell", "dumpsys", "thermalservice") }
    @{ Name = "Wi-Fi state"; Arguments = @("shell", "dumpsys", "wifi") }
    @{ Name = "Bluetooth state"; Arguments = @("shell", "dumpsys", "bluetooth_manager") }
    @{ Name = "GPS and location state"; Arguments = @("shell", "dumpsys", "location") }
    @{ Name = "Camera service state"; Arguments = @("shell", "dumpsys", "media.camera") }
    @{ Name = "Audio service state"; Arguments = @("shell", "dumpsys", "audio") }
    @{ Name = "Charging status"; Arguments = @("shell", "cat", "/sys/class/power_supply/battery/status") }
    @{ Name = "Thermal zone snapshot"; Arguments = @("shell", "cat", "/sys/class/thermal/thermal_zone0/temp") }
)

foreach ($check in $checks) {
    Invoke-DeviceCheck -Name $check.Name -Arguments $check.Arguments
}

Write-Output "Diagnostic log saved to $logPath"

param(
    [string]$ShimDir = "$env:USERPROFILE\.cargo\bin",
    [string]$IdfPath = "E:\esp\v5.5.4\esp-idf",
    [string]$IdfToolsPath = "C:\Espressif\tools",
    [string]$LowfatHome = "$env:USERPROFILE\.lowfat",
    [string]$LowfatPluginPath = "$env:USERPROFILE\.lowfat\plugins\idf.py\esp-idf-compact"
)

$skillRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$sourceFilter = Join-Path $skillRoot "references\esp-idf-compact.filter.lf"

if (-not (Test-Path -Path $sourceFilter)) {
    throw "Bundled lowfat filter not found: $sourceFilter"
}

$env:LOWFAT_HOME = $LowfatHome
[Environment]::SetEnvironmentVariable("LOWFAT_HOME", $LowfatHome, "User")

New-Item -ItemType Directory -Force -Path $LowfatPluginPath | Out-Null
Copy-Item -Force -Path $sourceFilter -Destination (Join-Path $LowfatPluginPath "filter.lf")
@"
[plugin]
name = "esp-idf-compact"
commands = ["idf.py", "idf.py.cmd"]
"@ | Set-Content -Encoding ASCII -Path (Join-Path $LowfatPluginPath "lowfat.toml")

New-Item -ItemType Directory -Force -Path $ShimDir | Out-Null
$shimPath = Join-Path $ShimDir "idf.py.cmd"
$shortShimPath = Join-Path $ShimDir "idf.cmd"
$shim = @"
@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%USERPROFILE%\.codex\skills\espidf-lowfat\scripts\invoke-idf-raw.ps1" %*
exit /b %ERRORLEVEL%
"@

Set-Content -Encoding ASCII -Path $shimPath -Value $shim
Set-Content -Encoding ASCII -Path $shortShimPath -Value $shim

$shortPluginPath = Join-Path $LowfatHome "plugins\idf\esp-idf-wrapper-compact"
New-Item -ItemType Directory -Force -Path $shortPluginPath | Out-Null
Copy-Item -Force -Path $sourceFilter -Destination (Join-Path $shortPluginPath "filter.lf")
@"
[plugin]
name = "esp-idf-wrapper-compact"
commands = ["idf"]
"@ | Set-Content -Encoding ASCII -Path (Join-Path $shortPluginPath "lowfat.toml")

Write-Host "Installed lowfat plugin: $LowfatPluginPath"
Write-Host "Installed idf.py shim: $shimPath"
Write-Host "Installed lowfat plugin: $shortPluginPath"
Write-Host "Installed idf shim: $shortShimPath"
Write-Host "Set user LOWFAT_HOME: $LowfatHome"
Write-Host "Use: lowfat.exe idf build"

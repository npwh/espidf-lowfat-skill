param(
    [Parameter(Position = 0)]
    [string[]]$IdfArgs,
    [string]$ProjectPath = (Get-Location).Path,
    [ValidateSet("lite", "full", "ultra")]
    [string]$Level = "full",
    [string]$ProfilePath = "C:\Espressif\tools\Microsoft.v5.5.4.PowerShell_profile.ps1",
    [string]$LowfatHome = "$env:USERPROFILE\.lowfat",
    [string]$LowfatPluginPath = "$env:USERPROFILE\.lowfat\plugins\idf.py\esp-idf-compact"
)

if (-not $IdfArgs -or $IdfArgs.Count -eq 0) {
    throw "Pass idf.py arguments, for example: idf-lowfat.ps1 -ProjectPath D:\espidf\github\esp32-blynk build"
}

if (-not (Test-Path -Path $ProfilePath)) {
    throw "ESP-IDF PowerShell profile not found: $ProfilePath"
}

if (-not (Test-Path -Path $ProjectPath)) {
    throw "ESP-IDF project path not found: $ProjectPath"
}

$skillRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$sourceFilter = Join-Path $skillRoot "references\esp-idf-compact.filter.lf"
if (-not (Test-Path -Path $sourceFilter)) {
    throw "Bundled lowfat filter not found: $sourceFilter"
}

New-Item -ItemType Directory -Force -Path $LowfatPluginPath | Out-Null
Copy-Item -Force -Path $sourceFilter -Destination (Join-Path $LowfatPluginPath "filter.lf")
@"
[plugin]
name = "esp-idf-compact"
commands = ["idf.py", "idf.py.cmd"]
"@ | Set-Content -Encoding ASCII -Path (Join-Path $LowfatPluginPath "lowfat.toml")

$env:LOWFAT_HOME = $LowfatHome

function Get-IdfSubcommand {
    param([string[]]$IdfCommandArgs)

    $optionsWithValue = @("-p", "--port", "-b", "--baud")
    $skipNext = $false

    foreach ($arg in $IdfCommandArgs) {
        if ($skipNext) {
            $skipNext = $false
            continue
        }

        if ($optionsWithValue -contains $arg) {
            $skipNext = $true
            continue
        }

        if ($arg.StartsWith("-")) {
            continue
        }

        return $arg
    }

    return "default"
}

$subcommand = Get-IdfSubcommand -IdfCommandArgs $IdfArgs
if ([string]::IsNullOrWhiteSpace($subcommand)) {
    $subcommand = "default"
}

if ($env:IDF_LOWFAT_DEBUG) {
    Write-Host "IDF_LOWFAT args: $($IdfArgs -join ' ')"
    Write-Host "IDF_LOWFAT subcommand: $subcommand"
}

& $ProfilePath *> $null

Push-Location -Path $ProjectPath
try {
    $output = & idf.py @IdfArgs 2>&1
    $exitCode = $LASTEXITCODE
    $output | ForEach-Object { $_.ToString() } | lowfat.exe filter (Join-Path $LowfatPluginPath "filter.lf") --sub $subcommand --level $Level --exit $exitCode
    exit $exitCode
}
finally {
    Pop-Location
}

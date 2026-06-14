param(
    [Parameter(Position = 0)]
    [string[]]$IdfArgs,
    [string]$ProjectPath = (Get-Location).Path,
    [ValidateSet("lite", "full", "ultra")]
    [string]$Level = "full",
    [string]$ProfilePath = $env:IDF_POWERSHELL_PROFILE,
    [string]$LowfatHome = "$env:USERPROFILE\.lowfat",
    [string]$LowfatPluginPath = "$env:USERPROFILE\.lowfat\plugins\idf.py\esp-idf-compact"
)

if (-not $IdfArgs -or $IdfArgs.Count -eq 0) {
    throw "Pass idf.py arguments, for example: idf-lowfat.ps1 -ProjectPath D:\path\to\esp-idf-project build"
}

function Resolve-IdfProfile {
    param([string]$RequestedProfilePath)

    if ($RequestedProfilePath -and (Test-Path -Path $RequestedProfilePath)) {
        return $RequestedProfilePath
    }

    $candidates = @()
    if ($env:IDF_POWERSHELL_PROFILE) {
        $candidates += $env:IDF_POWERSHELL_PROFILE
    }
    $candidates += Get-ChildItem -Path "$env:USERPROFILE\.espressif", "C:\Espressif\tools" -Filter "Microsoft.*.PowerShell_profile.ps1" -Recurse -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -ExpandProperty FullName

    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -Path $candidate)) {
            return $candidate
        }
    }

    throw "ESP-IDF PowerShell profile not found. Pass -ProfilePath or set IDF_POWERSHELL_PROFILE to Microsoft.*.PowerShell_profile.ps1."
}

if (-not (Test-Path -Path $ProjectPath)) {
    throw "ESP-IDF project path not found: $ProjectPath"
}

$ProfilePath = Resolve-IdfProfile -RequestedProfilePath $ProfilePath

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

[CmdletBinding(PositionalBinding = $false)]
param(
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$IdfArgs,
    [string]$ProfilePath = $env:IDF_POWERSHELL_PROFILE
)

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

    Write-Error "ESP-IDF PowerShell profile not found. Pass -ProfilePath or set IDF_POWERSHELL_PROFILE to Microsoft.*.PowerShell_profile.ps1."
    exit 1
}

$ProfilePath = Resolve-IdfProfile -RequestedProfilePath $ProfilePath
& $ProfilePath *> $null
$output = & idf.py @IdfArgs 2>&1
$exitCode = $LASTEXITCODE
$output | ForEach-Object { $_.ToString() }
exit $exitCode

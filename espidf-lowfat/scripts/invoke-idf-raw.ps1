[CmdletBinding(PositionalBinding = $false)]
param(
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$IdfArgs,
    [string]$ProfilePath = "C:\Espressif\tools\Microsoft.v5.5.4.PowerShell_profile.ps1"
)

if (-not (Test-Path -Path $ProfilePath)) {
    Write-Error "ESP-IDF PowerShell profile not found: $ProfilePath"
    exit 1
}

& $ProfilePath *> $null
$output = & idf.py @IdfArgs 2>&1
$exitCode = $LASTEXITCODE
$output | ForEach-Object { $_.ToString() }
exit $exitCode

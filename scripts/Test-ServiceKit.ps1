[CmdletBinding()]
param([string]$Root = (Join-Path (Split-Path -Parent $PSScriptRoot) 'usb-template'))

$ErrorActionPreference = 'Stop'
$rootPath = [IO.Path]::GetFullPath($Root).TrimEnd('\')
$errors = 0
function Check($ok, $name, $detail = '') {
    if ($ok) { Write-Host "[OK] $name" }
    else { Write-Host "[FAIL] $name $detail"; $script:errors++ }
}

Write-Host 'Ventoy Service Kit Validator'
if (-not (Test-Path -LiteralPath $rootPath -PathType Container)) { throw "Missing root: $rootPath" }
foreach ($directory in @('ISO\Windows', 'ISO\Linux\Ubuntu', 'ISO\Linux\Debian', 'ISO\Linux\Fedora', 'ISO\Linux\Other', 'Diagnostics\Memory\MemTest86', 'Diagnostics\Memory\Memtest86Plus', 'ventoy\profiles\windows')) {
    Check (Test-Path -LiteralPath (Join-Path $rootPath $directory) -PathType Container) $directory
}

$configPath = Join-Path $rootPath 'ventoy\ventoy.json'
$config = $null
try {
    $config = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8 | ConvertFrom-Json
    Check $true 'ventoy.json syntax'
} catch { Check $false 'ventoy.json syntax' $_.Exception.Message }

if ($config) {
    Check ($null -ne $config.auto_install -and @($config.auto_install).Count -gt 0) 'Auto Install entries'
    foreach ($entry in @($config.auto_install)) {
        Check ($entry.autosel -eq 0 -and $entry.timeout -eq 0) 'Manual Auto Install selection'
        if ($entry.parent) {
            $imageDir = [string]$entry.parent
            $validDir = $imageDir -match '^/[^.\\]+$' -and -not $imageDir.Contains('..') -and -not $imageDir.EndsWith('/')
            Check $validDir 'Auto Install parent path' $imageDir
            if ($validDir) { Check (Test-Path -LiteralPath (Join-Path $rootPath ($imageDir.TrimStart('/') -replace '/', '\')) -PathType Container) 'Auto Install parent directory' $imageDir }
        }
        foreach ($template in @($entry.template)) {
            $path = [string]$template
            if ($path -notmatch '^/ventoy/.+\.xml$' -or $path.Contains('..') -or $path.Contains('\')) {
                Check $false 'Profile path' $path
                continue
            }
            $local = Join-Path $rootPath ($path.TrimStart('/') -replace '/', '\')
            Check (Test-Path -LiteralPath $local -PathType Leaf) 'Profile reference' $path
        }
    }
    foreach ($entry in @($config.menu_alias) + @($config.menu_tip.tips)) {
        if ($entry.dir) {
            $dir = [string]$entry.dir
            $validDir = $dir.StartsWith('/') -and -not $dir.Contains('..') -and -not $dir.Contains('\') -and -not $dir.EndsWith('/')
            Check $validDir 'Menu directory path' $dir
            if ($validDir) { Check (Test-Path -LiteralPath (Join-Path $rootPath ($dir.TrimStart('/') -replace '/', '\')) -PathType Container) 'Menu directory reference' $dir }
        }
    }
    if ($config.theme -and $config.theme.file) {
        foreach ($themeFile in @($config.theme.file)) {
            $path = [string]$themeFile
            $validPath = $path.StartsWith('/') -and -not $path.Contains('..') -and -not $path.Contains('\')
            Check $validPath 'Theme path' $path
            if ($validPath) { Check (Test-Path -LiteralPath (Join-Path $rootPath ($path.TrimStart('/') -replace '/', '\')) -PathType Leaf) 'Theme file reference' $path }
        }
    }
}

foreach ($profile in Get-ChildItem -LiteralPath (Join-Path $rootPath 'ventoy\profiles\windows') -Filter '*.xml' -File -ErrorAction SilentlyContinue) {
    try {
        $xml = [xml](Get-Content -LiteralPath $profile.FullName -Raw -Encoding UTF8)
        Check ($xml.DocumentElement.LocalName -eq 'unattend') "XML syntax $($profile.Name)"
        $unsafe = $xml.SelectNodes('//*[local-name()="DiskConfiguration" or local-name()="ImageInstall" or local-name()="ProductKey" or local-name()="RunSynchronous" or local-name()="FirstLogonCommands"]')
        Check ($unsafe.Count -eq 0) "No disk/key/command automation $($profile.Name)"
    } catch { Check $false "XML syntax $($profile.Name)" $_.Exception.Message }
}

if (-not (Get-ChildItem -LiteralPath (Join-Path $rootPath 'ISO\Windows') -Filter '*.iso' -File -ErrorAction SilentlyContinue)) {
    Write-Host '[WARN] No Windows ISO found (user-supplied images are optional)'
}
if (-not (Get-ChildItem -LiteralPath (Join-Path $rootPath 'Diagnostics\Memory\MemTest86') -File -ErrorAction SilentlyContinue | Where-Object Extension -In @('.iso', '.img'))) {
    Write-Host '[INFO] No MemTest86 image found'
}
if ($errors -gt 0) { Write-Host 'Result: INVALID'; exit 1 }
Write-Host 'Result: READY (static checks only)'

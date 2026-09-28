# Copies only repository-owned template files. No disk or partition operations.
[CmdletBinding()]
param(
    [string]$TargetDrive,
    [switch]$Update
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $projectRoot 'usb-template'
$version = (Get-Content -LiteralPath (Join-Path $projectRoot 'VERSION') -Raw).Trim()

if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
    throw "Template directory missing: $sourceRoot"
}

Write-Host "Ventoy Service Kit v$version"
if (-not $TargetDrive) {
    Write-Host 'Available filesystem drives (identity is not verified):'
    Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        $drive = $_
        $label = ''
        try { $label = (Get-Volume -DriveLetter $drive.Name -ErrorAction Stop).FileSystemLabel } catch { }
        Write-Host ("  {0}:  {1}" -f $drive.Name, $label)
    }
    $TargetDrive = Read-Host 'Enter the Ventoy data partition drive letter (example E:)'
}

if ($TargetDrive -notmatch '^[A-Za-z]:\\?$') {
    throw 'TargetDrive must be a drive root such as E:. Subdirectories are not accepted.'
}
$letter = $TargetDrive.Substring(0, 1).ToUpperInvariant()
$targetRoot = "$letter`:"
$targetRoot += '\'
if (-not (Test-Path -LiteralPath $targetRoot -PathType Container)) {
    throw "Drive is unavailable: $targetRoot"
}
if ($letter -eq $env:SystemDrive.Substring(0, 1).ToUpperInvariant()) {
    throw 'The Windows system drive cannot be a Service Kit target.'
}
$driveInfo = [System.IO.DriveInfo]::new($targetRoot)
if (-not $driveInfo.IsReady) { throw "Drive is not ready: $targetRoot" }
if ($driveInfo.DriveType -notin @([System.IO.DriveType]::Removable, [System.IO.DriveType]::Fixed)) {
    throw "Unsupported drive type: $($driveInfo.DriveType)"
}
$label = ''
try { $label = (Get-Volume -DriveLetter $letter -ErrorAction Stop).FileSystemLabel } catch { }
$ventoyFolder = Test-Path -LiteralPath (Join-Path $targetRoot 'ventoy') -PathType Container
Write-Host "Target: $targetRoot ($($driveInfo.DriveType), $([math]::Round($driveInfo.TotalSize / 1GB, 1)) GB; label: $label; ventoy folder: $ventoyFolder)"
Write-Warning 'Ventoy installation could not be verified from the data partition alone. This script only copies files.'
if ((Read-Host 'Continue anyway? [y/N]') -cne 'y') { throw 'Cancelled.' }
if ((Read-Host "Type $letter`: to confirm file copy") -cne "$letter`:") { throw 'Cancelled.' }

$manifestPath = Join-Path $targetRoot 'ServiceKit-Manifest.json'
$oldFiles = @{}
if (Test-Path -LiteralPath $manifestPath -PathType Leaf) {
    if ((Get-Item -LiteralPath $manifestPath -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) {
        throw "Unsafe manifest link: $manifestPath"
    }
    $oldManifest = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($null -eq $oldManifest.files) { throw "Invalid manifest: $manifestPath" }
    foreach ($property in $oldManifest.files.PSObject.Properties) {
        $oldFiles[$property.Name] = [string]$property.Value
    }
} elseif ($Update) {
    Write-Warning 'No previous manifest found. Existing files will be preserved.'
}
$newFiles = @{}
$copied = 0
$skipped = 0
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
$backupRoot = Join-Path $targetRoot ("ServiceKit-Backup\$stamp")
$allowed = @('.md', '.txt', '.json', '.xml')

foreach ($file in Get-ChildItem -LiteralPath $sourceRoot -Recurse -File) {
    if ($file.Extension.ToLowerInvariant() -notin $allowed) {
        throw "Unexpected template file type: $($file.FullName)"
    }
    $relative = $file.FullName.Substring($sourceRoot.Length).TrimStart('\')
    $destination = Join-Path $targetRoot $relative
    $sourceHash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
    $parent = Split-Path -Parent $destination
    $walk = $targetRoot.TrimEnd('\')
    foreach ($part in ($relative -split '\\' | Select-Object -SkipLast 1)) {
        $walk = Join-Path $walk $part
        if (Test-Path -LiteralPath $walk) {
            if ((Get-Item -LiteralPath $walk -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Refusing a reparse point in target path: $walk"
            }
        }
    }
    if (Test-Path -LiteralPath $destination) {
        $item = Get-Item -LiteralPath $destination -Force
        if ($item.PSIsContainer -or ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw "Unsafe target file: $destination"
        }
        $currentHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
        if ($currentHash -eq $sourceHash) {
            $newFiles[$relative] = $sourceHash
            continue
        }
        if (-not $oldFiles.ContainsKey($relative) -or $currentHash -ne $oldFiles[$relative]) {
            Write-Warning "Modified or untracked file preserved: $relative"
            $skipped++
            if ($oldFiles.ContainsKey($relative)) { $newFiles[$relative] = $oldFiles[$relative] }
            continue
        }
        $backup = Join-Path $backupRoot $relative
        New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force | Out-Null
        Copy-Item -LiteralPath $destination -Destination $backup
    }
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
    Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
    $newFiles[$relative] = $sourceHash
    $copied++
}

$manifest = [ordered]@{ version = $version; files = $newFiles }
$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
Write-Host "Copied: $copied; preserved modified files: $skipped"
if (Test-Path -LiteralPath $backupRoot) { Write-Host "Backup: $backupRoot" }
if ($skipped) { Write-Warning 'Review preserved files and merge desired changes manually.' }

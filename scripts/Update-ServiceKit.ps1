[CmdletBinding()]
param([string]$TargetDrive)

$installer = Join-Path $PSScriptRoot 'Install-ServiceKit.ps1'
& $installer -TargetDrive $TargetDrive -Update

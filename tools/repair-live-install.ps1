[CmdletBinding()]
param(
    [string]$MoonloaderRoot = 'D:\Arizona RP\moonloader',
    [string]$ProjectDirName = 'StateHelper',
    [string]$LegacyDataDirName = 'StateHelper'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Directory {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Get-ItemKind {
    param($Item)

    if ($Item.PSIsContainer) {
        return 'directory'
    }

    return 'file'
}

function Get-ItemInfo {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return [ordered]@{
            exists = $false
            path = $Path
        }
    }

    $item = Get-Item -LiteralPath $Path -Force
    $info = [ordered]@{
        exists = $true
        path = $item.FullName
        type = Get-ItemKind $item
    }

    if (-not $item.PSIsContainer) {
        $info.size = [int64]$item.Length
    }

    return $info
}

function Get-ChildSummary {
    param([string]$Root)

    if (-not (Test-Path -LiteralPath $Root)) {
        return @()
    }

    return @(
        Get-ChildItem -LiteralPath $Root -Force |
            Sort-Object Name |
            ForEach-Object {
                $row = [ordered]@{
                    name = $_.Name
                    type = Get-ItemKind $_
                }

                if (-not $_.PSIsContainer) {
                    $row.size = [int64]$_.Length
                }

                $row
            }
    )
}

function Get-RelativeChildTree {
    param([string]$Root)

    if (-not (Test-Path -LiteralPath $Root)) {
        return @()
    }

    $normalizedRoot = (Resolve-Path -LiteralPath $Root).Path.TrimEnd('\')

    return @(
        Get-ChildItem -LiteralPath $normalizedRoot -Recurse -Force |
            Sort-Object FullName |
            ForEach-Object {
                $relative = $_.FullName.Substring($normalizedRoot.Length).TrimStart('\')
                $row = [ordered]@{
                    path = $relative
                    type = Get-ItemKind $_
                }

                if (-not $_.PSIsContainer) {
                    $row.size = [int64]$_.Length
                }

                $row
            }
    )
}

$projectRoot = Join-Path $MoonloaderRoot $ProjectDirName
$legacyRoot = Join-Path $MoonloaderRoot $LegacyDataDirName
$installedRoot = Join-Path $projectRoot 'Arizona_data\installed'
$cacheRoot = Join-Path $projectRoot 'Arizona_data\cache'
$snapshotRoot = Join-Path $installedRoot 'live_layout_snapshots'

Ensure-Directory $projectRoot
Ensure-Directory $cacheRoot
Ensure-Directory $installedRoot
Ensure-Directory $snapshotRoot

$layoutPath = Join-Path $installedRoot 'live_layout.json'
$snapshotPath = Join-Path $snapshotRoot ('live_layout_{0}.json' -f (Get-Date -Format 'yyyyMMdd_HHmmss'))

$warnings = New-Object System.Collections.Generic.List[string]

foreach ($requiredPath in @(
    (Join-Path $MoonloaderRoot 'StateHelper.lua'),
    $projectRoot,
    $legacyRoot,
    (Join-Path $projectRoot 'Arizona_bootstrap'),
    (Join-Path $projectRoot 'core'),
    (Join-Path $projectRoot 'features')
)) {
    if (-not (Test-Path -LiteralPath $requiredPath)) {
        $warnings.Add("Missing expected path: $requiredPath")
    }
}

$layout = [ordered]@{
    generated_at = (Get-Date).ToString('o')
    tool = 'tools/repair-live-install.ps1'
    tool_version = 'v5.0.0-alpha'
    project_version = 'v5.0.0-alpha'
    moonloader_root = $MoonloaderRoot
    roots = [ordered]@{
        entry_script = Get-ItemInfo (Join-Path $MoonloaderRoot 'StateHelper.lua')
        code_root = Get-ItemInfo $projectRoot
        legacy_data_root = Get-ItemInfo $legacyRoot
    }
    important_files = [ordered]@{
        moonloader_log = Get-ItemInfo (Join-Path $MoonloaderRoot 'moonloader.log')
        update_info = Get-ItemInfo (Join-Path $projectRoot 'update_info.json')
        cached_update_info = Get-ItemInfo (Join-Path $cacheRoot 'remote_update_info.json')
        managed_files = Get-ItemInfo (Join-Path $installedRoot 'managed_files.lst')
        live_layout = Get-ItemInfo $layoutPath
        settings = Get-ItemInfo (Join-Path $legacyRoot 'Настройки.json')
        settings_backup = Get-ItemInfo (Join-Path $legacyRoot 'Настройки.json.bak')
        police_vehicle = Get-ItemInfo (Join-Path $legacyRoot 'Police\vehicle.json')
        police_tencode = Get-ItemInfo (Join-Path $legacyRoot 'Police\tencode.json')
    }
    overview = [ordered]@{
        code_top_level = Get-ChildSummary $projectRoot
        legacy_top_level = Get-ChildSummary $legacyRoot
    }
    tree = [ordered]@{
        code = Get-RelativeChildTree $projectRoot
        legacy = Get-RelativeChildTree $legacyRoot
    }
    warnings = @($warnings)
}

$json = $layout | ConvertTo-Json -Depth 8
[System.IO.File]::WriteAllText($layoutPath, $json, [System.Text.UTF8Encoding]::new($false))
$layout.important_files.live_layout = Get-ItemInfo $layoutPath
$json = $layout | ConvertTo-Json -Depth 8
[System.IO.File]::WriteAllText($snapshotPath, $json, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText($layoutPath, $json, [System.Text.UTF8Encoding]::new($false))

Write-Host 'StateHelper live layout indexed successfully.'
Write-Host "Layout file: $layoutPath"
Write-Host "Snapshot: $snapshotPath"

if ($warnings.Count -gt 0) {
    Write-Host 'Warnings:'
    foreach ($warning in $warnings) {
        Write-Host " - $warning"
    }
}

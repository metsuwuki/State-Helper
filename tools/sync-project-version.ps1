param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$releaseConfigFile = Join-Path $RepoRoot 'StateHelper\core\release_config.lua'
$entryFile = Join-Path $RepoRoot 'StateHelper.lua'
$updateInfoFile = Join-Path $RepoRoot 'StateHelper\update_info.json'
$vehicleFile = Join-Path $RepoRoot 'StateHelper\Arizona_data\remote\vehicle.json'

if (-not (Test-Path $releaseConfigFile)) {
    throw "Release config file not found: $releaseConfigFile"
}

$releaseConfigSource = Get-Content -Path $releaseConfigFile -Raw -Encoding UTF8
$projectVersion = [regex]::Match($releaseConfigSource, "value\s*=\s*'([^']+)'").Groups[1].Value
$vehicleVersion = [regex]::Match($releaseConfigSource, "vehicle\s*=\s*'([^']+)'").Groups[1].Value
$channel = [regex]::Match($releaseConfigSource, "channel\s*=\s*'([^']+)'").Groups[1].Value
$size = [regex]::Match($releaseConfigSource, "size\s*=\s*'([^']+)'").Groups[1].Value
$owner = [regex]::Match($releaseConfigSource, "owner\s*=\s*'([^']+)'").Groups[1].Value
$repo = [regex]::Match($releaseConfigSource, "repo\s*=\s*'([^']+)'").Groups[1].Value

if ([string]::IsNullOrWhiteSpace($projectVersion)) {
    throw 'Failed to read project version from StateHelper/core/release_config.lua'
}

if ([string]::IsNullOrWhiteSpace($vehicleVersion)) {
    $vehicleVersion = $projectVersion
}

$repositoryUrl = $null
if (-not [string]::IsNullOrWhiteSpace($owner) -and -not [string]::IsNullOrWhiteSpace($repo)) {
    $repositoryUrl = "https://github.com/$owner/$repo"
}

$updateInfo = Get-Content -Path $updateInfoFile -Raw -Encoding UTF8 | ConvertFrom-Json
$updateInfo.version = $projectVersion
$updateInfo.vehicle = $vehicleVersion
$updateInfo.channel = if ([string]::IsNullOrWhiteSpace($channel)) { $updateInfo.channel } else { $channel }
$updateInfo.size = if ([string]::IsNullOrWhiteSpace($size)) { $updateInfo.size } else { $size }
if (-not [string]::IsNullOrWhiteSpace($repositoryUrl)) {
    $updateInfo.repository = $repositoryUrl
}
$updateInfo | ConvertTo-Json -Depth 10 | Set-Content -Path $updateInfoFile -Encoding UTF8

$vehicleInfo = Get-Content -Path $vehicleFile -Raw -Encoding UTF8 | ConvertFrom-Json
if ($vehicleInfo -is [System.Collections.IList] -and $vehicleInfo.Count -gt 0) {
    $vehicleInfo[0].version = $vehicleVersion
} elseif ($vehicleInfo -and $vehicleInfo.PSObject.Properties.Name -contains 'version') {
    $vehicleInfo.version = $vehicleVersion
}
$vehicleInfo | ConvertTo-Json -Depth 10 | Set-Content -Path $vehicleFile -Encoding UTF8

if (-not (Test-Path $entryFile)) {
    throw "Entrypoint file not found: $entryFile"
}

$entrySource = Get-Content -Path $entryFile -Raw -Encoding UTF8
$entryPattern = "local fallback_version = '[^']+'"
$entryReplacement = "local fallback_version = '$projectVersion'"
$entryMatchFound = [regex]::IsMatch($entrySource, $entryPattern)
if (-not $entryMatchFound) {
    throw 'Failed to locate fallback version placeholder in StateHelper.lua'
}

$updatedEntry = [regex]::Replace($entrySource, $entryPattern, $entryReplacement, 1)
if ($updatedEntry -ne $entrySource) {
    $updatedEntry | Set-Content -Path $entryFile -Encoding UTF8
}

Write-Output "Synced project version to $projectVersion"

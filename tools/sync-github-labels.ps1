param(
    [Parameter(Mandatory = $true)]
    [string]$Token,
    [string]$Owner = 'metsuwuki',
    [string]$Repo = 'State-Helper',
    [string]$LabelsFile = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..')).Path '.github\labels.json')
)

if (-not (Test-Path $LabelsFile)) {
    throw "Labels file not found: $LabelsFile"
}

$headers = @{
    Authorization = "Bearer $Token"
    Accept = 'application/vnd.github+json'
    'X-GitHub-Api-Version' = '2022-11-28'
}

$labels = Get-Content -Path $LabelsFile -Raw -Encoding UTF8 | ConvertFrom-Json

foreach ($label in $labels) {
    $name = [string]$label.name
    $payload = @{
        new_name    = $name
        color       = ([string]$label.color).TrimStart('#')
        description = [string]$label.description
    } | ConvertTo-Json

    $uri = "https://api.github.com/repos/$Owner/$Repo/labels/$([uri]::EscapeDataString($name))"

    try {
        Invoke-RestMethod -Method Patch -Uri $uri -Headers $headers -Body $payload -ContentType 'application/json' | Out-Null
        Write-Output "Updated label: $name"
    } catch {
        $createUri = "https://api.github.com/repos/$Owner/$Repo/labels"
        $createPayload = @{
            name        = $name
            color       = ([string]$label.color).TrimStart('#')
            description = [string]$label.description
        } | ConvertTo-Json

        Invoke-RestMethod -Method Post -Uri $createUri -Headers $headers -Body $createPayload -ContentType 'application/json' | Out-Null
        Write-Output "Created label: $name"
    }
}

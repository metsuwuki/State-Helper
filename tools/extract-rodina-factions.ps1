#Requires -Version 5.1
# Extracts Rodina faction commands from the monolithic Rodina.lua
# and writes them to Rodina_factions/ structure.

$enc1251 = [System.Text.Encoding]::GetEncoding(1251)
$encUTF8NoBOM = New-Object System.Text.UTF8Encoding($false)

$src = "C:\Users\varpm\Documents\StateHelper_Rodina.lua"
$base = "E:\1 - Programming\State Helper\StateHelper\Rodina_factions"

Write-Host "Reading source file..." -ForegroundColor Cyan
$srcLines = [System.IO.File]::ReadAllLines($src, $enc1251)
Write-Host "Total lines: $($srcLines.Length)" -ForegroundColor Cyan

# Find table end: parse ignoring [[ ... ]] long strings
function Find-TableEnd {
    param([string[]]$lineArray, [int]$startIdx)
    $inLongStr = $false
    $depth = 0
    for ($i = $startIdx; $i -lt $lineArray.Length; $i++) {
        $line = $lineArray[$i]
        $j = 0
        while ($j -lt $line.Length) {
            if ($inLongStr) {
                if ($j -lt ($line.Length - 1) -and $line[$j] -eq ']' -and $line[$j+1] -eq ']') {
                    $inLongStr = $false; $j += 2; continue
                }
            } else {
                if ($j -lt ($line.Length - 1) -and $line[$j] -eq '[' -and $line[$j+1] -eq '[') {
                    $inLongStr = $true; $j += 2; continue
                }
                if ($line[$j] -eq '{') { $depth++ }
                elseif ($line[$j] -eq '}') {
                    $depth--
                    if ($depth -eq 0) { return $i }
                }
            }
            $j++
        }
    }
    return -1
}

# Renumber [N] = [[ entries to be sequential (fixes gaps in police table)
function Renumber-Commands {
    param([string[]]$innerLines)
    $counter = 1
    $out = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $innerLines) {
        if ($line -match '^\s*\[\d+\]\s*=\s*\[\[') {
            $out.Add("[${counter}] = [[")
            $counter++
        } else {
            $out.Add($line)
        }
    }
    return ,$out.ToArray()
}

$factions = @(
    [ordered]@{folder='common';         varSuffix='all';            title='Common';        id='common'},
    [ordered]@{folder='hospital';        varSuffix='hospital';       title='Hospital';      id='hospital'},
    [ordered]@{folder='license_center';  varSuffix='driving_school'; title='License Center';id='license_center'},
    [ordered]@{folder='government';      varSuffix='government';     title='Government';    id='government'},
    [ordered]@{folder='army';            varSuffix='army';           title='Army';          id='army'},
    [ordered]@{folder='jail';            varSuffix='jail';           title='Jail';          id='jail'},
    [ordered]@{folder='police';          varSuffix='police';         title='Police';        id='police'},
    [ordered]@{folder='smi';             varSuffix='smi';            title='SMI';           id='smi'}
)

foreach ($f in $factions) {
    $varName = "cmd_defoult_json_for_$($f.varSuffix)"
    Write-Host ""
    Write-Host "Processing: $($f.folder) ($varName)" -ForegroundColor Yellow

    # Find start index
    $startIdx = -1
    for ($i = 0; $i -lt $srcLines.Length; $i++) {
        if ($srcLines[$i] -match "^local $varName\s*=\s*\{") {
            $startIdx = $i; break
        }
    }
    if ($startIdx -eq -1) { Write-Host "  NOT FOUND: $varName" -ForegroundColor Red; continue }
    Write-Host "  Start line: $($startIdx + 1)"

    # Find end index
    $endIdx = Find-TableEnd -lineArray $srcLines -startIdx $startIdx
    if ($endIdx -eq -1) { Write-Host "  END NOT FOUND" -ForegroundColor Red; continue }
    Write-Host "  End line:   $($endIdx + 1)"

    # Extract inner lines (skip first and last: declaration and closing })
    $innerLines = $srcLines[($startIdx + 1)..($endIdx - 1)]

    # Renumber [N] = [[ to sequential
    $renumbered = Renumber-Commands -innerLines $innerLines

    # Build commands.lua content
    $header = "--[[$([Environment]::NewLine)Open with encoding: CP1251$([Environment]::NewLine)StateHelper/Rodina_factions/$($f.folder)/commands.lua$([Environment]::NewLine)]]"
    $sb = [System.Text.StringBuilder]::new()
    $sb.AppendLine($header) | Out-Null
    $sb.AppendLine("local commands = {") | Out-Null
    foreach ($line in $renumbered) {
        $sb.AppendLine($line) | Out-Null
    }
    $sb.AppendLine("}") | Out-Null
    $sb.AppendLine("return commands") | Out-Null
    $cmdContent = $sb.ToString()

    # Package.lua content (UTF-8)
    $pkgContent = "--[[`r`nOpen with encoding: UTF-8`r`nStateHelper/Rodina_factions/$($f.folder)/package.lua`r`n]]`r`n`r`nlocal package_def = { id = '$($f.id)', title = '$($f.title)', mechanics = {} }`r`nfunction package_def:init(ctx) ctx.logger:info('$($f.id) package initialized') end`r`nreturn package_def`r`n"

    # Write files
    $destDir = "$base\$($f.folder)"
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null

    [System.IO.File]::WriteAllText("$destDir\commands.lua", $cmdContent, $enc1251)
    Write-Host "  Written: commands.lua ($($cmdContent.Length) chars)" -ForegroundColor Green

    [System.IO.File]::WriteAllText("$destDir\package.lua", $pkgContent, $encUTF8NoBOM)
    Write-Host "  Written: package.lua" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Done! ===" -ForegroundColor Cyan

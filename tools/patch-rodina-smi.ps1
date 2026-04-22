$enc1251 = [System.Text.Encoding]::GetEncoding(1251)
$src = 'C:\Users\varpm\Documents\StateHelper_Rodina.lua'
$lines = [System.IO.File]::ReadAllLines($src, $enc1251)

# Find medcard_phoenix line
$mcStart = -1
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match '^local medcard_phoenix\s*=\s*\[\[') {
        $mcStart = $i; break
    }
}
Write-Host "medcard_phoenix start: $($mcStart + 1)"

# Find mc_phoenix = {} line after it
$mcEnd = -1
for ($i = $mcStart; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match '^mc_phoenix\s*=\s*\{\}') {
        $mcEnd = $i; break
    }
}
Write-Host "mc_phoenix end: $($mcEnd + 1)"

if ($mcStart -eq -1 -or $mcEnd -eq -1) {
    Write-Host "ERROR: markers not found!" -ForegroundColor Red
    exit 1
}

# Extract those lines
$extracted = $lines[$mcStart..$mcEnd]
$addition = $extracted -join [System.Environment]::NewLine

# Read current smi/commands.lua (CP1251)
$dest = 'E:\1 - Programming\State Helper\StateHelper\Rodina_factions\smi\commands.lua'
$current = [System.IO.File]::ReadAllText($dest, $enc1251)

# Insert before 'return commands'
$newContent = $current -replace 'return commands', ("$addition`r`nreturn commands")

[System.IO.File]::WriteAllText($dest, $newContent, $enc1251)
Write-Host "Done! smi/commands.lua updated" -ForegroundColor Green

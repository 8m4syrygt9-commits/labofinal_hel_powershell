# Fiche d'info système - version 1
# Affiche : nom du PC, espace disque, mémoire, processus les plus gourmands

Write-Host "===== FICHE D'INFO SYSTEME =====" -ForegroundColor Cyan

# 1) Nom du PC
$info = Get-ComputerInfo
Write-Host "Nom du PC : $($info.CsName)"
Write-Host "Système   : $($info.OsName)"

# 2) Espace disque (en Go)
Write-Host ""
Write-Host "--- Disques ---" -ForegroundColor Yellow
$disques = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null }
foreach ($d in $disques) {
    $utilise = [math]::Round($d.Used / 1GB, 1)
    $libre   = [math]::Round($d.Free / 1GB, 1)
    Write-Host "$($d.Name): utilisé $utilise Go, libre $libre Go"
}

# 3) Mémoire (les valeurs sont en Ko)
Write-Host ""
Write-Host "--- Mémoire ---" -ForegroundColor Yellow
$total = [math]::Round($info.OsTotalVisibleMemorySize / 1MB, 1)
$libre = [math]::Round($info.OsFreePhysicalMemory / 1MB, 1)
Write-Host "RAM totale : $total Go, libre : $libre Go"

# 4) Les 5 processus qui utilisent le plus de mémoire
Write-Host ""
Write-Host "--- Top 5 des processus ---" -ForegroundColor Yellow
Get-Process |
    Sort-Object WorkingSet -Descending |
    Select-Object -First 5 Name, @{Name="Mémoire (Mo)"; Expression={[math]::Round($_.WorkingSet / 1MB, 1)}} |
    Format-Table -AutoSize

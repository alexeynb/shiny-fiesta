<#
.SYNOPSIS
    Фильтрует таблицу ARP, исключая строки с указанными MAC-адресами.

.DESCRIPTION
    Скрипт выполняет команду 'arp -a', извлекает пары IP и MAC,
    исключает из результата все записи, чьи MAC-адреса указаны в файле exclude-mac.txt,
    и сохраняет оставшиеся данные в CSV-файл с двумя столбцами: ip, mac.

.NOTES
    Автор: Алексей / ChatGPT  
    Версия: 1.2  
    Дата: 2025-10-16
#>

# === Настройки ===
$excludeFile = "exclude-mac.txt"      # файл со списком MAC-адресов для исключения
$outputFile  = "filtered-arp.csv"     # имя выходного CSV-файла

# === Обработка MAC-адресов для исключения ===
$excludeMacs = Get-Content $excludeFile |
    ForEach-Object {
        ($_ -replace '[:\.]', '-' -replace '-', '-').ToLower() `
        -replace '[^0-9a-f\-]', ''
    } | Sort-Object -Unique

# === Получаем ARP-таблицу ===
$arp = arp -a

# === Извлекаем IP и MAC, исключаем совпадения ===
$results = foreach ($line in $arp) {
    if ($line -match '(\d{1,3}(?:\.\d{1,3}){3})\s+([0-9a-f:-]{17})') {
        $ip = $matches[1]
        $mac = $matches[2].ToLower()
        $macNorm = $mac -replace ':', '-'  # ARP использует дефисы
        if ($excludeMacs -notcontains $macNorm) {
            [PSCustomObject]@{
                ip  = $ip
                mac = $macNorm
            }
        }
    }
}

# === Экспорт в CSV ===
$results | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "Файл сохранён: $outputFile" -ForegroundColor Green

# Путь к исходному файлу
$inputFile = "mac-list.txt"
$outputFile = "mac-list-normalized.txt"

# Регулярка для всех форматов MAC
$pattern = '\b(?:[0-9A-Fa-f]{2}(?:[:\-][0-9A-Fa-f]{2}){5}|(?:[0-9A-Fa-f]{4}\.){2}[0-9A-Fa-f]{4}|[0-9A-Fa-f]{12})\b'

# Чтение файла и обработка
Get-Content $inputFile | ForEach-Object {
    $line = $_
    if ($line -match $pattern) {
        $mac = $matches[0] -replace '[:\-]', ''     # убираем : и -
        $mac = $mac -replace '\.', ''               # убираем точки
        $mac = $mac.ToUpper()                       # всё в верхний регистр
        # разбиваем каждые 2 символа и соединяем дефисами
        $normalized = ($mac -split '(.{2})' | Where-Object { $_ }) -join '-'
        $normalized
    }
} | Set-Content $outputFile

Write-Host "Готово! Все MAC-адреса сохранены в $outputFile" -ForegroundColor Green

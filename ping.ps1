$range = 1..255 | ForEach-Object { "192.168.0.$_" }

foreach ($ip in $range) {
    Write-Host "Пинг $ip" -ForegroundColor Cyan
    Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue | Out-Null
}

Write-Host "`nARP-таблица обновлена:`n" -ForegroundColor Green
arp -a

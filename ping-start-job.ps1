$range = 1..255 | ForEach-Object { "192.168.0.$_" }

foreach ($ip in $range) {
    Start-Job -ScriptBlock {
        if (Test-Connection -ComputerName $using:ip -Count 1 -Quiet) {
            Write-Output "$using:ip отвечает"
        } else {
            Write-Output "$using:ip нет ответа"
        }
    }
}

# Ожидаем завершения всех заданий
Get-Job | Wait-Job

# Собираем результаты
Get-Job | Receive-Job

# Чистим завершённые задания
Get-Job | Remove-Job

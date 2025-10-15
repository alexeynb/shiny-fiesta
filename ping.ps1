$range = 1..255 | ForEach-Object { "192.168.0.$_" }

$range | ForEach-Object -Parallel {
    Test-Connection -ComputerName $_ -Count 1 -Quiet -ErrorAction SilentlyContinue | Out-Null
}

arp -a

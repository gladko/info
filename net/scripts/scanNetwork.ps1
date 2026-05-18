$net="192.168.2"
# $net="192.168.100"

1..254 | ForEach-Object {
    $ip = "${net}.$_"
    Write-Host "trying $ip"

    if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
        Write-Host "$ip is online"
    }
}
Write-Host "Finish"
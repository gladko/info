Get-NetTCPConnection -State Listen | ForEach-Object {
    $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        LocalAddress = $_.LocalAddress
        LocalPort    = $_.LocalPort
        ProcessId   = $_.OwningProcess
        ProcessName = if ($proc) { $proc.ProcessName } else { "N/A" }
    }
}
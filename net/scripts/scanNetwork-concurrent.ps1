# $Script:net="192.168.2"
# $net="192.168.100"

Write-Host "Start at $(Get-Date)"

# Start jobs concurrently
$jobs = 0..25 | ForEach-Object {
    Start-Job -ScriptBlock { 
       param($n)

        function My-Function {
            param($index)
            $from=$index * 10
            $to=$from + 9

            "-> starting scan $from..$to at $(Get-Date)"

            $from..$to | ForEach-Object {
                $net="192.168.2"
                $ip = "$net.$_"

                # Write-Host  "trying $ip at $(Get-Date)"

                if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
                    Write-Host "$ip is online"
                }
            }

            <#
            Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 5)
            "Hello, $from at $(Get-Date)"
             #>          
        }

       # param($n) 
        My-Function  -index $n
    } -ArgumentList $_
}

# Wait for all jobs to complete and collect results
$jobs | Wait-Job
$results = $jobs | Receive-Job

# Clean up jobs
$jobs | Remove-Job

$results

Write-Host "Finish at $(Get-Date)"
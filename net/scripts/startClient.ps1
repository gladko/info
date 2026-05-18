$ip = "192.168.100.1"
$port = 5555

# Create TCP Client and connect
$client = New-Object System.Net.Sockets.TcpClient($ip, $port)
$stream = $client.GetStream()
$reader = New-Object System.IO.StreamReader($stream)
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true

Write-Host "Connected to ${ip}:${por}t. Type messages, 'exit' to quit."

while ($true) {
    $line = Read-Host "Send"
    $writer.WriteLine($line)
    if ($line -eq "exit") { break }
    
    # Read response from server
    $response = $reader.ReadLine()
    Write-Host "Received from server: $response"
}

# Clean up
$reader.Close()
$writer.Close()
$stream.Close()
$client.Close()
Write-Host "Client disconnected."
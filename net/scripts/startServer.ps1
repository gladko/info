# Define IP and Port to listen on (use your loopback adapter IP or 0.0.0.0 for all interfaces)
$ip = [System.Net.IPAddress]::Parse("192.168.100.1")  
$port = 5555

# Create TcpListener object
$listener = [System.Net.Sockets.TcpListener]::new($ip, $port)

# Start listening
$listener.Start()
Write-Host "Listening on ${ip}:${port}..."

# Accept incoming connection (blocking call)
$client = $listener.AcceptTcpClient()
Write-Host "Client connected!"

# Get network stream for reading/writing
$stream = $client.GetStream()

# Create reader and writer
$reader = New-Object System.IO.StreamReader($stream)
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true

# Simple loop: echo received data
while ($true) {
    if ($stream.DataAvailable) {
        $data = $reader.ReadLine()
        if ($data -eq $null -or $data -eq "exit") { break }
        Write-Host "Received: $data"
        $writer.WriteLine("Echo: $data")
    }
    Start-Sleep -Milliseconds 100
}

# Clean up
$reader.Close()
$writer.Close()
$stream.Close()
$client.Close()
$listener.Stop()
Write-Host "Server stopped."
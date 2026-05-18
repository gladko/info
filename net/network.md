## Creating a new network interface in Windows

### 1. Create a Virtual Network Adapter (Using PowerShell)
Windows allows you to create virtual network adapters, such as Hyper-V virtual switches or loopback adapters. Here's how to add a virtual network adapter using PowerShell — a common type is the **Microsoft KM-TEST Loopback Adapter**.
Add Microsoft Loopback Adapter (Windows 10/11):
1. Open Device Manager:
  - Press `Win + X` and select Device Manager.
2. Click Action > Add legacy hardware:
  - In the Add Hardware Wizard, click Next.
  - Choose Install the hardware that I manually select from a list (Advanced) and click Next.
  - Select Network adapters and click Next.
  - Under Manufacturer, select Microsoft.
  - Select Microsoft *KM-TEST Loopback Adapter* or *Microsoft Loopback Adapter* from the list.
  - Click Next, then Finish.
This installs a virtual network adapter you can configure like a physical interface.
---
### 2. Create a Virtual Network Adapter Using PowerShell (Hyper-V Virtual Switch)
If you have Hyper-V installed, you can create a virtual network interface with:
```powershell
New-VMSwitch -Name "MyVirtualSwitch" -SwitchType Internal
```
This creates a virtual switch named `MyVirtualSwitch` with an internal network. This creates a new virtual NIC on your host machine.
You can also create External or Private virtual switches:
- External (bridges to physical NIC):
```powershell
New-VMSwitch -Name "ExternalSwitch" -NetAdapterName "Ethernet" -AllowManagementOS $true
```
- Private:
```powershell
New-VMSwitch -Name "PrivateSwitch" -SwitchType Private
```
---
### 3. Configure a New IP Address on an Existing Network Interface
If your goal is to add another IP address to an existing network interface (creating a second IP on the same NIC), use this command:
```powershell
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.1.10 -PrefixLength 24 -DefaultGateway 192.168.1.1
```
Change `Ethernet` to your interface name (use` Get-NetAdapter` to find it).
---
### 4. Add a Network Interface Card (NIC) in a VM
If you are running Windows inside a virtual machine, adding a new network interface typically means adding a new virtual NIC using your VM management tool (like Hyper-V Manager, VMware, VirtualBox).

## Show the list of network interfaces in a Windows
### Method 1: Using Command Prompt
```bash
ipconfig /all
```
or
```bash
netsh interface show interface
```
### Method 2: Using PowerShell
```powershell
Get-NetAdapter
```
### Method 3: Using Control Panel
1. Open Control Panel.
2. Go to `Network and Internet` > `Network and Sharing Center`.
3. Click on "Change adapter settings" on the left sidebar.
4. Here you’ll see a list of all network interfaces.


## Show opened (listening) ports and active connections on a Windows machine
---
### 1. Using netstat Command
Open Command Prompt or PowerShell, then run:
```cmd
netstat -an | find "LISTEN"
```
- Shows all ports that are currently in LISTENING state.
- -a — Displays all connections and listening ports.
- -n — Displays addresses and port numbers in numerical form.
- find "LISTEN" — Filters the output to show only listening ports.
---
#### To show process names or IDs (which program opened the port):
```cmd
netstat -ano | find "LISTEN"
```
- -o — Shows the owning process ID (PID).
To identify the process name by PID:
```cmd
tasklist /FI "PID eq <PID>"
```
Replace <PID> with the actual process ID from the netstat output.
---
### 2. Using PowerShell — Get-NetTCPConnection
```powershell
Get-NetTCPConnection -State Listen
```
This shows all TCP ports in the LISTEN state along with local address and owning process ID.
To get process names together with ports:
```powershell
Get-NetTCPConnection -State Listen | ForEach-Object {
    $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        LocalAddress = $_.LocalAddress
        LocalPort    = $_.LocalPort
        ProcessId   = $_.OwningProcess
        ProcessName = if ($proc) { $proc.ProcessName } else { "N/A" }
    }
}
```
---
### 3. Using Resource Monitor (GUI)
1. Press Windows + R, type resmon, hit Enter.
2. Go to Network tab.
3. Expand Listening Ports section.
4. You'll see ports, process names, PID, and associated programs.
---
### Summary
| Method            | Details                                   | Command/Tool           |
|-------------------|-------------------------------------------|-----------------------|
| netstat           | Show listening ports + PIDs                | netstat -ano | find "LISTEN" |
| PowerShell        | Show listening TCP connections with process names | Get-NetTCPConnection -State Listen + script |
| Resource Monitor  | GUI tool to view listening ports and processes | Run resmon           |


## Test socket connection
```cmd
ping 192.168.100.1
tracert 192.168.100.1
```
```powershell
Test-NetConnection -ComputerName 192.168.100.1 -Port 80
```

### Netcat or Ncat (Port listen/send testing)
If you have Ncat installed (recommended over classic Netcat for Windows):
1. Start a Listening Server (Example TCP port 12345):
```cmd
ncat -l 12345
```
2. Connect to That Server (From the same machine, targeting loopback adapter IP):
```cmd
ncat 192.168.100.1 12345
```
You can then type messages back and forth.
---

## DNS troubleshooting and managing on Windows
- check Hosts File: `C:\Windows\System32\drivers\etc\hosts`
- Show DNS client cache: `ipconfig /displaydns`
- Flush DNS client cache: ` ipconfig /flushdns`
- Register your machine's DNS name dynamically:  `ipconfig /registerdns`
- Test DNS resolution: `nslookup www.example.com`
- See configured DNS server: `ipconfig /all`
  
  прокинуть порт в wsl
  netsh interface portproxy add v4tov4 listenport=6443 listenaddress=0.0.0.0 connectport=6443 connectaddress=172.17.244.18
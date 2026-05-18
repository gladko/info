[Implementing Per-Domain DNS Configuration on Linux Ubuntu Using dnsmasq ](https://oriolrius.cat/tag/wsl)


https://askubuntu.com/questions/191226/dnsmasq-failed-to-create-listening-socket-for-port-53-address-already-in-use
Disable any service that is running on this port. It's usually systemd-resolved.
Here I make sure that you have stopped the systemd-resolved service. I'm going to also mask it so it doesn't auto start on reboot.
```bash
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo systemctl mask systemd-resolved
```
To undo what you did:
```bash
sudo systemctl unmask systemd-resolved
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
```

## PROBLEM with port 53

```bash
vk@vkozak-nb:/etc$ sudo ss -lp "sport = :domain"
Netid   State    Recv-Q    Send-Q        Local Address:Port         Peer Address:Port   Process
udp     UNCONN   0         0                127.0.0.54:domain            0.0.0.0:*       users:(("systemd-resolve",pid=8523,fd=16))
udp     UNCONN   0         0             127.0.0.53%lo:domain            0.0.0.0:*       users:(("systemd-resolve",pid=8523,fd=14))
udp     UNCONN   0         0            10.255.255.254:domain            0.0.0.0:*
tcp     LISTEN   0         4096             127.0.0.54:domain            0.0.0.0:*       users:(("systemd-resolve",pid=8523,fd=17))
tcp     LISTEN   0         4096          127.0.0.53%lo:domain            0.0.0.0:*       users:(("systemd-resolve",pid=8523,fd=15))
tcp     LISTEN   0         1000         10.255.255.254:domain            0.0.0.0:*
vk@vkozak-nb:/etc$ sudo netstat -tpln
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN      8523/systemd-resolv
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      8523/systemd-resolv
tcp        0      0 10.255.255.254:53       0.0.0.0:*               LISTEN      -
vk@vkozak-nb:/etc$
```
Running a DNS server inside Docker on WSL is totally doable. Here’s how you can set up a simple DNS server containerized in Docker inside your WSL environment.
---
# Example: Run a DNS server in Docker on WSL
You can deploy a lightweight DNS server like CoreDNS, dnsmasq, or bind9 in Docker.
---
## Method 1: Run CoreDNS in Docker
CoreDNS is simple, lightweight, and widely used. Here’s a step-by-step for running CoreDNS container on Docker inside WSL.
### Prerequisites
- Docker is installed and working inside WSL.
- Docker daemon running (either Windows Docker Desktop with WSL integration or Docker installed inside WSL).
---
### Step 1: Create a CoreDNS configuration file
Create a directory for CoreDNS config on your WSL fs:
```bash
mkdir -p ~/coredns
cd ~/coredns
```
Create a Corefile (this is the CoreDNS config file):
```bash
cat > Corefile <<EOF
.:53 {
    hosts {
        127.0.0.1 localhost
        192.168.1.100 myserver.local
        fallthrough
    }
    forward . 8.8.8.8 8.8.4.4
    log
    errors
}
EOF
```
- This config makes CoreDNS listen on port 53.
- It defines a static host entry for myserver.local.
- For other queries, it forwards to Google DNS.
---
### Step 2: Run the CoreDNS container
Run CoreDNS container, mounting your config and exposing port 53:
```bash
docker run -d --name coredns \
  -p 53:53/udp -p 53:53/tcp \
  -v $(pwd)/Corefile:/Corefile \
  coredns/coredns:latest \
  -conf /Corefile
```
This will:
- Start the CoreDNS server in a container.
- Bind port 53 (UDP and TCP) of container to your WSL host.
- Use your custom Corefile.
---
### Step 3: Test your DNS server
Use dig or nslookup inside WSL or Windows to test queries: `dig @127.0.0.1 myserver.local`
You should get 192.168.1.100 as the answer.
Or try forwarding via CoreDNS to Google DNS:
```bash
dig @127.0.0.1 google.com
```
---
## Method 2: Run dnsmasq in Docker
Dnsmasq is another lightweight DNS forwarder and DHCP server useful for small DNS.
Run dnsmasq in a container:
1. Create a simple dnsmasq config dnsmasq.conf (example):
```bash
echo "address=/myserver.local/192.168.1.100" > dnsmasq.conf
```
2. Run the container:
```bash
docker run -d --name dnsmasq \
  -p 53:53/udp \
  -v $(pwd)/dnsmasq.conf:/etc/dnsmasq.conf \
  andyshinn/dnsmasq:2.85
```
Test similarly with dig.
---
## Notes:
- Binding to port 53: On Linux you need root permissions to bind to port 53 (<1024); running docker with sudo inside WSL may be necessary.
- WSL Networking: If you want your Windows host or other machines to use your DNS server running inside WSL, you need to ensure port 53 is exposed and accessible.
- On Windows, Docker Desktop with WSL2 backend integrates the networks, but firewall rules may need adjustment.
- You can run DNS server on a non-privileged port (e.g., 5353) and port-forward on Windows if needed.
---
## Summary: Running CoreDNS DNS server in Docker inside WSL
```bash
mkdir ~/coredns && cd ~/coredns
cat > Corefile <<EOF
.:53 {
   hosts {
       127.0.0.1 localhost
       192.168.1.100 myserver.local
       fallthrough
   }
   forward . 8.8.8.8 8.8.4.4
   log
   errors
}
EOF
sudo docker run -d --name coredns -p 53:53/udp -p 53:53/tcp \
 -v $(pwd)/Corefile:/Corefile \
 coredns/coredns:latest -conf /Corefile
dig @127.0.0.1 myserver.local
```
---
If you want help setting up persistent data, integrating with WSL DNS resolution, or other DNS server options, just ask!


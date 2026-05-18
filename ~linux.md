
Applies my personal SHELL variables
```bash
source ~/.vk_profile
echo $SHELL  
```


 ## DOWNLOAD & UPLOAD   
```bash
# download file from a remote machine
scp user@remote_host_name:/file_path local_path_to

# upload file to a remote machine
scp file_name user@remote_host_name:/path_to
# upload file to home dir
scp data.txt user@taito.csc.fi:
# upload directory					          
scp -r data_dir user@taito.csc.fi:
```


## STAT & ENV
### Base OS info
```bash
hostname
cat /etc/os-release
hostnamectl
```

### environment
```bash
printenv									
printenv | grep VAR_NAME
echo $VAR_NAME
set PROP_NAME    # prints env variable								    
set PROP_NAME=VALUE
```

### misc
```bash
# free space on disk
df -h
# find process
ps -ef | grep <PROCESS_NAME>
# systemctl
systemctl status
systemctl list-units --type=service
systemctl list-unit-files | grep enabled
sudo systemctl start/stop/mask/unmask/enable/disable <SERVICE-NAME>
```

## Net


###  WINDOWS GIT-bash

---------------------------------------------------------------------------------------


###  LINUX
netstat -tplnu                   check port usage (win)
ss -tplnu                        socket stat
ip a                             ip addresses 

---------------------------------------------------------------------------------------

###  MAC
networksetup -listallhardwareports          list all network interfaces 
nc -vz <HOST_NAME> 7004                     check port usage (mac)

lsof -nP -iTCP:<PORT> | grep LISTEN         print used ports (macOS)
lsof -i -P | grep LISTEN                    who uses port (mac)

lsof -i -P -a -p <PID>                      Find ports used by a specific process

lsof +D <path>                              who uses file
---------------------------------------------------------------------------------------

### Useful network commands
- hostname ...
- ip
- ifconfig
- netstat
- ss
- ping
- nslookup
- traceroute
- dig: querying and troubleshoot DNS. Advanced alternative to nslookup,
- whois
- finger
- tcpdump
- nicstat:  prints out network statistics for all network interface cards (NICs)


## Useful general commands
- `chown` - change the user and/or group ownership of a given file, directory, or symbolic link.
cat, cd, cut, echo, find, grep, head, ls, sed, sort, tail, uniq, wc, xargs


## less
    * Page Up  or   b 
    * Page Down   or  space
    * G  go to the end
    * g  go to the start
    * /chars  search forward
    * n       search next match
    * h       help

source ~/.vk_profile  - applies my personal SHELL variables  
echo $SHELL  




 ## DOWNLOAD & UPLOAD   
scp user@remote_host_name:/file_path local_path_to		# download file from a remote machine

scp file_name user@remote_host_name:/path_to			# upload file to a remote machine
scp data.txt user@taito.csc.fi:							# upload file to home dir
scp -r data_dir user@taito.csc.fi:						# upload directory



## STAT & ENV
hostname 									computer name
cat /etc/os-release							OS info
hostnamectl									OS info

  ### environment
printenv									
printenv | grep VAR_NAME
echo $VAR_NAME
set PROP_NAME								prints env variable
set PROP_NAME=VALUE

df -h										free space on disk


| descr           |     linux        |     mac        |
| --------------- | ---------------- | -------------- |
| who uses file   |                  | lsof +D <path> |

                                     
ps -ef | grep <PROCESS_NAME>      find process  


 ## NET  STAT  -   LINUX
netstat -tpln | grep 7002             check port usage (win)
ip a
ss -nutlp                             socket stat


 ## NET  STAT  -    MAC
nc -vz <HOST_NAME> 7004                          check port usage (mac)

lsof -nP -iTCP:<SOME_PORT> | grep LISTEN         print used ports (macOS)
lsof -i -P | grep LISTEN                         who uses port (mac)

lsof -i -P -a -p <PID>                           Find ports used by a specific process


networksetup -listallhardwareports               list all network interfaces       
sudo tcpdump -i en0


 - netstat
 - ping
 - dig  tool for querying the Domain Name System (DNS). Retrieves information about DNS records, allows troubleshoot DNS issues, and verify DNS configurations. dig stands for "domain information groper" and is a more advanced alternative to nslookup,
  - traceroute
  - whois
  - finger



 ## Useful commands
cat, cd, cut, echo, find, grep, head, ls, sed, sort, tail, uniq, wc, xargs

**chown** - change the user and/or group ownership of a given file, directory, or symbolic link.



 ## less
    * Page Up  or   b 
    * Page Down   or  space
    * G  go to the end
    * g  go to the start
    * /chars  search forward
    * n       search next match
    * h       help
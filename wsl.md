# Basic commands for WSL

```
wsl --install ...
wsl --list --online   / wsl -l -o
wsl --list --verbose
wsl --set-default <Distribution Name>
wsl --update
wsl --status
# uninstall
wsl --unregister <DistributionName>
```

## Start / stop
```
# Start WSL in user's home
wsl ~
# Run a specific Linux distribution 
wsl --distribution <Distribution Name> --user <User Name>

# terminates all running distributions
wsl --shutdown
# terminate the specified distribution
wsl --terminate <Distribution Name>
```

## Mount/unmount a disk or device
`wsl --mount <DiskPath>`
`wsl --unmount <DiskPath>`

## Troubleshooting 
Returns the IP address of your Linux distribution installed via WSL 2 (the WSL 2 VM address)
`wsl hostname -I`

Returns the IP address of the Windows machine as seen from WSL 2 (the WSL 2 VM)
`ip route show | grep -i default | awk '{ print $3}'`

## How to access linux/Ubuntu files from Windows 10 WSL
https://superuser.com/questions/1110974/how-to-access-linux-ubuntu-files-from-windows-10-wsl

## access Windows files from WSL
`ls /mnt/c/Users/vkozak`

## access WSL files from FAR
`cd \\wsl$\Ubuntu\home\`


## прокинуть порт из wsl
```powershel
  netsh interface portproxy add v4tov4 listenport=6443 listenaddress=0.0.0.0 connectport=6443 connectaddress=172.17.244.18
```
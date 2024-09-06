https://medium.com/@saschagrunert/demystifying-containers-part-i-kernel-space-2c53d6979504
https://medium.com/@saschagrunert/demystifying-containers-part-ii-container-runtimes-e363aa378f25
https://medium.com/@saschagrunert/demystifying-containers-part-iii-container-images-244865de6fef

[Как работает сеть в контейнерах: Docker Bridge с нуля](https://habr.com/ru/articles/790212/)


[Linux Container Primitives: cgroups, namespaces, and more](https://www.youtube.com/watch?v=x1npPrzyKfs)


Main primitives that make up the core of container are: 
 -	namespaces, 
 -	control groups (cgroups)
 -	file systems

	
#	CGROUPS

CGroups do:
 -	organize all processes in the system
 -	account for resource usage and gather utilization data
 -	limit or prioritize resource utilization


The way you interact with cgroup is through *sybsystems*. The  CGroups feature of linux is really an abstract framework and the sybsystems are concrete implementation.

Examples of sybsystems:
 -	memory
 -	CPU time
 -	Block I/O
 -	Number of discrete process (pids)
 -	CPU & memory pinning
 -	Freezer (used by docker pause)
 -	Devices
 -	Network priority
 -	…

You can interact with cgroups via a virtual sybsystem
 -	it’s bunch of files but they are really just interfaces into the kernel’s data structures for cgroups
 -	typically mounted at `/sys/fs/cgroup`
 -	tasks virtual file holds all pids in the cgroup
 -	other files have settings and utilization data

In order to create new cgroup we need just create a corresponding directory in `/sys/fs/cgroup/{TARGET_SYBSYSTEM}/{NEW_CGROUP_NAME}`

If you have an arbitrary process and you want to find out which cgroups it's assigned to you can do that with the *proc* virtual file system.  
*proc* virtual filesystem allows to find out which cgroup an arbitrary process is assigned to. (use `ls /proc` command to see)  
the *proc* file system contains a directory that corresponds to each process id

```
# ls /proc
1      1284   14986  15409  27098  30945  31153  31194  31262  31299  343  37    386  403  48   568   702  847  879  901  992                      fb           modules        tty
….
```

Let’s look at process cgroups (30498 is a pid)
```
# cat /proc/30498/cgroup
11:memory:/user.slice
10:devices:/user.slice
9:freezer:/
8:blkio:/user.slice
7:perf_event:/
6:net_prio,net_cls:/
5:hugetlb:/
4:pids:/user.slice
3:cpuset:/
2:cpuacct,cpu:/user.slice
1:name=systemd:/user.slice/user-80650.slice/session-235.scope
```



In order to move a process to another cgroup we need add its pid to *tasks* file of that  cgroup
`echo {PID} | sudo tee  /sys/fs/cgroup/pids/{TARGET_CGROUP_NAME}/tasks`


#	HOW DOCKER USES CGROUPS


Let’s look of container cgroups inside
```
: ~> docker run --name demo --cpu-shares 256 -d --rm ubuntu sleep 600
2abd945f70f8eb9e6ab7483957d77a01ee25ee1c01b61ce73f61e9dd7b71c68e

: ~> docker exec demo ls /sys/fs/cgroup/cpu
cgroup.clone_children
cgroup.event_control
cgroup.procs
cpu.cfs_period_us
cpu.cfs_quota_us
cpu.rt_period_us
cpu.rt_runtime_us
cpu.shares
cpu.stat
cpuacct.stat
cpuacct.usage
cpuacct.usage_percpu
notify_on_release
tasks
``` 

Let’s look of container cgroups outside.  
Docker likes to organize the container cgroups inside a docker directory so let's look there
```
# ls /sys/fs/cgroup/cpu/docker/
2abd945f70f8eb9e6ab7483957d77a01ee25ee1c01b61ce73f61e9dd7b71c68e  cgroup.event_control  cpuacct.usage         cpu.cfs_quota_us   cpu.shares         tasks cgroup.procs          cpuacct.usage_percpu  cpu.rt_period_us   cpu.stat
cgroup.clone_children                                             cpuacct.stat          cpu.cfs_period_us     cpu.rt_runtime_us  notify_on_release
```

#	NAMESPACES
Namespaces are concerned with controlling visibility of resources and access control

is used for
 -	isolation mechanism for resources
 -	changes to resources within namespace can be invisible outside the namespace
 -	resource mapping with permission changes

What namespaces are available
 -	Network
 -	Filesystem (mounts)
 -	Processes (pid)
 -	Inter-process communication (ipc)
 -	Hostname and domain name (uts)
 -	User and group IDs
 -	cgroup

NS can be seen in *procfs* virtual filesystem (see `/proc/{PID}/ns/` directory). 
```
: ~> ls -la /proc/$$/ns
total 0
dr-x--x--x 2 testUser users 0 Oct 25 02:55 .
dr-xr-xr-x 9 testUser users 0 Oct 25 02:44 ..
lrwxrwxrwx 1 testUser users 0 Oct 25 04:50 ipc -> ipc:[4026531839]
lrwxrwxrwx 1 testUser users 0 Oct 25 04:50 mnt -> mnt:[4026531840]
lrwxrwxrwx 1 testUser users 0 Oct 25 04:50 net -> net:[4026531956]
lrwxrwxrwx 1 testUser users 0 Oct 25 04:50 pid -> pid:[4026531836]
lrwxrwxrwx 1 testUser users 0 Oct 25 04:50 user -> user:[4026531837]
lrwxrwxrwx 1 testUser users 0 Oct 25 04:50 uts -> uts:[4026531838]
```

Consider using readlink tool
```
: ~> readlink /proc/$$/ns/*
ipc:[4026531839]
mnt:[4026531840]
net:[4026531956]
pid:[4026531836]
user:[4026531837]
uts:[4026531838]
```

Files are symbolic links to the namespace
The link contains the namespace type and inode number to identify the namespace

### Creating namespaces
There are linux syscalls for creation namespaces
 - clone(2) - is for new processes to create new namespaces
 - unshare(2) - is for existing processes to create new namespaces
CLONE_NEW* flag to specify which namespaces

### Persisting namespaces
 - the kernel automatically garbage-collect namespaces by reference-counting
 - new namespace remains open as long as a process runs or a mount is open
 - bind-mount a file in `/proc/$$/ns` to another place on the filesystem. (`$ mount —bind /proc/$$/ns /var/run/netns/lfnw`)

### Entering namespaces
TODO...


#	HOW DOCKER USES NAMESPACES
```
docker run --name redis -d redis

: ~> ps ax | grep redis
27111 ?        Ssl    0:00 redis-server *:6379
27261 pts/1    S+     0:00 grep --color=auto redis

: ~> sudo readlink /proc/27111/ns/net
net:[4026532678]
```



Linux Performance Troubleshooting Demos   https://www.youtube.com/watch?v=rwVLa9me7e4

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/performance_tuning_guide/sect-red_hat_enterprise_linux-performance_tuning_guide-performance_monitoring_tools-built_in_command_line_tools


## GENERAL

 - **ps**  - It captures a snapshot of a select group of active processes. By default, the examined group is limited to processes that are owned by the current user and associated with the terminal where the *ps* command is executed.
 - **System activity reporter (sar)** is provided by the *sysstat* package. It collects and reports information about system activity that has occurred so far on the current day.
 - **perf** - uses hardware performance counters and kernel trace-points to track the impact of other commands and applications on a system.


## CPU

 - **vmstat**   (only Linux). Virtual memory statistics. provides instant reports of your system’s processes, memory, paging, block input/output, interrupts, and CPU activity.
```
 ~> vmstat 1
procs -----------memory-------------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd     free   buff    cache   si   so    bi    bo   in   cs us sy id wa st
 0  0      0 49593012   9436 11005800    0    0     1     9   13   13  1  1 98  0  0
 0  0      0 49592856   9436 11005828    0    0     0     0 1008 1182  1  1 99  0  0
 0  0      0 49592864   9436 11005828    0    0     0    84 1299 1465  1  2 97  0  0
 1  0      0 49593072   9436 11005828    0    0     0     0 1104 1285  1  0 99  0  0
```

- **top**   gives a dynamic view of the processes in a running system. It displays a variety of information, including a system summary and a list of tasks currently being managed by the Linux kernel.

- **mpstat**


## Memory

- top -o %MEM
- pmap -x <PID>                                 - shows memory regions
- jmap -dump:format=b,file=heap.hprof <PID>     - create memory dump. Then memory dump can be analised via MAT, VisualVM or jhat tools


jcmd PID GC.class_histogram

jmap -histo PID

jmap -histo:live <APP_PID>

jhsdb jmap --exe <JAVA_HOME>/bin/java --core <CORE_DUMP> --histo


## Disk

- **iostat**  
```
: ~> iostat -xm 5
Linux 3.10.0-1160.71.1.el7.x86_64 (h0001066) 	08/17/2022 	_x86_64_	(4 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.06    0.04    0.51    0.11    0.00   98.28

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
fd0               0.00     0.00    0.00    0.00     0.00     0.00     8.00     0.00   40.90   40.90    0.00  40.91   0.00
sda               0.00     0.05    0.08    1.03     0.00     0.01    17.87     0.01    6.41    7.51    6.33   0.69   0.08
sdb               0.00     0.12    0.14    2.01     0.00     0.03    29.67     0.01    3.40   15.08    2.62   2.17   0.47
dm-0              0.00     0.00    0.02    0.11     0.00     0.00    31.74     0.00    7.14   10.41    6.51   1.80   0.02
dm-1              0.00     0.00    0.00    0.00     0.00     0.00    42.76     0.00    3.85    3.85    0.00   3.67   0.00
dm-2              0.00     0.00    0.14    2.13     0.00     0.03    28.08     0.01    3.49   15.11    2.75   2.06   0.47
dm-3              0.00     0.00    0.00    0.01     0.00     0.00    17.20     0.00    3.36    3.90    3.31   1.57   0.00
dm-4              0.00     0.00    0.05    0.94     0.00     0.01    14.45     0.01    6.40    6.77    6.38   0.57   0.06
dm-5              0.00     0.00    0.01    0.01     0.00     0.00    59.62     0.00    7.59    6.78    8.13   2.73   0.00
dm-6              0.00     0.00    0.00    0.00     0.00     0.00     8.62     0.00    3.25    3.26    2.71   3.13   0.00
```


- **dd**   -  disk write speed test
```
$ dd if=/dev/zero of=/tmp/test1.img bs=1G count=1 oflag=dsync
1+0 records in
1+0 records out
1073741824 bytes (1.1 GB) copied, 4.79565 s, 224 MB/s
```


## Network

- **nicstat** 






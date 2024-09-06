
## View processes
For viewing processes in the GUI, Activity Monitor is the primary tool. It can also view other per-process things like memory usage, and disk and network activity (and it also gives some overall stats at the bottom of the window). You can also view open files and network ports for processes you own by selecting them, and clicking the Inspect (circle-with-an-"i"-in-it) button in the toolbar, then selecting the Open Files and Ports tab. And it can kill (force-exit) running programs.

At the command line, top is my favorite tool. I use    `top -u -s5` to show top CPU-using processes (updated every 5 seconds, because the default of 1 second is too fast). top -orsize will show top "real memory" usage instead. And it shows overall stats at the top of the screen. ps is the other main tool; by default, it only shows your command-line processes, so use ps -A (or -ax or -e) to show all processes. Check the man page for lots more options. You can use kill to kill processes by PID, or killall to kill them by name (/program). (Warning: on some other OSes, killall does different, and much more lethal, things, so think before you type.)

A lot of the process management in macOS (especially running background processes) is handled by *launchd*, and you can query and manage it from the command line with *launchctl* (warning: this can be a bit confusing). Apple doesn't provide a GUI for interacting with this, but there is a third-party option: LaunchControl from soma-zone.

## Memory 
since that's pretty much used by processes, use the process monitoring tools to see what's going on. You can get some whole-system virtual memory stats from *vm_stat* (warning: these stats are in pages, not KB or MB or anything like that) or *sysctl vm.swapusage* (or if you want to drink from the firehose, sysctl -a vm). Memory management is thoroughly automated, so there aren't really any tools to configure it.

## Disks: 
Disk Utility is the GUI tool of choice, both to see how things are formatted and to make changes (erase/format/partition/etc). Recent versions hide some of the complexity of what's going on, which I find just makes it more confusing; to show full info, choose "Show All Disks" from the View menu (or the View pop-up in the toolbar). At the command line, diskutil is its counterpart.

## Files: 
*df* to show which volumes are getting full (`df -h` for human-readable sizes), and *du* to see how much space is used by each subfolder (and subsubfolder and...) (I mostly use `sudo du -xhd1 /path/to/folder` to give a human-readable listing that only goes one folder level deep). Note that you'll need to grant the Terminal Full Disk Access to let its commands see into "private" areas of the filesystem.

## File activity,
in addition to Activity Monitor, you can use *lsof* to get a (huge) snapshot of which files are open (it las lots of flexible -- and confusing -- options), and *fs_usage* to get an (extremely detailed) running log of file accesses.

You can use *iostat* to look at I/O throughput per device (mostly disk access).

# Network I/O
use the per-process tools above (and sudo `lsof -i` to see open network ports). To view and change the network connection settings, use the System Preferences -> Network pane and its command-line counterpart networksetup. For detailed network status, use the Network Utility, netstat, and ifconfig.


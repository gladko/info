## Common macOS Commands
Below are some common macOS commands, organized by general function. Bookmark this page so you can refer back to it often. Although most options to these commands are identical between Linux and macOS, be sure to view the manual page for commands that you will use in the future.

### System Documentation Commands in macOS
man Displays/searches the manual page database
apropos Searches the manual page database by keyword
info Displays/searches the info page database
help Displays help on BASH functions


### File Management Commands in macOS

pwd Displays the current directory
cd Changes the current directory
ls Lists files
file Displays file type
locate Finds files using a predefined database
which Searches the PATH variable for files
find Finds files on the filesystem based on certain criteria
cp Copies files and directories
mv Moves/renames files and directories
rm Removes files and directories
rmdir Removes empty directories
mkdir Creates empty directories
ln Creates hard links; the –s option is used to create symbolic links
chown Changes ownership for files and directories
chgrp Changes group ownership for files and directories
chmod Changes the permissions (mode) on files and directories
umask Changes the UMASK variable used to determine default permissions

### Text Tools in macOS
cat Views (concatenates) the contents of text files to the terminal screen
more Views the contents of text files page by page
less Views the contents of text files page by page with advanced text features
head Displays the beginning of a text file
tail Displays the end of a text file
sort Sorts lines in text files
wc Counts the number of lines, words and characters in a text file
grep Searches text files for regular expressions
egrep Searches text files for regular expressions (including extended ones)
sed Edits text files using search-and-replace functions
awk Edits and formats text using predefined functions
·  vi (vim) The vi text editor (common to all UNIX systems)
emacs The GNU Emacs text editor
· nano A small easy-to-use text editor based on the UNIX pico editor


### Filesystem Administration in macOS
mount Mounts a filesystem to a mount point directory – alternatively, you can use the mount_filesystem commands (where filesystem is the name of an appropriate filesystem) – see man mount for details.
umount Unmounts a filesystem from a mount point directory
pdisk May be used to create Apple disk partitions
newfs_type Creates a new filesystem on a device (type = apfs, hfs, udf, exfat, msdos)
fuser Determines the users accessing a certain file, directory or terminal
df Displays disk free space by filesystem
du Displays disk free space by directory
quota Displays quotas for a certain user
edquota Edits user quotas
repquota Displays a report on quotas by user
quotacheck Updates quota limits on the filesystem

Disk quotas are configured differently in macOS. In Linux, you enable quotas using the appropriate option in /etc/fstab. However, /etc/fstab is not available in macOS. Instead, you must create two files in the root of the filesystem that you wish to enable quotas on (.quota.ops.user and .quota.ops.group).

### Shutdown and System State in macOS
shutdown Shuts down or reboots the system at a specified time
halt Shuts down the system immediately
reboot Reboots the system immediately


### Compression, Backup and Software in macOS
compress Compresses files using a Lempel-Ziv algorithm
gzip Compresses files using a standard Lempel-Ziv algorithm
bzip2 Compresses files using a block-sorting algorithm
tar Used to create small tar archives and tarballs
cpio Used to create full filesystem backups using a variety of options
make Manages software compiling using gcc and Makefile settings
gcc The GNU C compiler used to compile software


## BASH Management in macOS
As in Linux, macOS stores its variables in environment files. The /etc/profile and /etc/bashrc files are used by default on the system. Each user can also create their own ~/.bash_profile and ~/.bashrc files. In addition, ~/.bash_logout may be used to perform tasks at shell exit. Here are more BASH management commands for macOS.

set Displays all variables in your shell
env Displays exported variables in your shell
alias Creates special alias variables
unalias Removes special alias variables
export Creates and exports variables
ulimit Sets BASH limits for users (e.g., maximum number of user processes)

### Process Management in macOS
ps Displays system and user processes (supports BSD-style options only)
top Displays top processes and system statistics
kill Sends kill signals to processes by process identification number (PID)
killall Sends kill signals to processes by name
jobs Displays background processes
fg Moves a background process to the foreground
bg Moves a foreground process to the background
nice Changes the priority of a process as it is started
renice Changes the priority of a running process
at Schedules commands to run at a later time
atq Views at jobs
atrm Removes an at job
crontab Edits user cron tables (used to repetitively schedule commands)


### User and Group Administration in macOS
User and group administration differs slightly in macOS from Linux. There are no useradd or userdel commands. Instead, you must use the System Preferences utility to create user accounts properly. User information is stored in a directory database under the /var/db directory. The /etc/shadow file does not exist and the /etc/passwd and /etc/group files exist only to provide information to apps.

whoami Displays the current user name
who am i Displays your username and computer information
groups Displays the current user’s group memberships
id Prints the User ID (UID) and Group IDs (GIDs) for the current user
chfn Changes the user description used by the finger command
finger Displays user description information
chsh Changes the shell for a user account
passwd Changes the password for the current user (the root user may change other user's passwords by specifying the username as an argument)
who Displays who is on the system
w Displays who is on the system and what they are doing

### Common Unix Printing System (CUPS) Printing in macOS
lp Prints a file (lpr is supported for BSD compatibility)
lpstat Views print jobs and printer status (lpq and lpc are supported for BSD
compatibility)
cancel Removes a print job from the print queue (lprm is supported for BSD
compatibility)
cupsaccept Allows jobs to enter a print queue
cupsreject Prevents jobs from entering a print queue
cupsenable Allows jobs to be sent to the printer from the print queue
cupsdisable Prevents jobs from leaving the print queue

### Network- and Security-related Commands in macOS
Network devices have different names in macOS. The first ethernet adapter is called en0 (typically wired ethernet), and the second is called en1 (typically wireless ethernet). Ensure that you use System Preferences to change any network parameters, as they are not stored in text files as they are on Linux systems. For example, the /etc/resolv.conf file still exists in macOS and lists DNS servers configured in System Preferences, but it is not used by the system – it is merely there in case an app queries it. The only network-related file that is used actively and may be edited is /etc/hosts (for local host name resolution). Here are more network- and security-related commands in macOS.


ifconfig Displays and configures TCP/IP network interfaces
ping Tests connectivity between hosts
whois Queries domain name registration information
arp Views and manages the address resolution protocol (ARP) cache
netstat Views TCP/IP network statistics and the routing table
route Manages the TCP/IP routing table
traceroute Traces an IP packet across routers
hostname Sets the system host name
host Resolves host names to IP addresses and vice versa
nslookup Resolves host names to IP addresses and vice versa
dig Resolves host names to IP addresses and vice versa
su Switches your user account to another account
sudo Performs tasks as another user via entries in the /etc/sudoers file
last Displays a detailed list of previous user logins
tcpdump Captures packets on a network interface


### System and Miscellaneous Commands in macOS
date Displays the current date and time
exit Exits out of the shell (logout)
echo argument Displays the argument to the terminal screen
clear Clears the screen
uname option Displays system information specified by the option; –a specifies all information
uptime Lists system statistics and uptime
cal Lists the calendar for the current month
banner Prints an ASCII banner
iostat Displays input/output (I/O) statistics for the system
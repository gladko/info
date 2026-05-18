
## Remote SSH into Android 

    Install Termux from Github (or F-Droid) on the phone you want to SSH into. Don't use the Play Store version, it doesn't work

    run pkg update and pkg upgrade

    run passwd and set up a password

    run pkg install openssh

    run ssh-keygen -A

    run termux-setup-storage - This will make the app ask for storage permission

    run sshd

You now have an SSH server running on your device. To connect, in your desired terminal/SSH client run

    ssh <tailscaleip> -p8022

It should ask you for your password, enter it. If your client doesn't allow you to not enter a username, just use a blank space or asterisk.

Congratulations, you are now connected Android > Android.

Just note that external storage is difficult to figure out (you need the actual mount folder name and then you need to cd into it.)

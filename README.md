LinkStation Kit
=============================================================================

This is a small utility collection to handle LinkStation.
You can

-   Enable SSH connection via `acp_commander.jar`
-   Create/Delete LinkStation user in SSH connection
-   Create/Delete LinkStation group in SSH connection
-   Create/Delete LinkStation share (Share drive) in SSH connection
-   Generate new random password (Standalone `mkpasswd` like python script)

**USE THIS UTILITY COLLECTION WITH YOUR OWN RESPONSIBILITY**

How to enable SSH in LinkStation
-----------------------------------------------------------------------------
You can controll your LinkStation with `acp_commander.jar` with the command below

    java -jar acp_commander.jar -t IP -ip IP -pw ADMIN

`IP` is a IP address of LinkStation which you can find with `nmblookup` command
and `ADMIN` is a password of `admin` in Web interface

Basically the SSH connection in LinkStation is disable because

-   `root` user does not have password (actually it has but we don't know)
-   `PermitRootLogin` is `no` in `/etc/sshd_config`

So what you need to do is setting new `root` password and modify
`/etc/sshd_config` to enable `root` login. To do this, use the `enable_ssh.sh`
in `start` directory like

    ./start/enable_ssh.sh <IP_ADDR>

Run `./start/enable_ssh.sh` to see more detail about this utilities.


How to enable LinkStation Kit
-----------------------------------------------------------------------------
First, you have to enable your local bin directory. To do that, follow the
commands in LinkStation

    echo 'export PATH="$HOME/bin:$PATH"' >> $HOME/.bash_rc
    mkdir $HOME/bin

And then, copy the tools in `tools` directory with the following commands.
(Execute the commands in host PC)

    scp tools/* root@<IP_ADDR>:/root/bin/

Now you can use the following commands in your LinkStation

-   `lsadduser`
-   `lsaddgroup`
-   `lsaddshare`
-   `lsdeluser`
-   `lsdelgroup`
-   `lsdelshare`
-   `mkpasswd`

Run each script to see more detail.

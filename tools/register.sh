#!/bin/bash
PASSWD=passwd
GROUP="labmem"

# Create Group
lsaddgroup $GROUP

while read username; do
    password=`./bin/mkpasswd -l 10 -s 0`
    # username should not contain some characters
    username=`echo $username | tr '\\/:*?"<>| .' '__\-___()__\-'`
    # username should be lowercase
    username=`echo $username | tr 'A-Z' 'a-z'`
    # add new LinkStation user
    lsadduser -p $password -G $GROUP $username
    # add new LinkStation share for the User
    lsaddshare -w $username $username

    # output result
    echo "$username, $password" >> $PASSWD
done < usernames

# Restart Samba
/etc/init.d/smb.sh restart

echo "Username and Password was saved in '$PASSWD'"

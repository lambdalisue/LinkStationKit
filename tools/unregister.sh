#!/bin/bash
GROUP="labmem"

echo "*** WARNING **************************************************"
echo
echo "This script will remove all users, shares."
echo
echo "**************************************************************"
echo
echo "Are you sure that you want to continue? [y/N]"

read response

if [ "$response" != "y" ]; then
    echo "Process are canceled by user"
    exit 0
fi

while read username; do
    # username should not contain some characters
    username=`echo $username | tr '\\/:*?"<>| .' '__\-___()__\-'`
    # username should be lowercase
    username=`echo $username | tr 'A-Z' 'a-z'`
    # add new LinkStation user
    lsdeluser $username
    # add new LinkStation share for the User
    lsdelshare $username
done < usernames

lsdelgroup $GROUP

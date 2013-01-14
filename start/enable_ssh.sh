#!/bin/bash
#=========================================================================
#
# Enable SSH in LinkStation
#
# Author:   lambdalisue
# URL:      http://hashnote.net/
# Date:     2013.01.14
#
#=========================================================================

# --- Default ------------------------------------------------------------
ACP_COMMANDER='acp_commander.jar'
ADMIN='password'
# ------------------------------------------------------------------------

CMDNAME=`basename $0`
USAGE="Usage: $CMDNAME [-a ADMIN] [-r ROOT] [-c ACP_COMMANDER (Default: acp_commander.jar)] LINK_STATION_ADDR"
USAGE=`cat << EOT
$USAGE
Enable SSH connection to LinkStation (LINK_STATION_ADDR)
It use 'acp_commander.jar' to handle LinkStation. You can download it at

    http://sourceforge.jp/projects/sfnet_linkstationwiki/

Arguments:
LINK_STATION_ADDR       IP Address of target Link Station (Require)

Options:
    -a      Password of admin user in Web interface (Default: password)
    -r      Password of root user in SSH connection
    -c      The path to 'acp_commander.jar' (Default: acp_commander.jar)
EOT`

# parse option arguments
while getopts a:r:c: flag; do
    case $flag in
        "a" ) ADMIN="$OPTARG" ;;
        "r" ) ROOT="$OPTARG" ;;
        "c" ) ACP_COMMANDER="$OPTARG" ;;
        * ) echo $USAGE 1>&2
            exit 1 ;;
    esac
done
            
# remove option arguments
shift `expr $OPTIND - 1`

# get HOST_ADDR from argument
HOST=$1

# is HOST_ADDR specified?
if [ "$HOST" = "" ]; then
    echo $USAGE 1>&2
    exit 1
fi

# is ROOT PASSWORD specified?
if [ "$ROOT" = "" ]; then
    password1=''
    password2=''
    shortest=5
    # trap Ctrl-C and make `stty echo` to visualize keyboard input
    trap "stty echo; exit 1" 2
    while : ; do
        # hide keyboard input for security
        stty -echo
        echo -n "New Password: "
        read password1
        echo
        echo -n "Retype new Password: "
        read password2
        echo
        if [ ${#password1} -lt $shortest -o ${#password2} -lt $shortest ]; then
            echo "Password should be longer than $shortest characters"
            continue
        fi
        if [ "$password1" = "$password2" ]; then
            ROOT=$password1
            break
        else
            echo "Passwords do not match."
        fi
    done
    stty echo
fi

CALL="java -jar $ACP_COMMANDER -t $HOST -ip $HOST -pw $ADMIN -c"

# set password to enable `root` account
echo "=== Enable root account ============================================="
$CALL "(echo $ROOT; echo $ROOT) | passwd"

# enable ssh
echo "=== Enable SSH ======================================================"
$CALL "sed -i 's/UsePAM yes/UsePAM no/g' /etc/sshd_config"
$CALL "sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/sshd_config"

# restart sshd
echo "=== Restart SSH daemon =============================================="
$CALL "/etc/init.d/sshd.sh restart"

#!/usr/bin/env bash

# This script handles mounting the Windows-side $USERPROFILE/.ssh/ folder to the WSL Linux side $HOME/.ssh/ folder.
#
# Note: This script assumes that the USERPROFILE environment variable has been mapped over using WSLENV.

# Grab some default values to use (if none supplied as arguments)
LOGNAME=$(logname)
WSL_USERID=$(id -u $LOGNAME)
WSL_GROUPID=$(id -g $LOGNAME)

# Allow arguments to override defaults here
FSTAB_UID="${1:-$WSL_USERID}"
FSTAB_GID="${2:-$WSL_GROUPID}"

# Finally generate the FSTAB entry
FSTAB_ENTRY="${USERPROFILE}\.ssh\ ${HOME}/.ssh/ drvfs rw,noatime,uid=${FSTAB_UID},gid=${FSTAB_GID},case=off,umask=0077,fmask=0177 0 0"

case `grep -Fx "$FSTAB_ENTRY" /etc/fstab >/dev/null; echo $?` in
  0)
    echo "/etc/fstab entry already exists. Skipping..."
    ;;
  1)
    echo "/etc/fstab entry does not exist. Appending..."
    echo $FSTAB_ENTRY >> /etc/fstab
    ;;
  *)
    echo "An error occurred while dealing with /etc/fstab. Aborting..."
    ;;
esac

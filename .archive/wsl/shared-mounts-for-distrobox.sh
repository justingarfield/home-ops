#!/usr/bin/env bash

# Only allow script to run as root
#
# Derived from https://github.com/pia-foss/manual-connections/blob/master/run_setup.sh
if (( EUID != 0 )); then
  echo -e "\n${red}This script needs to be run as root. Try again with:\n\nsudo $0\n${nc}"
  exit 1
fi

sudo mount --make-shared /
sudo mount --make-shared /dev
sudo mount --make-shared /sys

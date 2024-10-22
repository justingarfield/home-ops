#!/bin/bash

echo $(date -u) "Mounting WSL disks"

task_name="MountWSLDisks"
windows_sys_path="/mnt/c/Windows/system32"
task_command="schtasks.exe /run /tn"
timeout=30
interval=1
target_drive_uuid="<uuid>"
mapper_device="wsl-data-ssd"
mount_point="/mnt/wsl-data-ssd"
key_file="/etc/luks-keys/wsl-data-ssd-key"

$windows_sys_path/$task_command "$task_name"

elapsed=0
while ! blkid --uuid $target_drive_uuid; do
  if [ $elapsed -ge $timeout ]; then
    echo $(date -u) "Timed out waiting for $target_drive_uuid to be ready."
    exit 1
  fi

  echo $(date -u) "Waiting for $target_drive_uuid to be ready..."
  sleep $interval
  elapsed=$((elapsed + interval))
done

target_drive=$(blkid --uuid $target_drive_uuid)
echo $(date -u) "Drive $target_drive ($target_drive_uuid) is ready"

cryptsetup -v luksOpen $target_drive $mapper_device --key-file=$key_file
mount /dev/mapper/$mapper_device $mount_point && echo $(date -u) "Mounted $target_drive as $mount_point"

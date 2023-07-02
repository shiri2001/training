#!/bin/bash
# This script's purpose is to mount EBS volume to VM.
VOLUME_PATH=$1
# Checks whether volume is already mounted.
if grep -qs $VOLUME_PATH /proc/mounts; then
    echo "Volume already mounted."
else
    echo "Volume not mounted yet. mounting...."
fi

# Mounting volume
mkfs -t xfs /dev/xvdf
mkdir -p $VOLUME_PATH
mount /dev/sdh $VOLUME_PATH

# Check if mounted successfully.
if [ $? -eq 0 ]; then
    echo "Volume mounted."
else
    echo "Mounting failed."
fi

# Error handling
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}


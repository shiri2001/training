#!/bin/bash
# This script's purpose is to mount EBS volume to VM.

# Checks whether volume is already mounted.
if grep -qs $1 /proc/mounts; then
    echo "Volume already mounted."
else
    echo "Volume not mounted yet. mounting...."
fi

# Mounting volume
mkfs -t xfs /dev/xvdf
mkdir -p $1
mount /dev/sdh $1

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


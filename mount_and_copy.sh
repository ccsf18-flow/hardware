#!/bin/bash
set -euo pipefail

if [[ -z $1 ]]
then
  exit 1
fi

udisksctl mount -b $1
dirname=$(mount | grep $1 | cut -d ' ' -f 3)
echo Copying to $dirname
rsync --checksum -r ./build/E3-0.4-H200-B60/ $dirname
udisksctl unmount -b $1
sync

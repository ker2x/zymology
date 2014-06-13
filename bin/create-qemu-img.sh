#!/usr/bin/env bash

#echo "another placeholder"

platform=`uname`
case "${platform}" in
  Darwin)
    dd if=/dev/zero of=bmfs.image bs=1m count=128
    ;;
  *)
    dd if=/dev/zero of=bmfs.image bs=1M count=128
    ;;
esac

./bin/bmfs bmfs.image format /force

dd if=bootloader/Pure64/bmfs_mbr.sys of=bmfs.image bs=512 conv=notrunc
dd if=bootloader/Pure64/pure64.sys of=bmfs.image bs=512 seek=16 conv=notrunc


# Stole the code from Baremetal
#cd bin
#echo Writing Pure64+Software
#cat pure64.sys kernel64.sys > software.sys
#dd if=software.sys of=bmfs.image bs=512 seek=16 conv=notrunc

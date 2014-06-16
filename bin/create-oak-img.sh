#!/usr/bin/env bash

#echo "another placeholder"

echo "create empty disk"
platform=`uname`
case "${platform}" in
  Darwin)
    dd if=/dev/zero of=bmfs.image bs=1m count=128
    ;;
  *)
    dd if=/dev/zero of=bmfs.image bs=1M count=128
    ;;
esac

echo "format disk"
./bin/bmfs bmfs.image format /force

echo "write MBR"
dd if=bootloader/Oak64/bin/mbr.sys of=bmfs.image bs=512 conv=notrunc

#echo "write bootloader + kernel"
#cat bootloader/Pure64/pure64.sys src/kernel.sys > os.sys
#dd if=os.sys of=bmfs.image bs=512 seek=16 conv=notrunc
#dd if=bootloader/Pure64/pure64.sys of=bmfs.image bs=512 seek=16 conv=notrunc

# Stole the code from Baremetal
#cd bin
#echo Writing Pure64+Software
#cat pure64.sys kernel64.sys > software.sys
#dd if=software.sys of=bmfs.image bs=512 seek=16 conv=notrunc

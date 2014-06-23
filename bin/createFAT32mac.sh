#!/usr/bin/env bash

rm fat32.dmg
hdiutil create -size 50m -fs MS-DOS -volname fat32 fat32
dd if=bootloader/Oak64/bin/mbr.sys of=fat32.dmg bs=432 conv=notrunc

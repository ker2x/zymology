#!/usr/bin/env bash

echo "This script will be used to run a qemu zymology image"

# Stole the code from baremetal
qemu-system-x86_64 -vga std -smp 8 -m 256 -drive id=disk,file=bmfs.image,if=none -device ahci,id=ahci -device ide-drive,drive=disk,bus=ahci.0 -name "Zymology OS" -net nic,model=i82551


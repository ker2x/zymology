BIOS
----

-  Power up
-  Bios POST
-  The CPU is in 16 bit real mode
-  Bios load the first valid MBR it can find
-  Load the MBR at 0x7C00 and jump to it

MBR ( bootloader/Oak64/src/boot/mbr.asm )
------------------------------------------------------

-  0x7C00
-  Relocate MBR to 0x0600
-  Disable interupt, clear registers, set stack pointer, enable interupt

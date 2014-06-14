BIOS
----

-  Power up
-  Bios POST
-  The CPU is in 16 bit real mode
-  Bios load the first valid MBR it can find
-  Load the MBR at 0x7C00 and jump to it

MBR ( bootloader/Pure64/src/bootsectors/bmfs_mbr.asm )
------------------------------------------------------

-  Disable interupt, clear registers, set stack pointer, enable interupt
-  Use "INT 13h AH=42h: Extended Read Sectors From Drive" to load the Pure64 bootloader to 0x8000
-  Jump to 0x8000 ( Pure64 bootloader )

BOOTLOADER ( bootloader/Pure64/src/pure64.asm )
-----------------------------------------------

-  Disable interupt, clear registers, set stack pointer, enable interupt
-  Jump to start16 and jump to clearcs (why?)
-  Configure serial port, screen
-  Check cpuid for 64 bit support
-  Init ISA

INIT ISA ( bootloader/Pure64/src/init/isa.asm )
-----------------------------------------------

-  Clear memory for E820 map


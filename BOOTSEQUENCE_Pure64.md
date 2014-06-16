BIOS
----

-  Power up
-  Bios POST
-  The CPU is in 16 bit real mode
-  Bios load the first valid MBR it can find
-  Load the MBR at 0x7C00 and jump to it

MBR ( bootloader/Pure64/src/bootsectors/bmfs_mbr.asm )
------------------------------------------------------

-  0x7C00
-  Disable interupt, clear registers, set stack pointer, enable interupt
-  Use "INT 13h AH=42h: Extended Read Sectors From Drive" to load the Pure64 bootloader to 0x8000
-  Jump to 0x8000 ( Pure64 bootloader )

BOOTLOADER ( bootloader/Pure64/src/pure64.asm )
-----------------------------------------------

-  0x8000
-  Disable interupt, clear registers, set stack pointer, enable interupt
-  Jump to start16 and jump to clearcs (why?)
-  Configure serial port, screen
-  Check cpuid for 64 bit support
-  Init ISA (0x8205)

INIT ISA ( bootloader/Pure64/src/init/isa.asm )
-----------------------------------------------

-  0x8205
-  Clear memory for E820 map
-  ???
-  Return to bootloader

BOOTLOADER ( bootloader/Pure64/src/pure64.asm )
-----------------------------------------------

-  0x81D1
-  Hide hardware cursor
-  Load GDT
-  Set protected mode bit
-  Jump to 8:Start32 (8:0x8370), we're now in protected mode


START32 ( bootloader/Pure64/src/pure64.asm )
--------------------------------------------


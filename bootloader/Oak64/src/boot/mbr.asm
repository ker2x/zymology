; ============================================
; Copyright (C) 2014 Laurent "ker2x" Laborde
;
; MBR for the Oak64 bootloader
;
; Some documentation
; http://wiki.osdev.org/MBR
; http://wiki.osdev.org/Memory_Map_(x86)
;
; ============================================


; List of guaranteed usable memory
; --------------------------------
;
; 0000:0500 -> 0007:7BFF (almost 30KiB)
; 0000:7E00 -> 007F:FFFF (480.5KiB)

; List of usefull memory (partially useable)
; ------------------------------------------
;
; 0000:0000 -> 0000:03FF : Real Mode IVT
; 0000:0400 -> 0000:04FF : BDA
; 0000:7C00 -> 0000:7DFF : MBR (this code)
; 0008:0000 -> 0009:FBFF : May be used by EDBA (depending of EDBA size)
; 0009:FC00 -> 0009:FFFF : EBDA
; 000A:0000 -> 000F:FFFF : VRAM, ROM, ... unuseable

; We're in 16bit Real Mode
USE16

; MBR is loaded at 0x7C00 but we use 0x0600 because it will be the address after relocation
ORG 0x0600

relocate:
	; First stuff we need to do is relocate the mbr at 0600
	; use MOVSW to copy DS:SI to ES:DI
	;xchg bx, bx	; Bochs magic debug
	xor ax, ax
	mov es, ax
	mov ds, ax
	mov si, 0x7C00 	; copy from 0x7C00
	mov di, 0x0600	; copy to ES:0x0600
	mov cx, 0x0100  ; copy 256 world (512 bytes) to ES:DI (0000:0600)
	repnz movsw 
	jmp 0x0000:relocated

; We copied the MBR from 0x7C00 to 0x0600 and jumped to "relocated" relative to 0x0600
; (So we jumped at 0x0600 + the size of the code above)
relocated:
	cli		; Disable interrupts
	xor ax, ax	; clear registers
	mov ss, ax
	mov es, ax
	mov ds, ax
	mov sp, 0x8000	; move the stack pointer below 0x0600
	sti		; Enable interrupts

	mov [DriveNumber], dl	; Since the data area is relative to ORG 0x0600 we couldn't do that before
				; it would have been overwritten by the 512 byte copy of 0x7C00 
	
	; enable A20 line
	; If there is an error, the CF will be set, and the error code will be in AH. 
	; On success, the CF is clear, and AH==0. 
	; Specifically, AH==0x86 means the function is not supported, and you will have to use another method.
	mov ax, 0x2401
	int 0x15

	; 80x25 video mode
	mov ax, 0x003
	int 0x10

	; Disable blinking
	;mov ax, 0x1003
	;mov bx, 0x0000
	;int 0x10
	


	xchg bx, bx	; Bochs magic debug


; BMFS Disk layout
; ----------------
;
; The first and last disk blocks are reserved for file system usage. All other disk blocks can be used for data.
;
; Block 0: (2MiB)
; ---------------
;   0x0000 -> 0x0FFF : System (4096B)
;     - 0x0000 -> 0x01FF : Legacy (512B)
;     - 0x0200 -> 0x03FF : Free space (512B)
;     - 0x0400 -> 0X05FF : BMFS marker (512B)
;     - 0x0600 -> 0x0FFF : Free space (2560B)
; 
;   0x1000 -> 0x1FFF : Directory  (4096B) 
;     - Directory (Max 64 files, 64-bytes for each record)
; 
;   0X2000 -> 0x1FFFFF : Free (2MiB - 4Kib)
;     - The remaining space in Block 0 is free to use.
;     - Will be used for BootLoader (at 0x2000)
;     - Immediatly followed by the kernel 
;     - (the kernel could also be a regular file anywhere on the disk but less than 2MiB is enough for everyone ;) )
;
; Block 1 .. n-1:
; ---------------
; Data
;
; Block n (last block on disk)
; ----------------------------
; Copy of Block 0
;
;
; Directory Record structure
; --------------------------
; 
; Filename (32 bytes) - Null-terminated ASCII string
; Starting Block number (64-bit unsigned int)
; Blocks reserved (64-bit unsigned int)
; File size (64-bit unsigned int)
; Unused (8 bytes)
; A file name that starts with 0x00 marks the end of the directory. 
; A file name that starts with 0x01 marks an unused record that should be ignored.

; Notes
; -----
; When using bmfs initialize : 
;   - MBR is at offset 0
;   - Bootloader is at offset 8192 (0x2000)
;   - The kernel must immediatly follow the bootloader

; Load the first stage of the bootloader from disk (0x2000)


hang:
	hlt
	jmp hang


; DATA
DriveNumber db 0x00

; MBR padding and signature
times 510-$+$$ db 0 
sign dw 0xAA55

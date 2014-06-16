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


; MBR is loaded at 0x7C00 but we use 0x0600 because it will be the address after relocation

USE16
ORG 0x0600

relocate:
	; First stuff we need to do is relocate the mbr at 0600
	; use MOVSW to copy DS:SI to ES:DI
	xchg bx, bx	; Bochs magic debug
	xor ax, ax
	mov es, ax
	mov ds, ax
	mov si, 0x7C00 	; copy from 0x7C00
	mov di, 0x0600	; copy to ES:0x0600
	mov cx, 0x0100  ; copy 256 world (512 bytes) to ES:DI (0000:0600)
	repnz movsw 
	jmp 0x0000:relocated

relocated:
	cli		; Disable interrupts
	xor ax, ax	; clear registers
	mov ss, ax
	mov es, ax
	mov ds, ax
	mov sp, 0x0600	; move the stack pointer below 0x0600
	sti		; Enable interrupts
	mov [DriveNumber], dl
	push sp
	xchg bx, bx
	

; TODO
; 

hang:
	jmp hang


; DATA
DriveNumber db 0x00

; MBR padding and signature
times 510-$+$$ db 0 
sign dw 0xAA55

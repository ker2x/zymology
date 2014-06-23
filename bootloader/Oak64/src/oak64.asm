; First stage of the bootloader

USE16
ORG 0x00008000

start:

	; Clear registers, again
	cli
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor esi, esi
	xor edi, edi
	xor ebp, ebp
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov fs, ax
	mov gs, ax
	mov esp, 0x8000	; set stack pointer, again
	sti
	
	; Print a friendly greetings :)
	mov si, msg_hello
	call print16

	; Now... Let's clear some more stuff left by the MBR
	; Wipe 0500->7BFF
	; Wipe 7C00->7DFF
	mov si, msg_wipe
	call print16
	mov edi, 0x00000500	; from 0x500
	xor eax, eax		; write 0 (yes, it's useless, eax is already 0)
	mov ecx, 0x7900		; 30463 + 512 + 1 times
	rep stosb		; stosb and not stosd (yes, i did it, it wiped A LOT more than expected :D)
	mov si, msg_done
	call print16

	; Memory map
	; ----------
	; 0000:0000 -> 0000:04FF : Here be dragon !
	; 0000:0500 -> 0000:7DFF : free and zero'd
	; 0000:???? -> 0000:7FFF : stack
	; 0000:8000 -> 0000:FFFF : bootloader
	; 0001:0000 -> 00EF:FFFF : free (kernel will be loaded at 0001:0000)

	; Memory detection (using e820)
	mov si, msg_e820
	call print16
	
	; TODO

	;mov si, msg_done
	;call print16
	



hang:
	;xchg bx, bx
	jmp hang

; Print null terminated string in 16 bit real mode
print16:
	pusha
	mov ah, 0x0E
.print16_repeat:
	lodsb
	cmp al, 0
	je .print16_done
	int 0x10
	jmp short .print16_repeat
.print16_done:
	popa
	ret

; DATA
msg_done	db "Done ! ", 0x0D, 0x0A, 0
msg_hello	db "Oak64 Loaded... konnichiwa =^_^= !", 0x0D, 0x0A, "----------------------------------", 0x0D, 0x0A, 0x0D, 0x0A, 0
msg_wipe	db "1) Collecting garbage left by MBR ... ", 0
msg_e820	db "2) Detecting memory (using e820) ... ", 0

; First stage of the bootloader

USE16
ORG 0X8000

hang:
	hlt
	jmp hang
section .bss
	num RESB 3

section .data
	num2 db 3 dup(2) ;0x0020202

section .text
global _start

_start:
	MOV bl, 1
	MOV [num], bl
	MOV [num+1], bl
	MOV [num+2], bl

	MOV eax, 1
	INT 80h 

section .bss
	num resb 5
section .text 
global _start:

_start:
	mov eax, 3 	; SYS_READ
	mov ebx, 0	; fd = 0
	mov ecx, num	; buffer (1 char)
	mov edx, 5	; read in 1 char
	int 0x80

	mov eax, 4	; SYS_WRITE
	mov ebx, 1	; fd = 1
	mov ecx, num	; write_buffer
	mov edx, 5	; write 1 char
	int 0x80

	mov eax, 1
	mov ebx, 0
	int 0x80

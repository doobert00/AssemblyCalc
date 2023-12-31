section .data
	num0 db 1; 1 byte
	;num1 dw 1; 2 bytes
	;num2 dd 1; 4 bytes
	;num3 dq 1; 8 bytes
	;num4 dt 1; 10 bytes

section .text
global _start

_start:
	
	mov eax, num0 	; Moves the mem address stored in num0
	mov eax, [num0] ; Moves in the value at the address stored in num0
	mov eax, 1	; SYS_EXIT
	int 0x80	; syscall	

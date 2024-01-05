section .text
global _start

_start:
	mov eax, 1
	push eax
	mov eax, 2
	push eax
	mov eax, 4		;The previous item from the stack
	mov ebx, [esp+eax]	;Get the previous item from the stack

	mov eax, 1
	int 0x80

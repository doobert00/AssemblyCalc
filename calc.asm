section .bss
	buffer resb 1	; Reserve one byte for reading in user input
section .data
	welcome db "Please enter an equation",13,10,'$' 	;The welcome string	
	carraige db 13
section .text
global _start

_start:
	mov edx, 26	; 24 chars in welcome msg
	mov ecx, welcome
	mov ebx, 1;	; stdout
	mov eax, 4	; SYS_WRITE
	int 0x80	; syscall
read:
	mov eax, 3	; SYS_READ
	mov ebx, 0	; stdin
	mov ecx, buffer	; buffer for one char
	mov edx, 1	; read in 1 char
	int 0x80	;
	
	mov eax, 3
	mov ebx, 0
	mov ecx, buffer
	mov edx, 1
	int 0x80
	
	mov esi, [buffer]
	mov edi, [carraige]
	mov ecx, 1
	rep cmpsb
	mov eax, 4
	mov ebx, 1
	jne exit

ifRight:
	mov edx, 26
	mov ecx, welcome
	mov ebx, 1
	mov eax, 4
	int 0x80
	jmp exit
	
exit:
	mov eax, 1
	xor ebx, ebx
	int 0x80
	

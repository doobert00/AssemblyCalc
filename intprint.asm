section .data
	num1 db 1 ;
	num2 db 2 ;

section .text
global _start
_start:
	mov al, [num1] ; If we store in the extended register we get weird numbers
	mov bl, [num2] ; See above
	add eax, ebx  ; The numbers are summed in the eax register
	
	; Convert EAX to ASCII and store it onto the stack
	sub esp, 16 		; reserve space on stack
	mov ecx, 10		; Number length
	mov ebx, 16
	.L1:
	xor edx, edx 		; No idea what this does
	div ecx      		; Extract the last decimal digit (why?)
	or dl, 0x30  		; Convert everything else to ASCII (how?)
	sub ebx, 1   		;
	mov [esp+ebx], dl 	; Store the remainder on the stack in reverse...
	test eax, eax 		; until there is nothing left to divide
	jnz .L1

	mov eax, 4		; SYS_WRITE
	lea ecx, [esp+ebx]	; Point to the first ASCII digit
	mov edx, 16		;
	sub edx, ebx		; Count of digits
	mov ebx, 1		; STDOUT
	int 0x80		; syscall

	add esp, 16		; restore the stack
.quit:
	mov eax, 1		; SYS_EXIT
	xor ebx, ebx		; Return value
	int 0x80		; syscall

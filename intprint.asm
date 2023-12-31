section .data
	num1 dq 1 
	num2 dq 200000000 

section .text
global _start
_start:
	mov eax, [num1] ; If we store in the extended register we get weird numbers
	mov ebx, [num2] ; See above
	add eax, ebx  ; The numbers are summed in the eax register

; Print the value contained in eax
.print:
	; Convert EAX to ASCII and store it onto the stack
	sub esp, 16 		; reserve space on stack
	mov ecx, 10		; Number length
	mov ebx, 16
	.L1:
	xor edx, edx 		; Zero out the full d register
	div ecx      		; Extract the last decimal digit (why?)
	or dl, 0x30  		; Adding 0x30 (0 in ASCII) converts 0-9 binary to ascii
	sub ebx, 1   		; Point lower on the stack
	mov [esp+ebx], dl 	; Using ebx and flipped-ness of stack to reverse order
	test eax, eax 		; Jump (below) if 
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

section .bss
	buffer resb 1	; Reserve one byte for reading in user input
section .data
	welcome db "Please enter an equation",13,10,'$' 	;The welcome string	
	
	newline dq 10						; Linefeed in ASCII
	space dq 32						; Space in ASCII

	lwr_int dq 48						; 0 in ASCII
	upper_int dq 57						; 9 in ASCII

	multiplication dq 42					; * in ASCII
	addiion dq 43						; + in ASCII
	subtraction 45						; - in ASCII
	division 47						; / in ASCII

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
	int 0x80	; syscall
	
	mov eax, [buffer]	;If buffer = space
	mov ebx, [space]	
	test eax, ebx
	jnz read		;Don't save buff read next char
	
	mov eax, [buffer]	;If buffer = +
	mov ebx, [addition]
	test eax, ebx
	jnz save_to_stack	;Save to stack

	mov eax, [buffer]	;If buffer = -
	mov ebx, [subtraction]
	test eax, ebx
	jnz save_to_stack	;Save to stack
	
	mov eax, [buffer]	;If buffer = *
	mov ebx, [multiplication]
	test eax, ebx
	jnz save_to_stack	;Save to stack

	mov eax, [buffer]	;If buffer = /
	mov ebx, [division]
	test eax, ebx
	jnz save_to_stack	;Save to stack
	
	mov eax, [buffer]	;If buffer == linefeed 
	mov ebx, [newline]	; (This means we're at end of expr)
	test eax, ebx		; 
	jnz parse		;Evaluate expression on the stack
	
	;TODO: Check if buffer is in integer range 
	
	jmp invalid_expr_err	;If we've gotten here there was an invalid char. 

;TODO: Save a value to the stack
save_to_stack:
	jmp exit
	;See if we can jump and link here

;TODO: Convert ascii (input) to binary
ascii_to_bin:
	jmp exit	
	;jmp back to parse and save to stack
	;See if we can jump and link here

;TODO: Convert binary to ascii (output)
bin_to_ascii:
	jmp exit
	;jmp to whever we write output
	;See if we can jump and link here

;TODO: Parse and evaluate the expression from the stack
parse:
	jmp exit	

;An invalid expression was provided. Print error.	
invalid_expr_err:
	mov eax, 1
	int 0x80

;Normal exit
exit:
	mov eax, 1
	int 0x80
	

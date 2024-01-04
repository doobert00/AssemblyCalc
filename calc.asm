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
	
	mov eax, 0	;We're using the lowest entry in the stack
	sub esp, 32	;to count the number of entries
	mov [esp], eax	;We initialize w/ zero entries
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
	jmp read

	mov eax, [buffer]	;If buffer = -
	mov ebx, [subtraction]
	test eax, ebx
	jnz save_to_stack	;Save to stack
	jmp read

	mov eax, [buffer]	;If buffer = *
	mov ebx, [multiplication]
	test eax, ebx
	jnz save_to_stack	;Save to stack
	jmp read
	
	mov eax, [buffer]	;If buffer = /
	mov ebx, [division]
	test eax, ebx
	jnz save_to_stack	;Save to stack
	jmp read	
	
	;NOTE: WE WILL PARSE IFF WE FIND A LINEFEED (ELSE WE ERROR)
	mov eax, [buffer]	;If buffer == linefeed 
	mov ebx, [newline]	; (This means we're at end of expr)
	test eax, ebx		; 
	jnz parse		;Evaluate expression on the stack
 
	mov eax, [buffer]	;If buffer < 0 in ASCII
	mov ebx, [lwr_int]	; (This means buffer is not integer)
	cmp eax, ebx		;
	jl invalid_expr_err	;Invalid character exception
	
	mov eax, [buffer]	;If buffer > 9 in ASCII
	mov ebx, [upper_int]	; (This means buffer is not integer)
	cmp eax, ebx		;
	jg invalid_expr_err 	;Invalid character exception
	
	mov eax, [buffer]	
	sub eax, [lwr_int]	;Convert eax (in ASCII) to binary
	jmp save_to_stack	;Save eax to stack since we're not at end of input
	
;TODO: Save a value to the stack
;Input: eax is 32-bit value to save to stack
save_to_stack:
	pop ebx		;Recall the tail of stack has expr length
	push eax	;Push the character to the stack
	add ebx, 1	;Increment expression length
	push ebx	;Push the length to the stack
	jmp read	;Continue reading characters

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
	

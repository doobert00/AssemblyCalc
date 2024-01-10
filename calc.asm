section .bss
	buffer resb 1	; Reserve one byte for reading in user input
	number resb 4	; Reserve for summing numbers in
section .data
	welcome db "Please enter an equation",13,10,'$' 	;The welcome string	
	count dq 0						;Expression char len
	ten dq 10						;Useful for powers of 10

	newline dq 10						; Linefeed in ASCII
	space dq 32						; Space in ASCII

	lwr_int dq 48						; 0 in ASCII
	upper_int dq 57						; 9 in ASCII

	multiplication dq 42					; * in ASCII
	addition dq 43						; + in ASCII
	subtraction dq 45					; - in ASCII
	division dq 47						; / in ASCII

section .text
global _start

_start:
	mov edx, 26	; 24 chars in welcome msg
	mov ecx, welcome
	mov ebx, 1;	; stdout
	mov eax, 4	; SYS_WRITE
	int 0x80	; syscall
	
	mov eax, 0
	push eax	; We're using the lowest entry in the stack to count expr length
read:
	mov eax, 3	; SYS_READ
	mov ebx, 0	; stdin
	mov ecx, buffer	; buffer for one char
	mov edx, 1	; read in 1 char
	int 0x80	; syscall
	
	mov eax, [buffer]	;If buffer = space
	mov ebx, [space]	
	cmp eax, ebx
	je read		;Don't save buff read next char
	
	mov eax, [buffer]	;If buffer = +
	mov ebx, [addition]
	cmp eax, ebx
	je read_symbol	

	mov eax, [buffer]	;If buffer = -
	mov ebx, [subtraction]
	cmp eax, ebx
	je read_symbol	

	mov eax, [buffer]	;If buffer = *
	mov ebx, [multiplication]
	cmp eax, ebx
	je read_symbol

	mov eax, [buffer]	;If buffer = /
	mov ebx, [division]
	cmp eax, ebx
	je read_symbol		
	
	;NOTE: WE WILL PARSE IFF WE FIND A LINEFEED (ELSE WE ERROR)
	mov eax, [buffer]	;If buffer == linefeed 
	mov ebx, [newline]	; (This means we're at end of expr)
	cmp eax, ebx		; 
	je parse		;Evaluate expression on the stack

	mov eax, [buffer]	;If buffer < 0 in ASCII
	mov ebx, [lwr_int]	; (This means buffer is not integer or math symbol)
	cmp eax, ebx		;
	jl invalid_expr_err	;Invalid character exception
	
	mov eax, [buffer]	;If buffer > 9 in ASCII
	mov ebx, [upper_int]	; (This means buffer is not integer or math symbol)
	cmp eax, ebx		;
	jg invalid_expr_err 	;Invalid character exception
	
	mov eax, [buffer]	
	sub eax, [lwr_int]	;Convert eax (in ASCII) to binary
	mov [number], eax
	mov eax, 0
	mov [buffer], eax 
read_loop:
	mov eax, 3	; SYS_READ
	mov ebx, 0 	; stdin
	mov ecx, buffer	; buffer for one char
	mov edx, 1	; read in one char
	int 0x80

	mov eax, [buffer]	;Ignore spaces
	mov ebx, [space]
	cmp eax, ebx
	je read_loop	
	
	mov eax, [buffer]	;+
	mov ebx, [addition]	;BASE CASE: Find a symbol
	cmp eax, ebx		
	je read_recurse
	
	mov eax, [buffer]
	mov ebx, [subtraction]	
	cmp eax, ebx
	je read_recurse
	
	mov eax, [buffer]
	mov ebx, [multiplication]
	cmp eax, ebx
	je read_recurse
	
	mov eax, [buffer]
	mov ebx, [division]
	cmp eax, ebx
	je read_recurse

	mov eax, [buffer]	;Find a line feed. End of expr
	mov ebx, [newline]
	cmp eax, ebx
	je read_exit
	
	mov eax, [buffer]
	mov ebx, [lwr_int]
	cmp eax, ebx
	jl invalid_expr_err
	mov eax, [buffer]
	mov ebx, [upper_int]
	cmp eax, ebx
	jg invalid_expr_err

	mov eax, [buffer]	;In this case we've found a number
	mov ebx, [number]
	imul ebx, 10		;Base 10 parsing
	add ebx, eax		;Sum
	mov [number], ebx
	mov eax, 0
	mov [buffer], eax
	jmp read_loop


read_recurse:
	mov ebx, [number]
	push ebx
	mov ebx, 0
	mov [number], ebx
	mov ebx, [count]
	add ebx, 1
	mov [count], ebx	
read_symbol:
	mov ebx, [count]
	add ebx, 1
	mov [count], ebx
	push eax
	mov eax, 0
	mov [buffer], eax
	jmp read
read_exit:
	mov ebx, [number]
	push ebx
	mov ebx, 0
	mov [number], ebx
	mov ebx, [count]
	add ebx, 1
	mov [count], ebx
	jmp parse


;TODO: Parse and evaluate the expression from the stack
parse:
	mov eax, 0
	test [count], eax	;If expr length = 0
	jnz exit		;Exit
parse_loop1:		
	pop eax			
	mov ebx, [addition]
	test eax, ebx
	jnz invalid_expr_err
	mov ebx, [subtraction]
	test eax, ebx

	mov ebx, [multiplication]
	test eax, ebx

	mov ebx, [division]
	test eax, ebx

parse_loop2:	
	pop eax		
	mov ebx, [addition]
	test eax, ebx
	
	mov ebx, [subtraction]
	test eax, ebx

	mov ebx, [multiplication]
	test eax, ebx

	mov ebx, [division]
	test eax, ebx
	

;An invalid expression was provided. Print error.	
invalid_expr_err:
	mov edx, 26	; 24 chars in welcome msg
	mov ecx, welcome
	mov ebx, 1;	; stdout
	mov eax, 4	; SYS_WRITE
	int 0x80	; syscall
	
	
	mov eax, 1
	int 0x80

;Normal exit
exit:
	mov eax, 1
	int 0x80
	

section .bss
	buffer resb 1	; Reserve one byte for reading in user input
	number resb 4	; Reserve for summing numbers in
section .data
	welcome db "Please enter an equation",13,10	 	;The welcome string	
	error db "Error",13,10					;The error string

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
	mov edx, 26	; 26 chars in welcome msg
	mov ecx, welcome
	mov ebx, 1;	; stdout
	mov eax, 4	; SYS_WRITE
	int 0x80	; syscall
	
	;mov eax, 0
	;push eax	; We're using the lowest entry in the stack to count expr length
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
	mov eax, [number]
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
	jmp read_loop


read_recurse:
	;Pushing the value in number to stack + increment count
	mov ebx, [number]
	push ebx
	mov ebx, 0
	mov [number], ebx
	mov ebx, [count]
	add ebx, 1
	mov [count], ebx	
read_symbol:
	;Push the symbol to stack + increment count
	mov ebx, [count]
	add ebx, 1
	mov [count], ebx
	push eax
	mov eax, 0
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
	cmp [count], eax	;If expr length = 0
	je exit		;Exit
	mov eax, [count]
	mov eax, 0
parse_loop1:
	mov eax, [number]
	mov eax, [count]
	mov eax, 0
	;If we start with a math symbol it is a bad expression		
	pop eax		
	;Decrement count		
	mov ebx, [count]
	sub ebx, 1
	mov [count], ebx	

	mov ebx, [addition]
	cmp eax, ebx
	je invalid_expr_err
	mov ebx, [subtraction]
	cmp eax, ebx
	je invalid_expr_err
	mov ebx, [multiplication]
	cmp eax, ebx
	je invalid_expr_err
	mov ebx, [division]
	cmp eax, ebx
	je invalid_expr_err
	
	;Now we know it must be a number
	;Put it in a buffer to store our result
	mov [number], eax

parse_loop2:
	mov eax, [number]
	mov eax, [count]
	;If count == 0: return
	mov eax, 0
	cmp eax, [count]
	je exit
	;Else: decrement count and pop
	mov ebx, [count]
	sub ebx, 1
	mov [count], ebx

	pop eax	
	;If it's a symbol do the symbol function	
	mov ebx, [addition]
	cmp eax, ebx
	je adder			;[number] += pop eax 
	
	mov ebx, [subtraction]		
	cmp eax, ebx
	je subtracter			;[number] -= pop eax
 
	mov ebx, [multiplication]
	cmp eax, ebx
	je multiplier			;[number] *= pop eax

	mov ebx, [division]
	cmp eax, ebx
	je divider			;[number] /= pop eax
	
	;If we got here it was a number => error
	jmp invalid_expr_err

adder:
	mov eax, [number]
	mov eax, [count]
	;If count == 0 => we ended on a symbol => error=	]
	mov eax, 0
	cmp eax, [count]
	je invalid_expr_err
	;Else: decrement count and pop
	mov ebx, [count]
	sub ebx, 1
	mov [count], ebx
	
	;Do our addition
	pop eax
	mov ebx, [number]
	add ebx, eax
	mov [number], ebx
	;Jump back to parse_loop2 to find a symbol	
	jmp parse_loop2
subtracter:
	;If count == 0 => we ended on a symbol => error
	mov eax, 0
	cmp eax, [count]
	je exit
	;Else: decrement count and pop
	mov ebx, [count]
	sub ebx, 1
	mov [count], ebx
	
	;Do our addition
	pop eax
	mov ebx, [number]
	sub ebx, eax
	mov [number], ebx
	;Jump back to parse_loop2 to find a symbol	
	jmp parse_loop2
multiplier:
	;If count == 0 => we ended on a symbol => error                      
	mov eax, 0
	cmp eax, [count]
	je exit
	;Else: decrement count and pop
	mov ebx, [count]
	sub ebx, 1
	mov [count], ebx
	
	;Do our addition
	pop eax
	mov ebx, [number]
	imul ebx, eax
	mov [number], ebx
	;Jump back to parse_loop2 to find a symbol	
	jmp parse_loop2

;Let's hold off on division for now
divider:
	;If count == 0 => we ended on a symbol => error
	mov eax, 0
	test eax, [count]
	jnz exit
	;Else: decrement count and pop
	mov ebx, [count]
	sub ebx, 1
	mov [count], ebx
	
	;Do our addition
	pop eax
	mov ebx, [number]
	; idiv ebx, eax
	mov [number], ebx
	;Jump back to parse_loop2 to find a symbol	
	jmp parse_loop2


;An invalid expression was provided. Print error.	
invalid_expr_err:
	mov edx, 7	; 5 chars in error msg
	mov ecx, error
	mov ebx, 1;	; stdout
	mov eax, 4	; SYS_WRITE
	int 0x80	; syscall
	
	
	mov eax, 1
	int 0x80

;Normal exit
exit:
	mov ecx, [number]
;	
;	mov edx, 1	; 1 character
;	mov ebx, 1	; stdout
;	mov eax, 4	; SYS_WRITE
;	int 0x80	; syscall

	mov eax, 1	; SYS_EXIT
	int 0x80	; syscall

	

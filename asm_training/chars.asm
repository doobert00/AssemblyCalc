section .data
	str1 db "ABA",0 	; Null terminated string 
	str2 db "CDE",0	
	;char db 'A'		; This is encoded in ASCII as 65
	;list db 1,2,3,4 	; Null terminated list
 
section .text
global _start

_start:
	mov bl, [str1]	;
	
	mov eax, 1	;
	int 0x80	;

section .text
global _start

_start:
	mov eax, 11	;Dividend
	mov ecx, 2	;Divsor
	
	div ecx		;eax = (eax/ecx) + r
			;edx = r

	int 80h

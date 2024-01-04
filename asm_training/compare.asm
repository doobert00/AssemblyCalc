section .text
global _start

_start:
	mov eax, 2
	mov ebx, 1
	cmp eax, ebx ;Jump to end if eax >= ebx
	jge end
	mov eax, 2
end:
	mov eax, 1
	int 0x80

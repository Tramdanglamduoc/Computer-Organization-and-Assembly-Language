; Simple Assembly program with no output
; to calculate perimeter of the rectangle

.586
.MODEL flat, stdcall
OPTION casemap:none

.DATA
w	DWORD	4
h	DWORD	3
p	DWORD	?	

.CODE
Rect	PROC	
	
	mov	eax, w	   ;copy 4 bytes from memory address w to the register eax
	add	eax, h	   ;add value stored in 4 memory bytes at address h to the register eax 
	add	eax, eax   ;add the register eax to itself to calculate perimeter as 2*(w+h)
	mov	p, eax	   ;copy the register eax to 4 memory bytes at address p

	ret

Rect	ENDP
	END Rect

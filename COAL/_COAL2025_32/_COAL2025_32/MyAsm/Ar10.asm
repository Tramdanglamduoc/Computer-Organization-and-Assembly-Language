.586
.model flat, stdcall

includelib kernel32.lib
extern ExitProcess@4:PROC

; Calculate formula w=x/y–3*z where x, y and z are word format integers
; Store the result in doubleword memory field w

.data
x	word	17
y	word	4
z	word	5
w	dword	?

.code
start proc
; compute x/y  

; compute 3*z 	

; compute result and save to doubleword w


	push	0
	call	ExitProcess@4
start endp
	end	start        


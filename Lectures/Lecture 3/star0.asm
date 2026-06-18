;Find position of the symbol * in the text string given and display result 
.586
.model flat, stdcall
option casemap:none

extern C puts:PROC
extern 	ExitProcess@4:PROC

.data
string  byte	'01234567891*ABC', 0 	; text string
buff	byte	'0000', 0		; output buffer
msg	byte	'Star not found!', 0

.code
start proc
; Find position of the symbol * 

	
; Convert binary value to the string of symbols

; Display result
done:	
       	push 	offset buff	; parameter for function puts - address of buff 
	jmp	show
notfound:
       	push 	offset msg	; parameter for function puts- address of msg 
show:
       	call	puts		; console display 
	add	esp, 4

	push	0
	call	ExitProcess@4
start	endp
	end	start

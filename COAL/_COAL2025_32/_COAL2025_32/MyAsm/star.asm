;Find position of the symbol * in the text string given and display result 
.586
.model flat, stdcall
option casemap:none

extern 	puts:PROC
extern 	ExitProcess@4:PROC

.data
string  byte	'01234567891*ABC', 0 	; text string
buff	byte	'0000', 0		; output buffer
msg	byte	'Star not found!', 0

.code
start proc
	mov	ah, '*'		; ah = symbol to find
	mov	esi, 0		; index of the byte to check in the string

check:	cmp	string[esi], 0	; compare current byte with binary zero
	je	notfound	; if 0 then end of the string reached
	cmp	ah, string[esi]	; compare * with a current byte
	je	found
	inc	esi		; index = index+1 
	jmp	check

found:	mov	eax, esi	; copy index of the symbol found into eax
	inc	eax		; number of the position = index+1
	
; Convert binary value to the string of symbols
	mov	edi, 3		; index of the last symbol in the output buffer
	mov	bl, 10		; divisor - base of the decimal system

d:	div	bl		; ax/bl = quotient in al, remainder in ah
	add	ah, 30h		; convert binary value of the decimal digit to ASCII code
	mov	buff[edi], ah	; place ASCII code of the digit into output buffer
	cmp	al, 0		; quotient = 0 ?
	je	output		; yes, stop looping
	dec	edi		; prepare next index for the output buffer
	mov	ah, 0		; clean high order byte in ax
	jmp	d		; go to divide

output:	
       	push 	offset buff	; parameter for function puts - address of buff 
	call	puts		; call C function for console display 
	jmp	done
notfound:
       	push 	offset msg	; parameter for function puts- address of msg 
       	call	puts		; console display 

done: 	
	push	0
	call	ExitProcess@4
start	endp
	end	start

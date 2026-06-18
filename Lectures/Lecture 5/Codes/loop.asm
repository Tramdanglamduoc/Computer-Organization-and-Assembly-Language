.586
.model flat, stdcall
option casemap:none

extern C puts:PROC
extern 	ExitProcess@4:PROC

; Calculate the sum of all positive elements of the given array of words

.data
vect	word 	1, 2, -3, 4, -5, 6, 7, -8 	; array given
buff	byte	'0000000000', 0			; output buffer

.code
start proc
	mov	ecx, 8		; initial counter value
	xor	esi, esi	; initial index value
	xor	ebx, ebx	; initial sum value

a:	cmp	vect[esi], 0	; the current element > 0 ?
	jle	next		; if not, jump to the label next
	mov	ax, vect[esi]
	cwde			; extend ax to eax
	add	ebx, eax	; add value of the current element to sum
next:	add	esi, 2		; increase index register (size of each element is 2 bytes)
	loop	a	

	mov	eax, ebx	; save ebx in eax

; Convert unsigned binary value to the string of symbols
	mov	edi, 9		; index of the last symbol in the output buffer
	mov	ebx, 10		; divisor - base of the decimal system
	
d:	mov	edx, 0		; clean high order doubleword of the dividend
	div	ebx		; edx:eax/ebx -> eax=quotient, edx=remainder (one decimal digit)
	add	dl, 30h		; convert binary value of the decimal digit to ASCII code
	mov	buff[edi], dl	; place ASCII code of the digit into output buffer
	cmp	eax, 0		; quotient = 0 ?
	je	output		; yes, stop looping
	dec	edi		; prepare next index for the output buffer
	jmp	d		; go to divide
output:	
       	lea	ebx, buff[edi]	; address of the first symbol in the buff
	push 	ebx		; parameter for StdOut
       	call 	puts		; call procedure for console display 
	add	esp, 4

	push	0
	call	ExitProcess@4
start endp
	end	start    
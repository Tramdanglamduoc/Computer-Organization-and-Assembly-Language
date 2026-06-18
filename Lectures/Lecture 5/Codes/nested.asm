; Count number of zero elements in each row of the matrix M (word format)
; Store the result for each row in the array R (byte format)
.586
.model flat, stdcall
option casemap:none

extern C puts:PROC
extern 	ExitProcess@4:PROC

.data
M	word	0, 2, 0, 0, 5
	word	1, 2, 3, 4, 5
	word	1, 2, 0, 4, 0

R	byte	3 dup(0)
buff	byte	'000', 0

.code
start proc
	xor	esi, esi	; matrix index = 0
	xor	edi, edi	; result index = 0
; Begin external loop by rows--------------------------------------
	mov	ecx, 3		; number of rows
rows:	push	ecx		; save into stack

	xor	al, al		; number of zeros per row = 0

; Begin internal loop by columns-----------------------------------
	mov	ecx, 5		; number of columns
cols:	push	ecx

	cmp	M[esi], 0	; is current element 0 ?
	jne	next		
	inc	al		; number of zeros per row + 1

next:	add	esi, 2		; increase matrix index

	pop	ecx		; restore ecx from stack
	loop	cols		; internal loop
; -----------------------------------------------------------------
; Processing of the current row is complete
	mov	R[edi], al	; store number of zeros per row into R

	add	edi, 1		; increase result index

	pop	ecx		; restore ecx from stack
	loop	rows		; external loop
; -----------------------------------------------------------------
; Processing of all rows is complete

; Convert three binary values of the array R (byte format) to strings of symbols
	xor	edi, edi	; index for R = 0
	mov 	ecx, 3		; number of elements in R

rc:	push	ecx
	mov	esi, 2		; index of the last symbol in the output buffer
	mov	bl, 10		; divisor - base of the decimal system
	xor	ax, ax
	mov	al, R[edi]	; copy current element of R into ax

d:	idiv	bl		; ax/bl = ah-remainder,al-quotient
	add	ah, 30h		; convert binary value of decimal digit to ASCII
	mov	buff[esi], ah	; copy symbol of the digit into output buffer
	cmp	al, 0		; quotient = 0 ?
	je	put
	dec	esi		; prepare next index in the output buffer
	mov	ah, 0		; clean high byte in ax
	jmp	d

put:	lea	ebx, buff[esi]	; address of the first digit in the output buffer
       	push 	ebx 		; push address of the first digit in buff into stack

       	call 	puts		; console display 
	add	esp, 4

	inc	edi
	pop	ecx
	loop 	rc
done: 	
	push	0
	call	ExitProcess@4
start endp
	end	start    
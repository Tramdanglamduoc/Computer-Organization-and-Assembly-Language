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
; compute x/y first 
	mov 	ax, x 	; copy two bytes from memory address x into 16-bit register ax
	cwd 		; convert word to doubleword - extends ax to 32 bits in dx:ax 
	idiv 	y 	; dx:ax / y -> quotient in ax and the remainder in dx
	mov	bx, ax	; save quotient in bx
; compute 3*z 	
	mov	ax, z	; copy two bytes from memory address z to ax
	mov	cl, 3	; set cl to value 3
	imul 	cl	; ax = al * cl
; compute result
	sub 	bx, ax 	; subtract, result in bx 
	movsx 	eax, bx	; copy bx with sign extension to eax
	mov	w, eax	; copy eax to memory field starting from the address w

	push	0
	call	ExitProcess@4
start endp
	end	start        


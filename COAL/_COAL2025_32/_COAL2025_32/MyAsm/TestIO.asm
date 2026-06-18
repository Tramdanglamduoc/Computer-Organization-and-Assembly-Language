; A simple assembler program to show the use of some C functions useful for console I/O 
; It also calculates the formula w=x/y–3*z where x, y and z are word format integers,
; and stores the result in the doubleword memory field w

.586
.model flat, stdcall
option casemap:none

extern puts:PROC
extern gets:PROC
;extern gets_s:PROC
extern scanf:PROC
extern printf:PROC
extern atol:PROC
extern _ltoa:PROC
extern ExitProcess@4:PROC

; proto directives may be used istead of extern to use invoke directives
; example: printf proto C :vararg 


.data
dwa	dword	?
inbuff	byte 	16 dup(0)
outbuff	byte	16 dup(0)
message	byte 	"Hello! Please, enter decimal value:",0
char	byte	0


x	word	17
y	word	4
z	word	5
w	dword	?

outformat	byte	"Result of the calculation  w=x/y-3*z, where x=%d, y=%d, z=%d is w=%d",13,10,0
asknum	byte	"Enter value of the variable x:",0
informat	byte	"%d",0

.code
start 	proc
; ask some value
	push	offset message
	call	puts
	push	offset inbuff
	call	gets	
	push	offset	inbuff
	call	atol	; convert text to integer, result in eax

; convert dword to string
	mov	dwa, eax
	push	10		; base
	push	offset outbuff	; buffer
	push	dwa		; dword
	call	_ltoa
	push	offset outbuff
	call	puts

; ask x to use the value in the formula 
	push 	offset asknum	
	call 	puts
	push	offset dwa
	push	offset informat
	call	scanf
	mov	ax, word ptr dwa	; take low order word
	mov	x, ax
; calculate x/y first since it has the highest precedence
	mov 	ax, x 	; copy x into 16-bit register ax
	cwd 		; convert word to doubleword - extends ax to 32 bits in dx:ax 
	idiv y 		; dx:ax / y -> quotient in ax and the remainder in dx
	mov	bx, ax	; save quotient in bx
; calculate 3*z 	
	mov	ax, z	; copy z to ax (ah:al)
	mov	cl, 3
	imul cl		; ax = al * cl
; calculate the result
	sub 	bx, ax 	; subtract, result in bx 
	movsx 	eax, bx	; copy bx with sign extension to eax
	mov	w, eax	; store the result in the memory field w
; use printf to show the result
 	push	w
	movsx	ebx,z
	push	ebx
	movsx	ebx,y	
	push	ebx
	movsx	ebx,x
	push	ebx
	push 	offset outformat
	call 	printf

	push	0
	call	ExitProcess@4

start endp

	end	start        


; A simple assembler program to show the use of some C functions useful for console I/O 
; It also calculates the formula res=x/y–3*x where x and y are doubleword format integers,
; and stores the result in the doubleword memory field res

.586
.model flat, stdcall
option casemap:none

puts	PROTO C :dword
gets	PROTO C :dword
gets_s	PROTO C :dword,:dword
atol	PROTO C :dword
_ltoa	PROTO C :dword,:dword,:dword
scanf	PROTO C :vararg
printf	PROTO C :vararg

ExitProcess PROTO :dword

.data
x	dword	?
y	dword	?
res	dword	?

inbuff	byte 	16 dup(0)
outbuff	byte	16 dup(0)
message	byte 	"Please, enter integer decimal value:",0
outformat	byte	"Result of the calculation  res=x/y-3*x, where x=%d, y=%d, is res=%d",13,10,0
asknum	byte	"Enter values of variables x and y",0
informat	byte	"%d %d",0

.code
start 	proc
; Try functions puts, gets, atol
	invoke	puts, offset message
	invoke	gets, offset inbuff
	invoke	atol, offset inbuff

; Try function _ltoa
	invoke	_ltoa, eax, offset outbuff, 10
	invoke	puts, offset outbuff

; Ask x and y to use values in the formula 
	invoke	puts, offset asknum
	invoke	scanf, offset informat, offset x, offset y

; Calculate x/y 
	mov 	eax, x 	; copy x to eax
	cdq 		; convert eax to edx:eax
	idiv 	y 	; edx:eax / y -> quotient in eax and the remainder in edx
	push	eax	; save quotient onto stack
; Calculate 3*x 	
	mov	eax, x
	mov	edx, 3
	imul 	edx		; edx:eax = eax*edx
; Calculate the result
	pop	ebx		; take x/y from top of the stack
	sub 	ebx, eax 	; subtract, result in ebx 
	mov	res, ebx	; store the result in the memory field res

; Use printf to show the result
 	invoke	printf, offset outformat, x, y, res

	invoke	ExitProcess, 0

start endp
	end	start        


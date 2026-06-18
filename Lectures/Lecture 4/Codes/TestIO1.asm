; A simple assembler program to show the use of some C functions useful for console I/O 
; It also calculates the formula res=x/y–3*x where x and y are doubleword format integers,
; and stores the result in the doubleword memory field res

.586
.model flat, stdcall
option casemap:none

extern C puts:PROC
extern C gets:PROC
extern C gets_s:PROC
extern C scanf:PROC
extern C printf:PROC
extern C atol:PROC
extern C _ltoa:PROC
extern ExitProcess@4:PROC

; proto directives may be used istead of extern to use invoke directives
; example: printf proto C :vararg 


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
	push	offset message
	call	puts		; ask some value
	add	esp, 4

	push	offset inbuff
	call	gets		; get console input as a text
	add	esp, 4

	push	offset inbuff
	call	atol		; convert text to integer, result in eax
	add	esp, 4

; Try function _ltoa
	push	10		; base
	push	offset outbuff	; buffer
	push	eax		; dword to convert
	call	_ltoa		; convert integer to text
	add	esp, 12

	push	offset outbuff
	call	puts
	add	esp, 4

; Ask x and y to use values in the formula 
	push 	offset asknum	
	call 	puts
	add	esp, 4

	push	offset y	; memory address to store second value
	push	offset x	; memory address to store first value
	push	offset informat	; address of the format string
	call	scanf
	add	esp, 12

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
	mov	res, ebx	; store result in the memory field res

; Use printf to show the result
 	push	res
	push	y
	push	x
	push 	offset outformat ; address of the format string
	call 	printf
	add	esp, 16

	push	0
	call	ExitProcess@4

start endp

	end	start        


.586
.model flat
option casemap:none

includelib ucrt.lib
includelib kernel32.lib 

extern	C puts:PROC
extern	C _ltoa:PROC
extern	STDCALL ExitProcess@4:PROC

extern	Ones:PROC

.data
num	dword	-1
buff	byte	11 dup(?), 0

.code
main 	proc
	
	push 32		; second parameter
     	push num	; first parameter
     	call Ones	; result is in EAX

; Convert numeric value to text	
	push	10
	push	offset buff
	push	eax
	call	_ltoa
	add	esp, 12

; Output
	push	offset buff
       	call	puts
	add	esp, 4

; Return to operating system
	push	0
	call	ExitProcess@4
main 	endp
	end	main
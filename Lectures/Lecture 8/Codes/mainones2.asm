.586
.model flat
option casemap:none

includelib ucrt.lib
includelib kernel32.lib 

puts	PROTO C :dword
_ltoa	PROTO C :dword,:dword,:dword
ExitProcess PROTO stdcall :dword

Ones 	PROTO stdcall num:dword,n:dword    ;Prototype for the procedure Ones

.data
num	dword	-2
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

; Or use INVOKE
	invoke 	Ones,num,32
	invoke	_ltoa,eax, offset buff, 10
	invoke	puts, offset buff

; Return to operating system
	invoke	ExitProcess, 0
main 	endp
	end	main
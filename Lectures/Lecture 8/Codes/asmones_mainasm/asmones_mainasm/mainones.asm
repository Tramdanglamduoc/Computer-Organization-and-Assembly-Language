.586
.model flat
option casemap:none
includelib ucrt.lib
includelib kernel32.lib 

puts	PROTO C :dword
_ltoa	PROTO C :dword,:dword,:dword
ExitProcess PROTO stdcall :dword

Ones PROTO  stdcall :dword,:dword

ones_c PROTO stdcall, :dword, :dword

.data
num		dword	-2
buff	byte	11 dup(?), 0

.code
main 	proc
; call Assembly procedure ==========================
		push 32		; second parameter
     	push num	; first parameter
     	call Ones
		invoke Ones, num, 32

; convert numeric value to text	
		invoke _ltoa, eax, offset buff, 10

; output to console
       	invoke puts, offset buff

; call C++ function ==========================
		push 32		; second parameter
     	push num	; first parameter
     	call ones_c

; convert numeric value to text	
		invoke _ltoa, eax, offset buff, 10

; output to console
       	invoke puts, offset buff

		invoke ExitProcess, 0
main 	endp
	end	main
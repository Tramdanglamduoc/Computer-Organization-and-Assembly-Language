.586
.model flat,stdcall
option casemap:none

puts	PROTO C :dword
_ltoa	PROTO C :dword,:dword,:dword
ExitProcess PROTO :dword

.data
num	dword	-2
buff	byte	'0000', 0

.code
;Procedure Ones - counts number of ones in the rightmost bits in the doubleword
;Parameters:  1)doubleword to analyze, 
;             2)doubleword - number of the rightmost bits to count
;Return value: EAX contains number of bits with the value one

Ones proc near stdcall dwData:dword,dwN:dword
     push ebp		; save ebp
     mov  ebp, esp	; load ebp with the current value of the esp
     push ebx		; save ebx
     push ecx		; save ecx

     mov  ecx, [ebp+16] ; ecx = second parameter from the stack
     mov  eax, [ebp+12]	; eax = first parameter from the stack
     
; Count ones
     xor  ebx, ebx
     cmp  ecx, 0
     jz   res

t:   test eax, 1
     jz   next
     inc  ebx
next:shr  eax, 1
     loop t

res: mov  eax, ebx	; copy the result to eax

     pop  ecx		; restore ecx
     pop  ebx		; restore ebx
     pop  ebp		; restore ebp
     ret  8 		; return and adjust top of the stack
Ones endp


main 	proc
	invoke 	Ones,num,32
	invoke	_ltoa,eax, offset buff, 10
	invoke	puts, offset buff
	invoke	ExitProcess, 0
main 	endp
	end	main
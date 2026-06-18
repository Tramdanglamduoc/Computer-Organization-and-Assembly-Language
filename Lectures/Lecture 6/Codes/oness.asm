.586
.model flat,stdcall
option casemap:none

extern C puts:PROC
extern C _ltoa:PROC
extern ExitProcess@4:PROC

.data
num	dword	-2
buff	byte	'0000', 0

.code
;Procedure Ones - counts number of ones in the rightmost bits in the doubleword
;Parameters:  1)doubleword to analyze, 
;             2)doubleword - number of the rightmost bits to count
;Return value: EAX contains number of bits with the value one

Ones proc near stdcall
     push ebp		; save ebp
     mov  ebp, esp	; load ebp with the current value of the esp
     push ebx		; save ebx
     push ecx		; save ecx

     mov  ecx, [ebp+12] ; ecx = second parameter from the stack
     mov  eax, [ebp+8]	; eax = first parameter from the stack
     
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
; Call procedure Ones
	push 8		; 2nd parameter - number of bits to count
     	push num	; 1st parameter - doubleword to analyze
     	call Ones

; Convert numeric value to text	
	push 10
	push offset buff
	push eax
	call _ltoa
	add  esp, 12

; Output
	push offset buff
       	call puts
	add  esp, 4

; Return to operating system
	push 0
	call ExitProcess@4
main 	endp
	end	main
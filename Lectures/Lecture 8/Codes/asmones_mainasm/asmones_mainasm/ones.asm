.586
.model flat
option casemap:none
option prologue:none
option epilogue:none

.code
Ones proc stdcall num:dword, n:dword
;Parameters:  1)doubleword to count, 
;             2)doubleword - number of the rightmost bits to count
;Return value: number of bits with the value one in EAX
     push ebp
     mov  ebp, esp
     push ebx
     push ecx
     mov  ecx, [ebp+12] ; ecx = second parameter
     mov  eax, [ebp+8]	; eax = first parameter
     xor  ebx, ebx
t:   test eax, 1
     jz   next
     inc  ebx
next:shr  eax, 1
     loop t
     mov  eax, ebx
     pop  ecx
     pop  ebx
     pop  ebp
     ret  8 		; return and adjust top of the stack
Ones endp
     end
.586
.model flat
option casemap:none

option prologue:none
option epilogue:none

.code
;Procedure Ones - counts number of ones in the rightmost bits in the doubleword
;Parameters:  1)doubleword to count bits containing 1
;             2)doubleword - number of the rightmost bits to count
;Return value: number of bits with the value one in EAX

Ones proc stdcall num:dword, n:dword
     push ebp		; save registers
     mov  ebp, esp
     push ebx
     push ecx
     mov  ecx, [ebp+12] ; ecx = second parameter
     mov  eax, [ebp+8]  ; eax = first parameter

     xor  ebx, ebx	; counter ebx=0
testb:
     test eax, 1
     jz   skip
     inc  ebx
skip:
     shr  eax, 1
     loop testb

     mov  eax, ebx	; copy the result in eax

     pop  ecx		; restore registers
     pop  ebx
     pop  ebp
     ret  8 		; return and adjust top of the stack
Ones endp
     end
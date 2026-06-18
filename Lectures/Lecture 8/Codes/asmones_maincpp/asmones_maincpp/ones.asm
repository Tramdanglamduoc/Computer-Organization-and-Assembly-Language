.586
.model flat
option casemap:none

.code
Ones proc C
     push ebp           ; save EBP register
     mov  ebp, esp      ; copy stack pointer ESP to EBP
     push ebx           ; save EBX
     push ecx           ; save ECX

     mov  ecx, [ebp+12] ; value of the second parameter to ECX
     mov  eax, [ebp+8]  ; value of the first parameter  to EAX

     xor  ebx, ebx
t:   test eax, 1
     jz   next
     inc  ebx
next:shr  eax, 1
     loop t
     mov  eax, ebx      ; copy result to EAX 

     pop  ecx       ; restore ECX
     pop  ebx       ; restore EBX
     pop  ebp       ; restore EBP

     ret  ; caller will adjust the stack because calling convention is C
Ones endp
     end
.586
.model flat, stdcall
option casemap:none

extern C puts:PROC
extern C _ltoa:PROC
extern ExitProcess@4:PROC

.data
num	dword	29
buff	byte	'    ', 0

.code
;Procedure Ones - counts number of ones in the rightmost bits in the doubleword
;Parameters:EAX - doubleword in which bits will be counted
;           ECX - number of rightmost bits to count
;Return value: EAX contains number of bits with the value one

Ones proc near 
     	push ebx        ; save EBX value
     	push ecx	; save ECX value

     	xor  ebx, ebx	; EBX = 0 
testb:	test eax, 1 	; test the rightmost bit of EAX
     	jz   skip       ; skip if this bit is zero
     	inc  ebx        ; otherwise increment EBX (number of ones)
skip:	shr  eax, 1     ; shift right EAX by 1 bit
     	loop testb      ; repeat

     	mov  eax, ebx	; copy result to EAX

     	pop  ecx        ; restore ECX value
     	pop  ebx	; restore EBX value
     	ret             ; return to caller
Ones endp            	

main 	proc
; Call procedure Ones
     	mov  eax, num	; parameter
     	mov  ecx, 4	; parameter
     	call Ones	; result is in eax

; Convert numeric value in EAX to text in buff
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
	push	0
	call	ExitProcess@4

main 	endp
	end	main
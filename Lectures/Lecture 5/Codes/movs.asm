.586
.model flat, stdcall
option casemap:none

puts	PROTO C :dword
ExitProcess PROTO :dword

; Copy 80 bytes from field1 to field2

.data
field1	byte	80 dup('A'), 0
field2	byte	80 dup('?'), 0
NL	byte	13, 10, 0

.code
start proc
       	invoke	puts, offset field1
       	invoke	puts, offset field2
       	invoke	puts, offset NL
 
	mov	esi,offset field1	 
	mov	edi,offset field2 	
	cld				; set DF to 0
	mov 	ecx, 80			; load ecx with counter value
    rep movsb				; repeat the instruction movsb while ecx is non-zero

        invoke	puts, offset field1
       	invoke	puts, offset field2	

	invoke	ExitProcess, 0
start endp
	end	start

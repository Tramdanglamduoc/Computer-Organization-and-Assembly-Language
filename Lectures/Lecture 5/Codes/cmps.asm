.586
.model flat, stdcall
option casemap:none

puts	PROTO C :dword
gets	PROTO C :dword
ExitProcess PROTO :dword

; Compare input with a given sample text

.data
psw	byte	16 dup(?)
sample	byte	'qwerty12'

msgAsk	byte	'Pasword:', 0
msgOK	byte	'OK!', 0
msgWrong byte	'Wrong!', 0

.code
start proc
; Ask password
	invoke	puts, offset msgAsk
; Input of the psw value
      	invoke	gets, offset psw

; Compare strings
	mov 	esi, offset psw		
	mov 	edi, offset sample 		
	cld
	mov 	ecx,8		;counter = 8
      repe cmpsb		;repeat while ECX<>0 and ZF=0
	jne	wrong

; Process matching strings
	invoke	puts, offset msgOK
 	jmp	done

; Process non matching strings
wrong:	
	dec	esi
	dec	edi
	invoke	puts, offset msgWrong
done:	
	invoke	ExitProcess, 0
start endp
	end	start    
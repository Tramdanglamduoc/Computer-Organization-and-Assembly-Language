.586
.model flat, stdcall
option casemap:none

puts		proto C :dword
_ltoa		proto C :dword,:dword,:dword
ExitProcess	proto :dword

.data
x	dword	-1
buff	byte	11 dup (' '), 0		; output buffer

msgNeg	byte	"Negative x", 10, 0
msgPos	byte	"Positive x", 10, 0

.code
start proc
	mov	eax, x
	cmp	eax, 0
	jb	negative  ; Wrong conditional jump! Instruction jl or jnge must be used

positive:	
	invoke	puts, offset msgPos
	jmp	convert

negative:	
	invoke	puts, offset msgNeg
	
convert:	
	invoke	_ltoa, x, offset buff, 10
	invoke	puts, offset buff

	
	invoke	ExitProcess, 0
start endp
	end	start        


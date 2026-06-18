.586
.model flat, stdcall
option casemap:none

puts	PROTO C :dword
gets	PROTO C :dword
strlen	PROTO C :dword
ExitProcess PROTO :dword

; Create reversed text
.data
msgAsk	byte	'Please enter some text (max 8 symbols):', 0
src	byte	8 dup(' '), 0
dst	byte	8 dup(' '), 0
NL	byte	13, 10		; new line

.code
start proc
	invoke	puts,offset msgAsk
	invoke 	gets, offset src
	invoke	strlen, offset src	; eax = actual length
	cmp	eax, 0
	je	done
	mov 	ebx, eax 	; save length in ebx
; use simple looping
	mov	esi, 0
	mov 	edi, ebx	; calculate index of the first
	dec	edi		; byte to copy to destination

	mov 	ecx, ebx	; number of bytes to copy
m1:	mov	al, src[esi]
	mov	dst[edi], al
	inc	esi
	dec	edi	
	loop	m1
 	
	invoke 	puts, offset dst
	invoke	puts, offset NL

; clean dst 
	mov	al, ' '
	mov	ecx, 8
	mov	edi, offset dst
    	cld
    rep stosb

; use string instructions	
	mov 	esi, offset src
	mov	edi, offset dst

	add	edi, ebx	; adjust position of the first
	dec	edi		; byte to copy to destination

	mov	ecx, ebx	; number of bytes to copy

m2:    	cld			; process source from left to right
    	lodsb			; copy one source byte to AL
    	std			; process destination from rigt to left
    	stosb			; copy one byte from AL to destination
    	loop 	m2

	invoke	puts, offset dst
	invoke	puts, offset NL
done:
	invoke	ExitProcess, 0
start endp
	end	start    
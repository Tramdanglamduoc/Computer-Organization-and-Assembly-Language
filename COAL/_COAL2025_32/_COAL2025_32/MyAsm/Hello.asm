; Simple Assembly program to say Hello
.586
.model flat, stdcall
option casemap:none
; Simple Assembly program to say Hello

extern C puts:PROC
extern C ExitProcess@4:PROC

.data
message	byte 	"Hello!",0

.code
start 	proc
	
	push	offset message
	call	puts

	push	0
	call	ExitProcess@4

start endp
	end	start        


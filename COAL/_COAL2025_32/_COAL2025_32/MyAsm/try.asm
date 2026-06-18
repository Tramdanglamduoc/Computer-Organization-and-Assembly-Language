.586
.model flat, stdcall

includelib kernel32.lib
extern ExitProcess@4:PROC


.data
x	word	-10
y	word	10
z	dword	5

.code
try	proc


	push	0
	call	ExitProcess@4
try	endp
	end	try


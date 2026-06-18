.586
.model flat, stdcall

extern ExitProcess@4:PROC

; The total number of bytes in double word format is given.
; Calculate the number of full megabytes and the number of bytes
; remaining in the last incomplete megabyte
; 1 MB = 1024 KB
; 1 KB = 1024 bytes

.data
TotalBytes	dword	<some value> 
Megabytes	
Leftover 	

.code
start proc


	push	0
	call	ExitProcess@4
start endp
	end	start        


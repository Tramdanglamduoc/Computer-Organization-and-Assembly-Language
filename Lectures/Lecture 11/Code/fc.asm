.186
.model small
option casemap:none
.stack

.data
msg    byte	"Now the clock is 4 times faster!", 13, 10, "$"


.code
.startup
main	proc
	mov 	al, 00110110b 	; 00-channel 2, 11-2 bytes, 011-mode 3, 0-bin
	out	43h, al		; set command register
; Set value of the PIT counter 
	mov	ax, 0FFFFh	; max counter value 
	shr	ax, 2		; counter/4 - timer interrupt will happen 4 times more often
	out	40h, al		; set channel 0 latch register - low order byte from ax
	mov	al, ah		;
	out	40h, al		; high order byte from ax

; Message on screen
	mov     ah, 9
	mov	dx, offset msg 
	int     21h		
.exit
main	endp
end

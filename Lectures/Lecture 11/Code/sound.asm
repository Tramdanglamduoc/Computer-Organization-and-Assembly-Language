.186
.model small
option casemap:none

.stack

.data
msg1     byte	"Start sound", 13, 10, "$"
msg2     byte	"Stop sound", 13, 10, "$"

.code
.startup
main	proc
; Set value of the PIT counter 
	mov 	al, 10110110b 	; 10-channel 2, 11-2 bytes, 011-mode 3, 0-bin
	out	43h, al		; set command register
	mov	ax, 1193	; counter value ax = 1193182 Hz / 1000 Hz
	out	42h, al		; set latch register - low order byte from ax
	mov	al, ah		; and
	out	42h, al		; high order byte from ax

; Open gates	
	in	al, 61h		; read port 61h
 	or	al, 00000011b	; set bits to open gates
	out	61h, al		; open gates to start sound

; Put start message on screen
	mov     ah, 9
	mov	dx, offset msg1 
	int     21h		; message "Start"

; Do something for a few seconds
	mov	cx, 10000	;looping (100 million times)
l2:	push	cx
	mov	cx, 10000
l1:	loop	l1
	pop	cx
	loop	l2

; Close gates to stop sound
	in	al, 61h		; read port 61h
	and	al, 11111100b	; set bits to close gates
	out	61h, al		; close gates to stop sound

; Put stop message on screen
	mov     ah, 9
	mov	dx, offset msg2 
	int     21h		; message "Stop"
.exit
main	endp
end

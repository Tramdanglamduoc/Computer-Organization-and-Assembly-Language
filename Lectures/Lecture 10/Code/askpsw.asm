; Simple text input and output
; Code example for 16-bit environment
.186
.model small
option casemap:none

.stack

.data
psw	byte	'qwerty12'
len	byte	8
msg0	byte	"Try to enter correct password. Enter empty string to finish.", "$"
msg1	byte	13,10,"Password:$"
msgOK	byte	13, 10,'Correct! $'
msgBad	byte	13, 10,'Wrong! $'

inbuff	byte	80, 0, 82 dup (0FFh)

.code
.startup
	mov     ah,9
        mov	dx, offset msg0
        int     21h
ask:	mov     ah,9
        mov	dx, offset msg1
        int     21h

	mov	ah, 0Ah
	mov	dx, offset inbuff
	int	21h

	xor	cx, cx
	mov	cl, inbuff+1
	cmp	cl, 0
	je	finish	
	cmp	cl, len
	jne	bad

	xor	si, si
	
t:	mov	al, inbuff+2[si]
	cmp	al, psw[si]
	jne	bad
	inc	si
	loop	t

good:   mov     dx, offset msgOK
	jmp	output
bad:  	mov     dx, offset msgBad

output:	mov     ah,9
        int     21h
	jmp	ask

finish:	
.exit	0
	end
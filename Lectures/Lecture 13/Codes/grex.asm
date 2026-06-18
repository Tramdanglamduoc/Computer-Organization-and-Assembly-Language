.186
.model small
option casemap:none
.stack

.code
.startup
main 	proc		
; set graphics mode	
	mov	ah, 0	; function 0 - set videomode
	mov 	al, 12h	; al = videomode 12h (640X480 pixels, 16 colors)
	int 	10h	; BIOS interrupt 
	
; fill all pixels of the screen with the same color
	mov	cx, 480	; number of rows
	mov	si, 0	; si = row no.
row:	push	cx
	
	mov	cx, 640	; number of pixels per row
	mov	di, 0	; di = col no.
col:	push	cx

	; call procedure putpx to draw one pixel	
	push    di	; parameter x
	push    si	; parameter y
	push    2	; parameter colour green
	call 	putpx

	inc	di	; col+1
	pop	cx
	loop	col	; loop columns

	inc	si	; row+1
	pop	cx
	loop	row	; loop rows

; wait for Enter key
	mov	ah, 0	; BIOS function 
	int	16h	; to wait for Enter key

; switch to text mode
	mov	ah, 0	; 0 - set videomode
	mov 	al, 3	; al = text mode
	int 	10h
.exit
main	endp

;==================================================
putpx	proc
; Procedure to write one pixel on 640x480 VGA 16 color screen
; Parameters: X, Y, COLOUR
	push	bp	;save bp
	mov	bp,sp	;top of the stack
	push	ax	;save registers
	push	bx
	push	cx
	push	dx
	push	es
X	equ	[bp+8]	;first parameter 
Y	equ	[bp+6]	;second parameter
COLOUR	equ	[bp+4]	;third parameter

	; calculate offset in the video memory
	mov	ax, Y
	mov 	dx, 80
	imul	dx	; 80*Y
	mov	bx, X
	shr	bx, 3	; X/8
	add	bx, ax	; bx = offset=80*Y+X/8
	mov	ax, 0A000h
	mov	es, ax	; es = segment of the video memory

	;prepare bit mask
	mov	ax, X		; ax = X
	mov	dl, 8		
	idiv	dl		; ah=remainder
	mov	cl, ah		; calculated position of the bit
	mov	ah, 10000000b	; mask to shift
	shr	ah, cl		; ah = bit mask
	
	; set write mode 2
	mov	dx, 3CEh
	mov	al, 5		; register 5 of the graphics controller 
	out	dx, al
	inc	dx
	mov	al, 2
	out	dx, al		; port 3CF <= write mode 2
	; set bit mask
	mov	dx, 3CEh
	mov	al, 8		; register 8 of the graphics controller
	out	dx, al
	inc	dx
	mov	al, ah		; port 3CF <= bit mask
	out	dx, al
	; set planes mask (all planes)
	mov	dx, 3C4h
	mov	al, 2		; register 2 of the Sequencer
	out	dx, al
	inc	dx
	mov	al, 00001111b	; all 4 planes
	out	dx, al

	;  write a pixel
	mov	al, es:[bx]	;read the byte from video memory to fill latch registers	
	mov	ax, COLOUR	;ax = third parameter (word)
	mov	es:[bx], al  	;write the data byte to video memory (lower 4 bits = color)

	pop	es	; restore registers from the stack
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret	6	; adjust top of the stack (3 parameters = 6 bytes)
putpx	endp

end

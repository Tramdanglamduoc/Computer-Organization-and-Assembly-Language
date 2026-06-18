;	The programm calls procedures putpx and putpxb to draw 
;	pixels on 640x480 VGA 16 color screen 
.186
.model small
option casemap:none

.stack

.data
time1		word	?
time_own	word	?
msg_own	 	byte	'Our own  procedure  putpx   takes '
buff_own 	byte	'      ',' ticks', 10,13,'$'
time_bios	word	?
msg_bios 	byte	'Procedure putpxb using BIOS takes '
buff_bios 	byte	'      ',' ticks', 10,13,'$'

.code
.startup
main	proc
;-------- switch to graphic mode -----------------------------
	mov	ah, 0	; 0 - set videomode
	mov 	al, 12h	; al = videomode 640X480 pixels 16 colors
	int 	10h
;-------- fill the screen using procedure putpx --------------
	mov	ah,0
	int	1Ah	; read tick counter = cx(high) dx(low)
	mov	time1, dx
	
	mov	si, 0	; row no.
	mov	cx, 480	; rows
r1:	push	cx

	mov	di, 0	; col no.	
	mov	cx, 640	; cols
c1:	push	cx
	
	push    di	; parameter x
	push    si	; parameter y
	mov 	ax, di		; calculate color
	mov	dx, si		; of the pixel as 
	imul	dl		; x*y
	push    ax	; parameter color
	call 	putpx

	inc	di	; col+1
	pop	cx
	loop	c1	; loop columns

	inc	si	; row+1
	pop	cx
	loop	r1	; loop rows

	mov	ah,0
	int	1Ah	; read tick counter = cx(high) dx(low)
	; calculate time
	sub	dx,time1
	mov	time_own, dx

	mov	ah, 0
	int	16h	; wait for Enter key

;-------- fill the screen using BIOS function in the procedure putpxb ------
	mov	ah, 0	; 0 - set videomode
	mov 	al, 12h	; al = videomode 640X480 pixels 16 colors
	int 	10h

	mov	ah,0
	int	1Ah	; read tick counter = cx(high) dx(low)
	mov	time1, dx

	mov	si, 0	; row no.
	mov	cx, 480	; rows
r2:	push	cx

	mov	di, 0	; col no.	
	mov	cx, 640	; cols
c2:	push	cx
	
	push    di	; parameter x
	push    si	; parameter y
	mov 	ax, di		; calculate color
	add	ax, si		; of the pixel as x+y
	push    ax	; parameter color
	call 	putpxb

	inc	di	; col+1
	pop	cx
	loop	c2	; loop columns

	inc	si	; row+1
	pop	cx
	loop	r2	; loop rows

	mov	ah,0
	int	1Ah	; read tick counter = cx(high) dx(low)
	; calculate time
	sub	dx,time1
	mov	time_bios, dx

;----- wait for Enter key------
	mov	ah, 0	; BIOS function 0 - wait for Enter key
	int	16h	; BIOS interrupt for keyboard
;----- restore to the text mode------
	mov	ah, 0	; BIOS function 0 - set videomode
	mov 	al, 3	; al = text mode
	int 	10h	; BIOS interrupt for video

;----- show timing messages-----------
	push	time_own
	push	offset buff_own
	call	Bin2Txt
	mov	ah, 9
	lea	dx, msg_own
	int	21h
	
	push	time_bios
	push	offset buff_bios
	call	Bin2Txt
	mov	ah, 9
	lea	dx, msg_bios
	int	21h

.exit
main	endp

;============================================================
putpx	proc	near
; Procedure to write one pixel on 640x480 VGA 16 color screen
; Parameters: x, y, color
	push	bp	;save bp
	mov	bp,sp	;top of the stack
	push	ax	;save registers
	push	bx
	push	cx
	push	dx
	push	es
X	equ	[bp+8]	;first parameter
Y	equ	[bp+6]	;second parameter
COLOR	equ	[bp+4]	;third parameter

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
	mov	al, 5		; register 5
	out	dx, al
	inc	dx
	mov	al, 2
	out	dx, al		; port 3CF <= write mode 2
	; set bit mask
	mov	dx, 3CEh
	mov	al, 8		; register 8
	out	dx, al
	inc	dx
	mov	al, ah		; port 3CF <= bit mask
	out	dx, al
	; set planes mask (all planes)
	mov	dx, 3C4h
	mov	al, 2
	out	dx, al
	inc	dx
	mov	al, 00001111b
	out	dx, al

	;  write a pixel
	mov	al, es:[bx]	;read byte from video memory to fill latch registers	
	mov	ax, COLOR
	mov	es:[bx], al  	;write data byte (lower 4 bits = color)

	pop	es	; restore registers
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret	6	; adjust stack (3 parameters in word format)
putpx	endp

;============================================================
; Procedure to write one pixel on 640x480 VGA 16 color screen 
; using BIOS interrupt
; Parameters: x, y, color

putpxb	proc	near
	push	bp
	mov	bp,sp
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
X	equ	[bp+8]
Y	equ	[bp+6]
COLOR	equ	[bp+4]

; BIOS interrupt int 10h, 
; AH=0Ch - write pixel, AL=Color, BH=PageNum, CX=x, DX=y
	mov	bh,0
	mov	cx,X
	mov	dx,Y
	mov	ax,COLOR
	mov	ah,0Ch
	int	10h	; use BIOS to write one pixel

	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	bp
	ret	6
putpxb	endp
;==================================================
Bin2Txt proc near
;Procedure Bin2Txt   converts 16-bit value to ASCII text
;Parameters: value to convert, pointer to the text buffer
	push bp
	mov  bp, sp	
	push ax  
     	push bx
     	push cx
     	push dx
	mov  bx, [bp+4] ; buff pointer
     	add  bx, 5	; the last symbol at buf+5
     	mov  cx, 10	; decimal base
	mov  ax, [bp+6] ; binary value to convert
loop1:	xor  dx, dx   	; unsigned ax => dx:ax
     	idiv  cx        ; dx:ax/cx = dx - remainder, ax - quotient
     	add  dl, 30h    ; make ASCII digit
     	mov  [bx], dl  	; current digit to buffer
     	cmp  ax, 0     	; quotient = 0?
     	je   skip       ; all digits converted
     	dec  bx		; next position in the buffer
     	jmp  loop1
skip:	pop  dx        ; restore registers
     	pop  cx
     	pop  bx
     	pop  ax
	pop  bp
     	ret  4          
Bin2Txt endp
;==================================================

end

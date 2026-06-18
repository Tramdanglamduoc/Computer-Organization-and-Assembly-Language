.186
.model small
option casemap:none
.stack

.data
row	word	13
col	word	39

.code
.startup
main	proc

	mov	ax, row
	mov	bx, col

	; calculate offset in the video memory 
	dec	ax	; row-1
	mov	dl, 80	; 
	imul	dl	; (row-1)*80
	dec	bx	; col-1
	add	ax, bx	; (row-1)*80 + (col-1)
	add	ax, ax	; *2

	; set address 
	mov	bx, 0B800h
	mov	es, bx	; segment value for text mode video memory
	mov	di, ax	; calculated offset
 
	; write symbols and attributes
	mov	byte ptr es:[di], 'O'	
	mov	byte ptr es:[di+1], 01110100b ; white background, red symbol
	mov	byte ptr es:[di+2], 'K'	
	mov	byte ptr es:[di+3], 01110100b ; white background, red symbol
.exit
main	endp
end

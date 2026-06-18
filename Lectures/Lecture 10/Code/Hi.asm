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
	dec	ax	; row-1
	mov	dl, 80	; 
	imul	dl	; (row-1)*80
	dec	bx	; col-1
	add	ax, bx	; (row-1)*80 + (col-1)
	shl	ax, 1	; *2

	mov	bx, 0B800h
	mov	es, bx
	mov	di, ax
 
	mov	byte ptr es:[di], 'H'	
	mov	byte ptr es:[di+1], 00001010b 
	mov	byte ptr es:[di+2], 'i'	
	mov	byte ptr es:[di+3], 00001010b 
	mov	byte ptr es:[di+4], '!'	
	mov	byte ptr es:[di+5], 10001100b 
.exit
main	endp
end

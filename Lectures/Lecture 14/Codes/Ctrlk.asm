.186
.model small
option casemap:none
.stack

.data
msgInit byte      "Press any key or Esc to exit!", 13, 10, "$"
msgCtrl byte      "Ctrl key is down", 13, 10, "$"

.code
main	proc
.startup
; Show initial message
	mov	ah, 9
	mov	dx, offset msgInit
	int	21h
	
; Check status bit of the Ctrl key at 0000:0417
check:	xor	bx, bx
	mov	es, bx
	mov 	al, es:0417h
	test	al, 00000100b
	jz	noctrl

; Show message that Ctrl key is down	
	mov	ah, 9
	mov	dx, offset msgCtrl
	int	21h

; Wait for key press
noctrl:
	mov	ah, 0	; function 0 - wait for key press
	int	16h	; BIOS service for keybord (returns: ah=scan code, al=ASCII)

; Check scan code of the last key pressed
	cmp	ah, 1 	; Esc?
	jne	check
.exit
main	endp
end
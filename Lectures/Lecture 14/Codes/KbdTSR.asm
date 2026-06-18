; KEYBOARD INTERRUPT HANDLER
; If both Ctrl and LeftShift are down and Backspace is pressed
; show letters KB in the middle of the text screen
.186
.model small
option casemap:none
.stack 100h

.code
;==================TSR code====================
;-------Keyboard interrupt handler procedure
int9h   proc    far	
	push	es	; save registers
	push	ax
	push	bx
	push	di
	sti		; set interrupt flag
;-------Check the current combination of the keyboard keys 
	mov	bx, 0
	mov	es, bx		; segment register es = 0
	mov	ah, es:0417h
	and	ah, 00000110b	; Ctrl and LShift are down?
	cmp 	ah, 00000110b
	jne	retold
	in	al, 60h		; read scan code of the last key pressed
	cmp	al, 14		; BackSpace scan code ?
	jne	retold
;-------Perform activities if the combination currently is on
	mov	bx, 0B800h
	mov	es, bx
	mov	di, 1996
	mov	byte ptr es:[di], 'K'
	mov	byte ptr es:[di+1], 01110100b ; red letter on white background
	mov	byte ptr es:[di+2], 'B'
	mov	byte ptr es:[di+3], 01110010b ; green letter on white background
;-------Return from hardware interrupt handler
	mov	al, 20h
	out	20h, al
	pop	di
	pop	bx
	pop 	ax
	pop	es
	iret
;-------Transfer control to the previous interrupt handler
retold:
	pop	di	; restore registers
	pop	bx
	pop 	ax
	pop	es
	jmp	cs:[oldint9]	; jump to entry point of the previous handler

int9h   endp

;--------Data used by the interrupt handler
oldint9	dword	0
flag	byte  	'LRKBDU'

highaddr:	; Keep the code in memory up to this address

;===============Startup code============================
main	proc			; Entry point of the startup code
	push	cs		; Data is stored in the code segment
	pop	ds		; so copy cs to ds
;---------Check the flag of the current keyboard interrupt handler
	mov    si, offset flag	; offset of the flag in the our ISR
	mov    ax,3509h		; Get entry point of the currently active ISR in es:bx
	int    21h		; es = segment of the active handler
	mov    di, si	
	add    di, bx		; di = offset in the active ISR where the flag should be 
				; es:di = address of the flag in the currently active ISR
	mov    cx,6					
   repe   cmpsb		 	; es:di == ds:si?, i.e. compare 6 flag bytes of our ISR with 6 bytes in the active ISR
        jne    activate		; flags do not match, activate our ISR

	lea    dx, msgerr  	; matching flags, i.e. the current ISR is already our own ISR
	mov    ah,9
	int    21h		; show message

	mov    ah, 4Ch		; terminate process
	mov    al, 0		; return code
	int    21h		

activate:
;---------Get and save entry point address of the current (previous) interrupt ISR
	mov	ax, 3509h 		; function 35h interrupt 09h
	int	21h			; read interrupt vector in es:bx
	mov	word ptr oldint9, bx	; save offset of the entry point address of the current ISR
	mov	word ptr oldint9+2, es	; save segment of the entry point address of the current ISR
;---------Set new interrupt vector - entry point address of our ISR int9h
	mov	dx, offset int9h	; dx = entry point offset of our ISR, ds = cs
	mov	ax, 2509h		; function 25h, interrupt 09h
	int	21h			; write interrupt vector from ds:dx
;---------Show message on screen that new ISR is active
	lea	dx, msgOK
	mov	ah, 9
	int	21h

;---------Exit and keep the ISR code in memory
	mov	dx, offset highaddr
	add	dx, 10Fh	; add size of the PSP and round up to the paragraph
	shr	dx, 4		; divide by 16
	mov	ax, 3100h	; function 31h, return code 00h
	int	21h	; return to operating system and keep the code of our ISR in memory 
main	endp
;---------Data used by the startup code
msgOK	byte	"Keyboard driver is active!",13,10,'$'
msgerr	byte    "Keyboard driver is already active!",13,10,'$'

end main
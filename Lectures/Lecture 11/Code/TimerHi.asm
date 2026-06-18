; TIMER INTERRUPT HANDLER 
; After each 10 seconds writes Hi! in the middle of the text screen 
; using different foreground and background colors
.186
.model small
option casemap:none

.stack	100h

.code
;============Interrupt handler procedure=======
int8h   proc    far	
	push	es		; save registers
	push	ax
	push	di

	sti			; set interrupt flag

	inc	cs:color	; change value of colors to be used for the text otput
;-------Check time interval 
	inc	cs:ticks	; data is stored in the code segment, so use cs for addressing
	cmp	cs:ticks, 182	; 182 ticks (10 seconds) elapsed?
	jl	retold		; if less then transfer control to the previous ISR
	mov	cs:ticks, 0	; else set tick counter to zero

;-------The time interval elapsed so write Hi! in the middle of the screen
	mov	ax, 0B800h	; segment value of the text mode video memory
	mov	es, ax
	mov	di, 1996	; offset of the 13th row, 39th column in the text mode video memory
				; ((13-1)*80 + (39-1))*2 = 1996
	mov	al, cs:color	; attribute byte
	mov	byte ptr es:[di], 'H'	
	mov	byte ptr es:[di+1], al
	mov	byte ptr es:[di+2], 'i'	
	mov	byte ptr es:[di+3], al
	mov	byte ptr es:[di+4], '!'	
	mov	byte ptr es:[di+5], al

;-------Transfer control to the previous ISR
retold:	pop	di		; restore registers
	pop	ax
	pop	es
	jmp	cs:[oldint8]	; transfer control
int8h   endp
;--------Data used by our interrupt handler
oldint8 dword	0		; saved entry point address of the previous handler
ticks	word	0		; ticks elapsed
color	byte	00100111b	; text and background colors
flag	byte	'MYTIMER' 	; a flag to prevent multiple copies of the handler

highaddr:			; Keep the code in memory up to this address

;===============Startup code============================
;--------Data used by the startup code
msgInit	byte	  'TimerHi will display text "Hi!" in the centre of the screen every 10 seconds',13,10,'$'
msgok	byte      'TimerHi activated',13,10,'$'
msgerr	byte      'TimerHi is already active!',13,10,'$'

main	proc			; Entry point of the startup code
	push	cs		; Data is stored in the code segment
	pop	ds		; so copy cs to ds
;------Check flag bytes of the currently active interrupt handler
	mov	si, offset flag	; offset of the flag in our ISR
	xor	ax, ax
	mov	es, ax		; segment 0
	mov	bx, es:[4*8]	; entry point offset from the interrupt vector
	mov	ax, es:[4*8+2]	; entry point segment from the interrupt vector
	mov	es, ax		; 
	mov	di, si	
	add	di, bx		; di = offset in the active ISR where the flag should be 
				; es:di = address of the flag in the currently active ISR
	mov    cx,6					
   repe cmpsb		 	; es:di == ds:si?, i.e. compare 6 flag bytes of our ISR with 6 bytes in the active ISR
        jne    activate		; flags do not match, activate our ISR

	lea    dx, msgerr  	; matching flags, i.e. the current ISR is already our own ISR
	mov    ah,9
	int    21h		; show message

	mov    ah, 4Ch		; terminate process
	mov    al, 0		; return code
	int    21h		

activate:
	mov	dx, offset msgInit	
	mov	ah, 9
	int	21h			
;---------Get and save the entry point address of the currently active ISR
	mov	ax, 0
	mov	es, ax			; segment 0
	mov	bx, es:[4*8]		; offset value from interrupt vector
	mov	word ptr oldint8, bx	; save offset value of the entry point address of the active ISR
	mov	ax, es:[4*8+2]		; segment value from interrupt vector
	mov	word ptr oldint8+2, ax	; save segment value of the entry point address of the active ISR
;---------Set new interrupt vector - entry point address of our handler int8h
	mov	es:[4*8], offset int8h	; entry point offset of the new interrupt handler
	mov	ax, cs
	mov	es:[4*8+2], ax		; entry point segment of the new interrupt handler
;---------Show message that our timer interrupt handler is active
	mov	dx, offset msgok
	mov 	ah, 9
	int	21h
;---------Exit and keep our handler code in memory
	mov	dx, offset highaddr
	add	dx, 10Fh	; add the size of the PSP and round up to the paragraph
	shr	dx, 4		; divide by 16
	mov	ax, 3100h	; function 31h, return code 00h
	int	21h	; return to the system and keep the code of our ISR in memory 
main	endp
end	main

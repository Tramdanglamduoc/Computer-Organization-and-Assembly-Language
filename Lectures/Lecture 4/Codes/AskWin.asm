; Example of the Windows dialog app using .inc files with PROTO directives 
; and invoke directives to call API functions

.586
.model flat, stdcall
option casemap:none

include	windows.inc
include	user32.inc
include	kernel32.inc
include	winmm.inc

includelib user32.lib 
includelib winmm.lib 
includelib kernel32.lib

.data
Caption		byte	"My Windows Dialog",0
Text		byte	"Would you like to move cursor and play sound?",0
Soundfile 	byte	"Ring10.wav",0

.code
main proc

	invoke	MessageBox,NULL,offset Text,offset Caption,MB_YESNO+MB_ICONQUESTION

	cmp	eax, IDYES
	jne	finish

	invoke	SetCursorPos, 100, 200

	invoke PlaySound, offset Soundfile, 0, SND_FILENAME

finish:
	invoke	ExitProcess,0
main    endp
        end main
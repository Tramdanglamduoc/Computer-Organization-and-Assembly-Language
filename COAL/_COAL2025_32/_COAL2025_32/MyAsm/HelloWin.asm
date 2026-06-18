; Simple Windows dialog app to say Hello

.586
.model flat, stdcall
option casemap:none

include	windows.inc
includelib user32.lib 
includelib kernel32.lib

extern	MessageBoxA@16:PROC
extern	ExitProcess@4:PROC

.stack 4096

.data
Caption	byte "My First Windows Program",0
Text	byte "Hello!",0

.code
WinMain PROC

	push	MB_OK + MB_ICONEXCLAMATION
	push	offset Caption
	push	offset Text
	push	0
	call	MessageBoxA@16

	push	0
	call	ExitProcess@4

WinMain ENDP
	end	WinMain
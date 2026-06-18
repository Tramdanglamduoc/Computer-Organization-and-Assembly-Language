; Simple Assembly program with no output
; to calculate perimeter of the rectangle
;	mov	eax, 3
;	add	eax, 4
;	add	eax, eax
;	ret

.586
.MODEL flat, stdcall
OPTION casemap:none

.CODE
Rect	byte	0b8h, 03h, 00h, 00h, 00h, 83h, 0c0h, 04h, 03h, 0c0h, 0c3h

	END Rect

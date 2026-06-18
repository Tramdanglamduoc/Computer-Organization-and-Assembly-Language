.186
.model small
option casemap:none

.stack

.data
msg	byte "Hi! This is executable code in .EXE format for 16-bit environment",13,10,'$'

.code
.startup		; directive to prepare segment addressing
main proc

    mov dx, offset msg	; parameter for the system call - address of the message
    mov ah, 9		; parameter for the system call - function 9 - console output
    int 21h		; software interrupt to execute a system call

.exit 0			; directive to return to the operating system
main endp

end
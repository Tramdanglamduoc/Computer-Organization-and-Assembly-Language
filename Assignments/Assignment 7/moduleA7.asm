
.186
.model small
option casemap:none

.stack  100h

; Full Name: Ngoc Bao Tram Tran
; Student ID: 231ADB294
; Assignment: A7 - Writing an Interrupt Service Routine
; Task: Play a sound signal every second, starting at 10000 Hz and decreasing the frequency by two each time, 
; i.e. 10000, 5000, 2500 Hz etc., but not below the lowest possible frequency.
; After the lowest possible frequency, do not play any more sound


.code
; === Your interrupt handler procedure ===
int8h   proc far 

    ; Save registers
    push ax
    push bx
    push cx
    push dx
    ; push ds
    ; push es
    ; push si
    ; push di

    ;sti                     ;  set interrupt flag - allow nested Hardware interrupts if needed 

    ; If beeping, count down and stop speaker when done
    cmp word ptr cs:beepTicks, 0
    je  check_second

    dec word ptr cs:beepTicks
    jnz check_second

    ; Stop speaker - stop beeping: clear bits 0 and 1 on port 61h
    in  al, 61h ; read port 61h
    and al, 11111100b ; disable gate and speaker
    out 61h, al


check_second:
    ; Count timer ticks. Timer fires 18.2 times per sec,
    ; so 18 ticks is about 1 second

    inc     word ptr cs:tickCnt

    mov     al, cs:tickTarget
    xor     ah, ah                  ; AX = 18 or 19
    cmp     word ptr cs:tickCnt, ax
    jb      retold                  ; not yet "one second"

    mov     word ptr cs:tickCnt, 0           ; second boundary reached

        ; ---- decide tickTarget for the NEXT second ----
    ; We need +0.2 tick/sec => +2 tenths each second.
    mov     al, cs:fracAcc
    add     al, 2
    cmp     al, 10
    jb      short set18

    sub     al, 10
    mov     cs:fracAcc, al
    mov     byte ptr cs:tickTarget, 19
    jmp     short second_work

set18:
    mov     cs:fracAcc, al
    mov     byte ptr cs:tickTarget, 18

second_work:
    ;  checks: active, curFreq, divisor calc, beep, shr curFreq, ...

    ; If finished already, do nothing.
    cmp     byte ptr cs:active, 0
    je      retold


    ; If curFreq == 0 => finished
    mov     bx, cs:curFreq
    cmp     bx, 0
    je      stop_all

    ; If the frequency is too low (the divisor will be > FFFFh), then stop
    cmp     bx, 19
    jb      stop_all

    ; Compute PIT divisor = 1193182 / frequency
    mov     dx, 0012h               ; high word 
    mov     ax, 34DEh               ; low  word ;Note: 1193182 decimal = 0x0012 34DE hex
    div     bx                      ; AX = divisor, DX = remainder


    ; If divisor would exceed 65535, PIT can't go lower.
    ; The DIV instruction here already yields AX in 0..65535,
    ; but we also enforce a minimum frequency threshold.
    mov word ptr cs:lastDiv, ax


    ; If divisor is zero, frequency too high -> stop
    cmp ax, 0 
    je stop_all

    ; If divisor > 65535, frequency too low -> stop
    ; cmp ax, 65535
    ; ja stop_all


    ; Program PIT channel 2, mode 3
    ; load low byte then high byte.
    mov al, 10110110b ; channel 2, low byte/high byte, mode 3, binary
    out 43h, al
    mov al, byte ptr cs:lastDiv 
    out 42h, al ; low byte
    mov al, byte ptr cs:lastDiv+1
    out 42h, al ; high byte


    ; Enable speaker + gate (bits 0 and 1) and beep briefly
    in  al, 61h
    or  al, 00000011b
    out 61h, al

    mov word ptr cs:beepTicks, 4         ; 4 ticks = 220ms = 0.22s short beep each second

    ; Update frequency: Divide frequency by 2
    ; 10000 -> 5000 -> 2500 -> ...
    shr cs:curFreq, 1

    ; Stop permanently once we go below the lowest usable
    ; frequency. Practical lowest is 1193182/65535 nearly = 18 Hz.
    ; We stop when next frequency is below 19 Hz to do not go below.
    ; cmp     cs:curFreq, 19
    ; jae     retold


stop_all:
    ; Disable further sound forever
    mov     byte ptr cs:active, 0
    mov     word ptr cs:curFreq, 0
    mov     word ptr cs:beepTicks, 0

    ; Ensure speaker is OFF
    in      al, 61h
    and     al, 11111100b
    out     61h, al


retold:
    ; Restore registers and chain to old ISR 
    ; pop     di
    ; pop     si
    ; pop     es
    ; pop     ds
    pop     dx
    pop     cx
    pop     bx
    pop     ax


    jmp   dword ptr cs:[oldint8]            ; chain to previous INT 8 (keeps BIOS time)


int8h   endp

; --- Data used by the interrupt handler ---
; Resident data
oldint8 dd 0                ; saved entry point address of the previous handler (store old offset + old segment)
tickCnt  dw 0               ; counts timer ticks (0..17)
beepTicks dw 0              ; duration of beep in ticks
active   db 1               ; 1=play sequence, 0=stop forever
curFreq  dw 10000           ; starts at 10000 Hz
lastDiv  dw 0               ; stores last PIT divisor
tickTarget db 18            ; current target ticks for ~1 second (18 or 19)
fracAcc    db 0             ; accumulator in tenths (0..9)


; Keep the code in memory up to this address
highaddr:

; === Startup code ===
; runs once, installs ISR, then stays resident
main:               ; Entry point of the startup code
    push    cs      ; Data is stored in the code segment
    pop     ds      ; so copy cs to ds

    mov     dx, offset msgInit  
    mov     ah, 9
    int     21h         
; Get and save the entry point address of the currently active ISR
    mov     ax, 0
    mov     es, ax                  ; segment 0
    mov     bx, es:[4*8]            ; offset value from interrupt vector
    mov     word ptr oldint8, bx    ; save offset value of the entry point address of the active ISR
    mov     ax, es:[4*8+2]          ; segment value from interrupt vector
    mov     word ptr oldint8+2, ax  ; save segment value of the entry point address of the active ISR

; Set new interrupt vector - entry point address of our handler int8h   
    cli
    mov     es:[4*8], offset int8h  ; entry point offset of the new interrupt handler
    mov     ax, cs
    mov     es:[4*8+2], ax          ; entry point segment of the new interrupt handler
    sti

; Show message that our interrupt handler is active
    mov     dx, offset msgOK
    mov     ah, 9
    int     21h

; Exit and keep our handler code in memory
    lea     dx, highaddr
    add     dx, 10Fh    ; add size of the PSP and round up to the paragraph
    shr     dx, 4       ; divide by 16
    mov     ax, 3100h   ; function 31h, return code 00h
    int     21h         ; return to the system and keep the code of our ISR in memory 

; Data used by the startup code
msgInit DB 'A7 TSR: Beep each second: 10000Hz -> /2 -> stop at lowest',13,10,'$' ; update to reflect the assigned task description
msgOK   DB 'Interrupt Service Routine is activated',13,10,'$'

end main
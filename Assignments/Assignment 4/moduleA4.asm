.586
.MODEL flat, stdcall
OPTION casemap:none

includelib kernel32.lib
extern ExitProcess@4:PROC

.CONST
; Adjust input string as appropriate for a task A variant
S1  DB  ".,!?:;-", 0

; Adjust input string as appropriate for a task B variant
S2  DB  "A!  BC, D.", 0

.DATA?
; A memory for storing the result integer value of the task A calculations
R1  DD  ?

; A memory for storing the result string of the task B calculations
R2  DB  256 DUP(?)

; It is prohibited to introduce additional variables!
; For temporal data storage use available processor registers and/or stack memory.

; Paste the assigned tasks variant description for a reference:
; Task A: ...
; Task B: ...


.CODE
A4:
TaskA:
    ; Task A solution
    ; initialization and validations before the loop
    lea     ESI, S1     ; inital offset in S1
    ; :::
    xor     EAX, EAX
LoopA:
    cmp     byte ptr [ESI], 0   ; addressing a char element of an array
    je      EndA                ; has reached the end of input string
    ; other intermediate calculations and/or conditional jumps
    ; :::
NextA:
    inc     ESI         ; adjust to the next element
    jmp     LoopA       ; repeat
EndA:
    mov     R1, EAX     ; store the result

TaskB:
    ; Task B solution   
    ; :::

Exit:
    push    0
    call    ExitProcess@4

    END A4
.586
.MODEL flat, stdcall
OPTION casemap:none

includelib kernel32.lib
extern ExitProcess@4:PROC

.CONST
; Adjust input values if appropriate for a task A input
A1  DD  60000, 90988, 50202, -350, 4444, 5678, 54366, 70, -80000, 0
S1  EQU LENGTHOF A1

; Adjust input values if appropriate for a task B input
A2  DD  -901, -101, 200, -303, 400, -505, 600, -701, 800, 0
S2  EQU LENGTHOF A2

.DATA?
; A memory for storing the result of the task A calculations
AR  DD  ?
; A memory for storing the result of the task B calculations
BR  DD  ?

; It is prohibited to introduce additional variables!
; For temporal data storage use available processor registers and/or stack memory.

; Paste the assigned tasks for a reference:
; Task A: ...
; Task B: ...


.CODE
A3:
    ; Task A solution
    ; initialization and validations before the loop
    lea     ESI, A1     ; inital offset in A1
    mov     ECX, S1     ; LoopA counter
    xor     EAX, EAX    ; initial output value
    ; :::
LoopA:
    cmp     dword ptr [ESI], 0 ; addressing DWORD element of an array
    ; other intermediate calculations and/or conditional jump to the label NextA
    ; :::
NextA:
    add     ESI, 4      ; adjust to the next array element
    loop    LoopA       ; repeat
    mov     [AR], EAX   ; store the result

TaskB:
    ; Task B solution   
    ; :::

Exit:
    push    0
    call    ExitProcess@4

    END A3
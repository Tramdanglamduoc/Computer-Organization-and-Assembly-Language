.686
.MODEL flat, stdcall
OPTION casemap:none

includelib kernel32.lib
extern ExitProcess@4:PROC

.CONST
; Adjust input values if appropriate for a task A input
MA  DD  0, -1500, 2500, 70000
    DD  3500, 4500, -5500, -80000

; Adjust input values if appropriate for a task B input
MB  DD  -901, -101, 200, 400
    DD  600, -701, 800, 0

; input array M1 and M2 dimensions
ROWS EQU 2;
COLS EQU 4;

.DATA?
; An output array for storing the result of the task A calculations
; (adjust according to the assigned variant)
RA  DD  ROWS DUP(?)

; An output array for storing the result of the task B calculations
; (adjust according to the assigned variant)
RB  DD  COLS DUP(?)

; It is prohibited to introduce additional variables!
; For temporal data storage use available processor registers and/or stack memory.

; Paste the assigned tasks variant description for a reference:
; Task A: ...
; Task B: ...


.CODE
A5:
TaskA:
    ; Task A solution
    ; initialization and validations before the loop
    lea     ESI, MA     ; inital offset in MA
    lea     EDI, RA     ; inital offset in RA
    mov     ECX, ROWS   ; change to ROWS or COLS according to the assigned variant
    ; :::
LoopA1:                 ; outer loop
    push    ECX
    mov     ECX, COLS   ; change to ROWS or COLS according to the assigned variant
    ; :::
LoopA2:                 ; inner loop
    cmp     dword ptr [ESI], 0 ; addressing DWORD element of an array
    ; :::               ; other intermediate calculations and/or conditional jump
NextA2:
    add     ESI, 4
    loop    LoopA2       ; repeat inner loop

NextA1:
    mov     [EDI], EAX   ; store the result
    add     EDI, 4
    ; :::
    pop     ECX
    loop    LoopA1       ; repeat outer loop

TaskB:
    ; Task B solution   
    ; :::

Exit:
    push    0
    call    ExitProcess@4

    END A5
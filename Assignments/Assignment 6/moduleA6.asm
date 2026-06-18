; moduleA6.asm  (A6 – max 10)
; Entry point for executable.
; Calls procedures from moduleA4.asm and moduleA5.asm
; using both CALL and INVOKE with different arguments.

.686
.MODEL flat, stdcall
OPTION casemap:none

; Grade Level 10:
; Implement new moduleA6.asm, which has entry point for executable and calls implemented procedures in the moduleA4.asm
; and the moduleA5.asm each several times demonstrating the use of the instruction CALL 
; and the assembler directive INVOKE with different arguments for various scenarios.


; External procedures from moduleA4 and moduleA5
; (prototypes needed for INVOKE)

; from moduleA4.asm 
A4_TaskA PROTO :PTR BYTE                     ; prototype declaration for procedure A4_TaskA
A4_TaskB PROTO :PTR BYTE, :PTR BYTE          ; prototype declaration for procedure A4_TaskB

; from moduleA5.asm 
A5_TaskA PROTO :PTR DWORD, :PTR DWORD        ; prototype declaration for procedure A5_TaskA
A5_TaskB PROTO :PTR DWORD, :PTR DWORD        ; prototype declaration for procedure A5_TaskB

includelib kernel32.lib
extern ExitProcess@4:PROC


.CONST
; Adjust input string as appropriate for a task A variant of moduleA4.asm
S1  DB  "[]", 0          ; DB is one byte 

; Adjust input string as appropriate for a task B variant of moduleA4.asm
S2  DB  "A!  BC, D.", 0

; Adjust input values if appropriate for a task A input of moduleA5.asm
MA  DD  0, 0, 0, 0
    DD  0, 0, 0, 0

; Adjust input values if appropriate for a task B input of moduleA5.asm
MB  DD  0, 0, 0, 0
    DD  0, 0, 0, 0

; input array M1 and M2 dimensions
ROWS EQU 2         ; number of rows
COLS EQU 4         ; number of columns


.DATA?
; A memory for storing the result integer value of the task A calculations
R1  DD  ?          ; used for A4_TaskA result for moduleA4.asm

; A memory for storing the result string of the task B calculations
R2  DB  256 DUP(?) ; used for A4_TaskB result for moduleA4.asm

; An output array for storing the result of the task A calculations (matrix tasks)
RA  DD  ROWS DUP(?)    ; used for A5_TaskA results for moduleA5.asm

; An output array for storing the result of the task B calculations (matrix tasks)
RB  DD  ROWS DUP(?)    ; used for A5_TaskB results for moduleA5.asm

; It is prohibited to introduce additional variables!
; For temporal data storage use available processor registers and/or stack memory.

; My name is Ngoc Bao Tram Tran, student ID 231ADB294
; A4 variant: A0, B1
; Task A: A0 - Store -1 if in the input string the count of opening and closing square brackets matches, otherwise store 0 (false).
; E.g., “[A]” -> -1, “A[[B]” -> 0.

; Task B: B1 - Store a new string by replacing two or more consequent letters in the input string with the single letter following the number of repeats, assuming repeats are up to 9.
; E.g., “ABBBCCCC” -> “AB3C4”.


; A5 variant: A2, B1
; Task A: A2: For each row count the number of odd values (value mod 2 <> 0).
; Task B: B1: In each row find the maximal negative value.


; Code section – entry point and calls


.CODE

start:                                  ; entry point for the executable

    ; Calls to A4_TaskA (string task A)
    ;    - using INVOKE and CALL with different arguments

    ; CALL A4_TaskA with S1
    ; S1 = "[]" -> should give -1 (counts of '[' and ']' match)
    INVOKE A4_TaskA, ADDR S1 ;ADDR R1           ; pStr = &S1 ; if we declare PROTO then INVOKE A4_TaskA with S1
    mov     R1, EAX            ; store result into R1

    ; Side: CALL A4_TaskB with S2
    ; Manual stack setup (stdcall): push parameters right-to-left
    push    OFFSET S2                  ; pStr
    call    A4_TaskA
    ; just for calling, not storing result

    ; ---
    ; Calls to A4_TaskB (string task B)
    ;    - compress repeated letters

    ; CALL A4_TaskB with S2, output in R2 
    ; E.g., if S2 had repeats, they would be compressed.
    ; INVOKE A4_TaskB, ADDR S2, ADDR R2  ; pIn = &S2, pOut = &R2  ; if we declare PROTO then INVOKE A4_TaskB with S2, output in R2 
    ; Manual stack setup: push pOut, then pIn
    push    OFFSET R2                  ; pOut (reuse same buffer)
    push    OFFSET S2                  ; pIn
    call    A4_TaskB
    ; R2 now contains result string


    ; Side: CALL A4_TaskB with S1 as input
    ; Manual stack setup: push pOut, then pIn
    push    OFFSET R1                  ; pOut 
    push    OFFSET S1                  ; pIn
    call    A4_TaskB
    ; Result is stored in R1


    ;---
    ; Calls to A5_TaskA (matrix task A)
    ;    - count odd numbers per row

    ; CALL A5_TaskA with MA -> RA 
    ; INVOKE A5_TaskA, ADDR MA, ADDR RA  ; pInA = &MA, pOutA = &RA ; if we declare PROTO then INVOKE A5_TaskA with MA -> RA 
    ; RA[0], RA[1] now contain odd-count per row of MA

    push OFFSET RA
    push OFFSET MA
    call A5_TaskA


    ; Side: CALL A5_TaskA with MB -> RB 
    ; Use CALL to demonstrate manual argument passing for the same procedure.
    push    OFFSET RB                  ; pOutA
    push    OFFSET MB                  ; pInA
    call    A5_TaskA
    ; RB[0], RB[1] now contain odd-count per row of MB


    ;---
    ; Calls to A5_TaskB (matrix task B)
    ; - find maximal negative in each row (or -1 if none)

    ; CALL A5_TaskB with MB -> RB 
    INVOKE A5_TaskB, ADDR MB, ADDR RB  ; pInB = &MB, pOutB = &RB ; if we declare PROTO then INVOKE A5_TaskB with MB -> RB
    ; RB[0], RB[1] now hold maximal negatives per row of MB (or -1)


    ; Side: CALL A5_TaskB with MA -> RA 
    ; Using CALL to show manual parameter passing.
    push    OFFSET RA                  ; pOutB
    push    OFFSET MA                  ; pInB
    call    A5_TaskB
    ; RA[0], RA[1] now hold maximal negatives per row of MA (or -1)


; Exit the process
ExitProgram:
    push    0
    call    ExitProcess@4

END start

; moduleA5.asm (A6 version)
; Contains only procedures A5_TaskA and A5_TaskB
; Data (MA, MB, RA, RB) has been moved to moduleA6.asm


.686
.MODEL flat, stdcall
OPTION casemap:none


; Grade Level 8: Copy the COAL-A4 submitted assembler module moduleA5.asm to the directory A6, 
; add it to the project A6 and update it to have assembler procedures A5_TaskA and A5_TaskB 
; which implements assigned variants of task by passing arguments via the stack 
; and returning results via accumulator or via output parameter.


; input array M1 and M2 dimensions
ROWS EQU 2; number of rows
COLS EQU 4; number of columns


; Ngoc Bao Tram Tran - 231ADB294
; My task variants are: A2; B1
; Paste the assigned tasks variant description for a reference:
; Task A - Task A2: For each row count the number of odd values (value mod 2 <> 0).
; Task B - Task B1: In each row find the maximal negative value.


.CODE
; A5_TaskA
;   Parameters (passed via stack):
;       pInA  : PTR DWORD  - address of input matrix 
;       pOutA : PTR DWORD  - address of output array 


A5_TaskA PROC PUBLIC USES ESI EDI EBX ECX EDX \   ; procedure header ; Declare procedure Procedure A5_TaskA as being externally accessible
    pInA  : PTR DWORD,                            ; parameter 1
    pOutA : PTR DWORD                             ; parameter 2


    ; TaskA: For each row count the number of odd values (value mod 2 <> 0).
    ; Task A solution - (Row by row processing)
    ; For grade level 7
    ; initialization and validations before the loop
    mov     ESI, pInA     ; inital offset in input matrix
    mov     EDI, pOutA    ; inital offset in output array
    xor     EAX, EAX   ; clear EAX to use it as a counter - storing the number of odd values
    mov     ECX, ROWS   ; 

    
    ; Side case: no input rows (ROWS == 0) ; or negative input rows
    test    ECX, ECX; check if ROWS is zero, we use test instruction to set zero flag if ECX is zero
    jle      No_Input_Data_Values_A; if zero flag is set, jump to Exit

    ; Side case: no input columns (COLS == 0); or negative input columns
    mov     EDX, COLS        ; load number of columns
    test    EDX, EDX         ; check if COLS is zero
    jle      No_Input_Data_Values_A ; if zero, also skip Task A processing

Row_LoopA1:                 ; outer loop; process each row
    push    ECX ; save rows counter - outer loop counter
    
    mov     ECX, COLS   ; initialize inner loop counter - number of columns

Col_LoopA1:				  ; inner loop ; process each column per row
    mov    EBX, dword ptr [ESI]         ; load current element into EBX; EBX = current element value
    
    test  EBX, 1         ; check if the value is odd
    ; because odd numbers have the least significant bit set to 1
    ; so we can use the TEST instruction (which works similar to AND but not change the value of EBX)
    ; and when the result is non-zero after using "test", it means the number is odd
    jz     Even_Number        ; if zero flag is set, the number is even, skip incrementing the counter
    inc     EAX          ; increment the odd counter
    
Even_Number:
    add     ESI, 4       ; move to the next element in the row, each element is 4 bytes (DWORD - DD); it also means that moving to the next column in the same row
    loop    Col_LoopA1   ; repeat inner loop for all columns (to process all elements in the current row)

; Odd_Number_Stored
    mov     [EDI], EAX   ; store the result (number of odd values in the current row)
    add     EDI, 4       ; move to the next position in the output array RA

    xor     EAX, EAX     ; clear EAX for the next row's odd count
    pop     ECX          ; restore rows counter - outer loop counter
    loop    Row_LoopA1   ; repeat outer loop for all rows

No_Input_Data_Values_A:
    ; No valid data for Task A (or Task A finished normally)
    ; This Task A variant does not use division, so division-by-zero is not possible
    ; A5_TaskA is a standalone procedure, so then return to the caller.
    ret ; return to the caller

A5_TaskA ENDP


; A5_TaskB
;   Parameters (passed via stack):
;       pInB  : PTR DWORD  - address of input matrix 
;       pOutB : PTR DWORD  - address of output array 


A5_TaskB PROC PUBLIC USES ESI EDI EBX ECX EDX \   ; procedure header ; Declare procedure Procedure A5_TaskB as being externally accessible
    pInB  : PTR DWORD,                            ; parameter 1
    pOutB : PTR DWORD                             ; parameter 2


; Task B - Task B1: In each row find the maximal negative value.
TaskB: 
    ; Task B solution - (Row by row processing)
    ; initialization and validations before the loop
    ; For grade level 9
    mov     ESI, pInB     ; initial offset - input array
    mov     EDI, pOutB    ; initial offset - output array
    mov     ECX, ROWS   ; number of rows

    ; For grade level 10
    ; Side cases: no input rows or columns 

    ; Side case: No row input data; or negative input rows
    test    ECX, ECX
    jle      No_Input_Data_Values_B   ; skip Task B if no rows

    ; Side case: No column input data; or negative input columns
    mov     EDX, COLS
    test    EDX, EDX
    jle      No_Input_Data_Values_B   ; skip Task B if no columns

Row_LoopB:                 ; outer loop; process each row
    push   ECX         ; save rows counter - outer loop counter
    mov ECX, COLS    ; initialize inner loop counter - number of columns
    ; EAX = will store maximal negative
    xor  EAX, EAX   ; EAX = will store maximal negative

    xor     EBX, EBX      ; EBX = flag: 0 = not found, 1 = found 
    ; clear EBX to use it as a flag to check if we found any negative number
    ; if EBX is 0 after processing the row, it means no negative number was found in that row

Col_LoopB:                ; inner loop ; process each column per row
    mov    EDX, dword ptr [ESI]         ; load current element into EDX; EDX = current element value
    
    cmp    EDX, 0         ; check if the current element is negative
    jge    Not_Maximal_Negative    ; if value of EDX is greater or equal to 0, skip to Not_Maximal_Negative
    ; Not_Maximal_Negative means current element is not negative and also is not maximal negative value in the row, or after updating max and jumping back, so we skip the updating process

    ; If EDX is negative
    cmp    EBX, 0         ; check if this is the first negative number found in the row, or it is not to decide whether to update max negative value - which branch to jump to
    je     First_Negative  ; if EBX is 0, this is the first negative number

    ; If it is not the first negative number, compare with current max negative in EDX
    cmp    EDX, EAX       ; compare current element - EDX with the current max negative value - EAX 
    jle    Not_Maximal_Negative    ; if current element - EDX is less than or equal to max negative - EAX, skip updating
    mov	EAX, EDX       ; if it is greater, update maximal negative value
    jmp    Not_Maximal_Negative

First_Negative:
    mov    EAX, EDX       ; update maximal negative value
    mov    EBX, 1         ; set flag to indicate that we have found at least one negative number in the row

Not_Maximal_Negative:
    add     ESI, 4       ; move to the next element in the row, each element is 4 bytes (DWORD - DD); it also means that moving to the next column in the same row
    loop    Col_LoopB    ; repeat inner loop for all columns (to process all elements in the current row)
    
    ; EBX = 1 - at least one negative value in the row; EAX = maximal negative
    ; EBX = 0  -> no negative found, must store -1 according to assignment
    cmp EBX, 0
    jne  Have_Negative_B; if EBX != 0, we have found at least one negative number, so skip setting EAX to 0
    mov EAX, -1 ; set EAX to -1 to indicate no negative number found in the row


Have_Negative_B:
    ; After processing all columns in the current row
    ; Store the result (maximal negative value) in output array RB
    ; If no negative number was found, EAX will be 0 as initialized
    mov     [EDI], EAX   ; store the result (maximal negative value or 0 if none found)
    add     EDI, 4       ; move to the next position in the output array RB
    
    pop     ECX          ; restore rows counter - outer loop counter
    loop    Row_LoopB    ; repeat outer loop for all rows

No_Input_Data_Values_B:
    ret                  ; return to caller

A5_TaskB ENDP

END

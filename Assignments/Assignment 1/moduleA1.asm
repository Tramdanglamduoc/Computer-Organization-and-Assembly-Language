.586 
.MODEL flat, stdcall
OPTION casemap:none

.CONST
; Adjust input parameters if appropriate
X   WORD   4; must not change the data type
Y   WORD   -3
Z   WORD   5


.DATA?
R   WORD   ?   ; memory for storing the result of the calculations

; It is prohibited to introduce additional variables!
; For temporal data storage use available processor registers and/or stack memory.
; Paste the assigned expressions for a reference:
; E1 = ...
; E2 = ...

.CODE
A1:
    ; Add assembler instructions with 16-bit registers/operands according to the assignment tasks
    ;My task - Ngoc Bao Tram Tran - 231ADB294 : E1 = 15XY – 6(Z – Y); E2 = 2X – 3Z

    ; Compute expressions
    ; First task: E1 = 15XY – 6(Z – Y); E1 is stored in AX
    ; Calculate 15XY
    MOV AX, X        ; Load X into AX
    IMUL AX, Y      ; This time the value of AX = X * Y ;IMUL is used for signed multiplication
    IMUL AX, 15     ; This time the value of AX = 15 * X * Y

    ; Calculate 6(Z – Y)
    MOV BX, Z       ; Load Z into BX
    SUB BX, Y       ; This time the value of BX = Z - Y; SUB is used for subtraction
    IMUL BX, 6      ; This time the value of BX = 6 * (Z - Y)

    SUB AX, BX     ; This time the value of AX = 15XY - 6(Z - Y)



    ; Second task: E2 = 2X - 3Z; E2 is stored in CX
    MOV CX, X       ; Load X into CX
    IMUL CX, 2      ; This time the value of CX = 2 * X
    MOV DX, Z       ; Load Z into DX
    IMUL DX, 3      ; This time the value of DX = 3 * Z
    SUB CX, DX      ; This time the value of CX = 2X - 3Z
    

    ; Check for and avoid division by zero. As the result store -1 if it occurs.
    ; If E2 (CX) is zero, set R to -1
    CMP CX, 0       ; Compare E2 (CX) with zero
    JE  DivByZero   ; If E2 is zero (or if CX == 0) jump to DivByZero label
    JNE PerformDiv  ; If E2 is not zero (or if CX != 0), jump to PerformDiv label
    
    

    ;The branch DivByZero is to handle the division by zero case
    DivByZero:
    MOV R, -1       ; Copy -1 and paste in R to (indicate division by zero)
    JMP EndCalc     ; Jump to the end of the calculation; skip division (PerformDiv branch)
    

    
    ;The branch PerformDiv is to perform the division when E2 is not zero
    PerformDiv: 
    ; Computed E1 division by computed E2 ~ E1 / E2
    ; E1 is already in AX, E2 is already in CX
    MOV AX, AX ; Copy E1 into AX for division and then perform the division
    CWD             ; (Change the data type from word to double word for the division then)
    IDIV CX         ; Divide DX:AX by E2 (CX), result in AX; IDIV is used for signed division
    MOV R, AX      ; Store the result in R
    
    

    ;The branch EndCalc is to mark the end of the calculation
    EndCalc: 

    ret

    END A1
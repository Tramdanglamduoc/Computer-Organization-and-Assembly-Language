.586 
.MODEL flat, stdcall
OPTION casemap:none

.CONST
; Adjust input parameters if appropriate
; Task 1: Assume that not the variables X, Y and Z are 32-bit signed integers (i.e., DWORD size)
; Update existing computations from the assignment COAL-A1 with X, Y, Z and R as 32-bit signed integer variables.
X   DWORD   4; from WORD to DWORD
Y   DWORD   -3
Z   DWORD   5


.DATA?
R   DWORD   ?   ; memory for storing the result of the calculations; changed from WORD to DWORD due to the change of 2nd assignment

; It is prohibited to introduce additional variables!
; For temporal data storage use available processor registers and/or stack memory.
; Paste the assigned expressions for a reference:
; E1 = ...
; E2 = ...

.CODE
A2:
    ; Add assembler instructions with 32-bit registers/operands according to the assignment tasks 
    ; I have changed all 16-bit registers to 32-bit registers
    ;My task - Ngoc Bao Tram Tran - 231ADB294 : E1 = 15XY – 6(Z – Y); E2 = 2X – 3Z; E3=X / Y + (Z + 1)^3.

    ; Compute expressions
    ; E1 = 15XY – 6(Z – Y); E1 is stored in EAX and then pushed to stack for safe keeping
    ; Calculate 15XY
    MOV EAX, X        ; Load X into EAX
    IMUL EAX, Y      ; This time the value of EAX = X * Y ;IMUL is used for signed multiplication
    IMUL EAX, 15     ; This time the value of EAX = 15 * X * Y

    ; Calculate 6(Z – Y)
    MOV EBX, Z       ; Load Z into EBX
    SUB EBX, Y       ; This time the value of EBX = Z - Y; SUB is used for subtraction
    IMUL EBX, 6      ; This time the value of EBX = 6 * (Z - Y)

    SUB EAX, EBX     ; This time the value of EAX = 15XY - 6(Z - Y)
    push EAX       ; Save E1 on the stack
    ; Because I will use EAX for E3 calculation later, so I need to save E1 in safe place 
    ; Because with division operation in E3 calculation, EAX, EDX are needed to be used and EAX will be changed after the division operation.

    ; E2 = 2X - 3Z; E2 is stored in ECX
    MOV ECX, X       ; Load X into ECX
    IMUL ECX, 2      ; This time the value of ECX = 2 * X
    MOV EDX, Z       ; Load Z into EDX
    IMUL EDX, 3      ; This time the value of EDX = 3 * Z
    SUB ECX, EDX      ; This time the value of ECX = 2X - 3Z

; Part of assignment 1 - to get 9 -> 10 score but it is not supported for the assignment 2 - so I delete it out        


    ; Task 2: E3=X / Y + (Z + 1)^3, and E3 is stored in ESI for safe keeping
    ; Implement the computation of assigned expression E3 with X, Y and Z as 32-bit signed integer variables.
    ; Calculate (Z + 1)^3
    MOV EBX, Z       ; Load Z into EBX
    INC EBX         ; This time the value of EBX = Z + 1; INC is used to increase the value by 1
    MOV EDX, EBX    ; Copy (Z + 1) into EDX for multiplication; This time the value of EDX = Z + 1
    IMUL EBX, EDX   ; This time the value of EBX = (Z + 1) * (Z + 1) = (Z + 1)^2
    IMUL EBX, EDX   ; This time the value of EBX = (Z + 1)^2 * (Z + 1) = (Z + 1)^3

    ;Before calculating X / Y, check for division by zero 

    CMP Y, 0        ; Compare Y with zero
    JE  DivByZeroE3 ; If Y is zero, jump to DivByZeroE3 label
    ; Calculate X / Y
    MOV EAX, X       ; Load X into EAX
    CDQ             ; To perform the division, extend the sign of EAX into EDX
    IDIV Y          ; Divide EDX:EAX by Y, result in EAX; IDIV is used for signed division

    ;Calculate the whole E3 = X / Y + (Z + 1)^3 as the final step
    ADD EAX, EBX    ; This time the value of EAX = X / Y + (Z + 1)^3
    MOV ESI, EAX   ; Move the result of E3 into ESI for safe keeping; EAX will be used in Task 3
    JMP  AfterComputeE3  ; if Y is not zero, jump to AfterComputeE3 label to continue the calculation of E3, if not it will continue to DivByZeroE3 branch (it will be wrong)


    DivByZeroE3:
        POP     EAX   ;To balance the stack, pop E1 (before I have pushed E1 to stack) into EAX but I will not use it
        MOV R, -1       ; Copy -1 and paste in R to (indicate division by zero)
        ; Why I will code "MOV R, -1" and "JMP EndCalc" here: because if Y is zero, E3 cannot be computed and it is meaningless to continue to Task 3
        JMP     EndCalc

    
    AfterComputeE3:	
    ; Task 3: if (E3 > 0) then compute E1 / E2 - E3 and save into R
    ; else compute E1 * E2 + E3 and save into R (Ensure you compute E1, E2 and E3 only once per execution, i.e. avoid re-computation of the same expression.)

    ; To review: E1 is stored in stack (pushed before E2 calculation); E2 is stored in ECX; E3 is stored in ESI
    CMP ESI, 0       ; Compare E3 (ESI) with zero
    JG  E3isPositive   ; If E3 > 0, jump to E3Positive label (JG is used for signed comparison and I understand that JG is for "jump if greater")

    ; If E3 <= 0
    ;Compute E1 * E2 + E3 and save into R
    POP EAX        ; Retrieve E1 from the stack into EAX
    IMUL EAX, ECX   ; Multiply E1 (EAX) by E2 (ECX); This time the value of EAX = E1 * E2
    ADD EAX, ESI   ; Add E3 (ESI) to the result of E1 * E2 (EAX); This time the value of EAX = E1 * E2 + E3
    MOV R, EAX     ; Store the result in R
    JMP EndCalc    ; Jump to the end of the calculation


    E3isPositive:
        ; If E3 > 0
        ; Compute E1 / E2 - E3 and save into R

        ;First of all, check for division by zero again before performing the division
        ; Task 4: Check for and avoid division by zero. As the result store -1 if it occurs
        ; If E2 (ECX) is zero, set R to -1
        
        CMP ECX, 0       ; Compare E2 (ECX) with zero
        JNE PerformDiv  ; If E2 is not zero (or if ECX != 0), jump to PerformDiv label
        POP     EAX     ; To balance the stack, pop E1 (before I have pushed E1 to stack) into EAX but I will not use it
        MOV R, -1       ; Copy -1 and paste in R to (indicate division by zero)
        JMP EndCalc     ; Jump to the end of the calculation; skip division (PerformDiv branch)        
        
        
    ;The branch PerformDiv is to perform the division when E2 is not zero
    PerformDiv:
        POP EAX        ; Retrieve E1 from the stack into EAX
        CDQ             ; Change the data type from doubleword to quadword for the division then 
        IDIV ECX        ; Divide EDX:EAX by E2 (ECX) ~ EAX (E1) / ECX (E2), result in EAX; IDIV is used for signed division
        ;This time the value of EAX = E1 / E2
        SUB EAX, ESI   ; Subtract E3 (ESI) from the result of E1 / E2 (EAX); This time the value of EAX = E1 / E2 - E3
        MOV R, EAX     ; Store the result in R


    ;The branch EndCalc is to mark the end of the calculation
    EndCalc: 

    ret

    END A2
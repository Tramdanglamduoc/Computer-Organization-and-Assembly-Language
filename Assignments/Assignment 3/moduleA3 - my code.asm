.586    ; Processor selection directives
.MODEL flat, stdcall    ; standard memory model and calling convention
OPTION casemap:none    

includelib kernel32.lib   ; Case sensitive names and labels (which are recommended - due to the professor slides)
extern ExitProcess@4:PROC   ;  Define external names of API functions

.CONST
; Adjust input values if appropriate for a task A input
A1  DD  60000, 90988, 50202, -350, 4444, 5678, 54366, 70, -80000, 0   ; A1 is an array of DWORDs include 10 elements
S1  EQU LENGTHOF A1     ;S1 is the size of A1 array - S1 = 10

; Adjust input values if appropriate for a task B input
A2  DD  -901, -101, 200, -303, 400, -505, 600, -701, 800, 0            ; A2 is an array of DWORDs include 10 elements
S2  EQU LENGTHOF A2    ;S2 is the size of A2 array  - S2 = 10

.DATA?
; A memory for storing the result of the task A calculations
AR  DD  ?
; A memory for storing the result of the task B calculations
BR  DD  ?

; It is prohibited to introduce additional variables!
; For temporal data storage use available processor registers and/or stack memory.

; Paste the assigned tasks for a reference:
; Task A: Count negative values among elements
; Task B: Find the index of minimum odd value


.CODE
A3:
    ; For grade 7 - Task A solution - Count negative values among elements

    ; initialization and validations before the loop
    ; ESI will be used as a pointer to move through the array A1
    lea     ESI, A1     ; inital offset in A1 ;so ESI points to the first element of A1 and get its address
    ; ECX will be used as a loop counter
    mov     ECX, S1     ; LoopA counter ;ECX gets the size of A1 array (10)
    ; EAX will hold the count of negative numbers
    xor     EAX, EAX    ; initial output value  ; initialize EAX = 0 to count negative numbers; EAX will hold the count of negative numbers


LoopA:
    cmp     dword ptr [ESI], 0 ; addressing DWORD element of an array; compare current element in the array with 0
    jge     NextA        ; if element >= 0 jump to NextA
    ; jge = jump if greater or equal, so if the value is non-negative, we skip the increment
    ; we use jge not jae because we want to include zero as non-negative
    inc     EAX         ; increment the count of negative numbers


NextA:
    add     ESI, 4      ; adjust to the next array element (Because DD = 4 bytes so I add 4 to the offset)
    loop    LoopA       ; repeat until all elements are processed; when ECX = 0, loop ends, if not, it decrements ECX and jumps to LoopA and continue processing
    ; Remindar: EAX contains the count of negative numbers
    mov     [AR], EAX   ; Copy the value of EAX to the value of memory AR; now AR stores the result; 


TaskB:
    ; For grade 9 - Task B solution  -  Find the index of minimum odd value
    lea     ESI, A2     ; inital offset in A2 ;so ESI points to the first element of A2 and get its address
    ; ECX will be used as a loop counter
    mov     ECX, S2     ; LoopB counter ;ECX gets the size of A2 array (10)
    ; EBX will hold the index of the minimum odd value, initialized to -1 (not found)

    ; For grade 10; if in task B the values do not match, then store -1
    mov     EBX, -1     ; initial output value ;EBX will hold the index of the minimum odd value, initialized to -1 (not found); EBX = -1 means no odd number found yet
    ; EDX will hold the minimum odd value found, so at the beginning initialized to a large number
    mov     EDX, 7FFFFFFFh ; initial minimum odd value set to max positive DWORD value in hexadecimal 
    ; EDI will hold the current index in the array
    mov     EDI, 0      ; index counter 


LoopB:
    ; Check if the current element is odd
    mov     EAX, [ESI]  ; load current element into EAX ; EAX now has the current element from the array
    test     EAX, 1      ; check if the number is odd by performing bitwise 'test' with 1
    ; test is similar to AND but does not store the result, only sets the flags
    ; in this case, it sets the flags the same way as the AND instruction does (ZF = 1 if (EAX & 1) == 0), but it does not store the result into EAX
    ; test EAX, 1 will isolate the least significant bit
    ; 1 test 1 = 1 (odd), 0 test 1 = 0 (even)
    ; if the result is 1, the number is odd - the ZF = 0; if 0, it's even - the ZF = 1


    jz      NextB      ; if the number is even (result is 0 of test) which has ZF = 1, jump to NextB
    ; jz = jump if zero 

    ; If it's odd, proceed to check if it's the minimum odd value
    ; Now check if it's less than the current minimum odd value
    ; Remainder: EAX has the current odd element; EDX has the current minimum odd value
    cmp     EAX, EDX  ; compare current odd element with the minimum odd value
    ;jge is jump if greater or equal
    jge     NextB          ; if current odd element >= minimum odd value, jump to NextB

    ; If it is less and it is odd, update the minimum odd value and its index
     mov     EDX, EAX            ; update minimum odd value ; EDX now holds the new minimum odd value;
     ;new minimum value from EAX which contains the current odd element is less than the previous minimum odd value - EDX

     ; Reminder: EDI holds the current index in the array; EBX holds the index of the minimum odd value
     mov     EBX, EDI            ; update index of minimum odd value ; EBX now holds the index of the new minimum odd value from EDI which contains the current index in the array


NextB:
    ; if the number is even or not less than the minimum odd value, it will be processed in this branch
    add     ESI, 4      ; adjust to the next array element
    ; add 4 to ESI to point to the next element in the array (since each DWORD is 4 bytes)
    inc     EDI         ; increment the index counter ; EDI now points to the next index in the array
    loop    LoopB       ; repeat until all elements are processed

    ; Reminder: EBX contains the index of the minimum odd value or -1 if no odd value was found
     mov    [BR], EBX           ; store the index of minimum odd value in BR

Exit:
    push    0
    call    ExitProcess@4

    END A3
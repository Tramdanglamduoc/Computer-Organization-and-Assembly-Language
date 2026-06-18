.586
.MODEL flat, stdcall
OPTION casemap:none

includelib kernel32.lib
extern ExitProcess@4:PROC

.CONST
; Adjust input string as appropriate for a task A variant
S1  DB  "[]", 0 ; DB is one byte

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
; My name is Ngoc Bao Tram Tran, student ID 231ADB294
; My variant is A0, B1

; Task A: A0 - Store -1 if in the input string the count of opening and closing square brackets matches, otherwise store 0 (false).
; E.g., “[A]” -> -1, “A[[B]” -> 0.

; Task B: B1 - Store a new string by replacing two or more consequent letters in the input string with the single letter following the number of repeats, assuming repeats are up to 9.
; E.g., “ABBBCCCC” -> “AB3C4”.


.CODE
A4:
TaskA:
    ; Task A solution; Grade Level - 6 - Implement task A assigned variant.
    ; Task A: A0 - Store -1 if in the input string the count of opening and closing square brackets matches, otherwise store 0 (false).
    ; E.g., “[A]” -> -1, “A[[B]” -> 0.
    ; initialization and validations before the loop
    ; ESI will be used as a pointer to move through the array A1
    lea     ESI, S1     ; inital offset in S1
    ; mov     ESI, 0  ; to check null (no) string case

    cld  

    ; EAX will hold the final result
    xor     EAX, EAX ; initial output value  ; initialize EAX = 0
    ; EBX will count opening brackets '['
    xor     EBX, EBX  ; initialize EBX = 0
    ; EDX will count closing brackets ']'
    xor     EDX, EDX  ; initialize EDX = 0

    ; For grade level 10: Ensure you solution works also with atypical inputs - zero length (empty) string and null (no) string.
    ; For null (no) string case
    test    ESI, ESI
    jz      A_NullString;


LoopA:
    ; cld 			   ; clear direction flag to increment ESI; right now DF = 0
    ; LODSB: AL = [ESI], ESI++
    ; LODSB: Load byte - the content of memory from address ESI into register AL and increment ESI by 1
    ; because we are working with bytes, we use LODSB
    ; right now DF = 0, so ESI increments
    LODSB             
    ; For grade level 10: Ensure you solution works also with atypical inputs - zero length (empty) string and null (no) string.
    ; For empty string
    cmp     AL, 0      ; check that is it the end of string or not
    je      CheckCounts       ; if yes, jump to CheckCounts; to check the counts of opening and closing brackets    
    ; other intermediate calculations and/or conditional jumps

    cmp     AL, '['; check if the character is an opening bracket
    je      IsOpenBracket ; if yes, jump to IsOpenBracket

    cmp     AL, ']' ; check if the character is a closing bracket
    je      IsCloseBracket ; if yes, jump to IsCloseBracket

    jmp     NextA        ; if neither, jump to NextA

IsOpenBracket:
    inc     EBX          ; increment count of opening brackets
    jmp     NextA       ; jump to NextA

IsCloseBracket:
    inc     EDX          ; increment count of closing brackets
    jmp     NextA

NextA:
    ; LODSB already adjusted to the next element so don't need to inc ESI
    jmp     LoopA       ; repeat

A_NullString:
    jmp     CheckCounts; 

CheckCounts:
    cmp     EBX, EDX    ; compare counts of opening and closing brackets
    jne     CountsNotEqual   ; if counts of opening and closing brackets not equal, jump to CountsNotEqual

    mov     EAX, -1     ; set EAX = -1 (true) if counts of opening and closing brackets match
    jmp     EndA

; if counts of opening and closing brackets not equal
CountsNotEqual:
    xor     EAX, EAX    ; set EAX = 0 (false)
    jmp     EndA

EndA:
    mov     R1, EAX     ; store the result

TaskB:
    ; Task B solution   
    ; Task B: B1 - Store a new string by replacing two or more consequent letters in the input string with the single letter following the number of repeats, assuming repeats are up to 9.
    ; E.g., “ABBBCCCC” -> “AB3C4”.

    ; initialization and validations before the loop
    ; ESI will be used as a pointer to move through the array S2, the input string
    mov	 ESI, OFFSET S2   ; ESI points to the start of input string S2; ESI right now stores the address of string S2 - the start of input string
    ; it is similar with lea ESI, S2 but I want to show both ways of loading address
    ; EDI will be used as a pointer to move through the array R2, the output string
    mov	 EDI, OFFSET R2   ; EDI points to the start of output string R2; EDI right now stores the address of string R2 - the start of output string
    cld				 ; clear direction flag to increment ESI and EDI
    
    ; For grade level 10: Ensure you solution works also with atypical inputs - zero length (empty) string and null (no) string.
    ; For null (no) string case
    test    ESI, ESI
    jz      B_NullOrEmptyString     ;if ESI is null (0), jump to B_NullOrEmptyString


    ; For  zero-length (empty) string case
    ; read the first character from S2
    LODSB              ; AL = [ESI], ESI++, the address in ESI is incremented to point to the next character
    cmp	 AL, 0      ; check is it the end of string
    je	 B_NullOrEmptyString       ; if yes, jump to B_NullOrEmptyString

    mov    BL, AL        ; BL holds the current character being counted; right now BL holds the first character
    mov	CL, 1         ; CL holds the count of current character, initialize to 1

LoopB:
    LODSB              ; AL = [ESI], ESI++; load next character in the string
    cmp	 AL, 0      ; check is it the end of string
    je	 B_LastRun   ; if yes, jump to B_LastRun
    
    cmp	 AL, BL     ; compare current character with the one being counted
    jne  B_NewChar  ; if not equal, jump to B_NewChar

    ; if the character is the same, increment count
    inc	 CL         ; increment count of current character
    cmp  CL, 9      ; due to the task
    jne	 LoopB      ; repeat this loop until the end of string when we reach null terminator - AL is 0

    ; if 
    call OutputRun
    mov CL, 0
    jmp LoopB

B_NewChar:
    mov  DL, AL     ; store the new character in DL for clarity because AL will be changed in OutputRun
    
    cmp CL, 0
    je B_Skip_9_Repeat  ;
    call OutputRun  

B_Skip_9_Repeat:
    mov	 BL, DL     ; update BL to the new character
    mov	 CL, 1      ; reset the count to 1 for the new character if it is different
    jmp	 LoopB      


B_LastRun:
    cmp  CL, 0
    je   B_Terminate
    call OutputRun  ; output the last run of characters

B_Terminate:
    ; write null terminator 0 to end the output string 
    mov  AL, 0      ; null-terminate the output string
    STOSB           ; store AL (0) into [EDI], EDI++

    jmp	 EndB

B_NullOrEmptyString:
    ; The logic: if input string is empty, it means that output string is empty, just write null terminator to output string
    mov  AL, 0      ; null-terminate the output string
    STOSB           ; store AL (0) into [EDI], EDI++
    jmp  EndB

OutputRun:
    ; Output the counted run of characters stored in BL (character) and CL (count)
    mov AL, BL     ; move the character (first time appeared) to AL

    ; Determine if the character is a letter (A-Z or a-z) to check is it the letter or not (only letters are counted for compression)
    mov  BH, 0  ; BH = 0 means the character is in range 0-255 not letter

    ; If not letter, just output the character as is, regardless of count

    ; Check is it a capital letter A-Z
    cmp  AL, 'A'
    ; if below 'A', not capital letter, jump to B_CheckLower
    jb   B_CheckLower ; I use jb not jl because we compare unsigned values (characters are unsigned values)
    ; if above 'Z', not capital letter, jump to B_CheckLower
    cmp  AL, 'Z'
    jbe  B_SetLetter ; I use ja not jg with the same reason with jb not jl


B_CheckLower:
    ; Check is it a lowercase letter a-z
    cmp  AL, 'a'
    jb   B_LetterDone ; jb is jump if below so if the character is below 'a', not lowercase letter, jump to B_LetterDone
    cmp  AL, 'z'
    ja   B_LetterDone ; ja is jump if above so if the character is above 'z', not lowercase letter, jump to B_LetterDone

B_SetLetter:
    mov  BH, 1 ; set BH = 1 to indicate the character is letter


B_LetterDone:
    ; if BH = 0, not letter, output the character as is -> not compressed
    cmp  BH, 1
    jne  B_NotCompress

    ; if the count is 1, output the character as is -> not compressed
    cmp  CL, 2
    jb   B_NotCompress

    ; COMPRESS the character because it is letter and count >= 2 - with the format Letter + Digit
    mov  AL, BL     
    ; STOSB is the reverse of LODSB
    ; it stores the content of AL into memory at address EDI and increments EDI by 1
    STOSB           ; store AL into [EDI], EDI++ ; output the character

    mov AL, CL     
    add AL, '0'    ; convert to ASCII by adding ASCII value of '0'
    STOSB           ; store AL into [EDI], EDI++ ; output the count as digit

    ret

B_NotCompress:
    ; Output the character as is - no compress, regardless of count
    movzx  ECX, CL     ; ECX holds the count
    mov  AL, BL     

B_WriteLoop:
    test ECX, ECX
    je   B_WriteDone ; if count is 0, done writing
    
    STOSB           ; store AL into [EDI], EDI++
    dec  ECX        
    jmp  B_WriteLoop 

B_WriteDone:
    ret

EndB:
    jmp     Exit


Exit:
    push    0
    call    ExitProcess@4

    END A4


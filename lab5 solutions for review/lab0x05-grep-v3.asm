;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  This version adds the "^^^^^" carets appearing under the search word in the matching lines
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


section .data
    needCmdLineArgMsg db "Please provide a search word as a command line argument.",0x0A,0x00
    lineNumberFormat db "%3d: %s",0x00
    newlineStr db 0x0A,0x00
    caretStr db "^",0x00
    spaceStr db " ",0x00
    
section .bss
    inputBuffer resb 256
    foundPointer resb 4   ; place to store pointer to where a matching substring is found within inputBuffer
    
global _start
extern fgets
extern stdin
extern printf
extern strstr
extern strlen

section .text
_start:
    ; command line args...
    ;  [EBP+4] arg count (argc)
    ;  [EBP+8] the command itself (argv[0])
    ;  [EBP+12] the first argument (argv[1] -- the word to search for)

    push ebp
    mov ebp,esp

    ; we could add code to exit with an error message here if there is no first argument or too many args...
    cmp dword [EBP+4], 2
    je _InitializeReadLoop
    
    ; no command line arg, so no word to search for... give an error msg then exit...
    push needCmdLineArgMsg
    call printf
    add esp,4
    jmp _exit

_InitializeReadLoop:    

    mov esi, 1   ; initialize line count
    
_ReadLoop:
    
    ; read a line (or part of a line) using fgets
    push dword [stdin]
    push dword 256
    push dword inputBuffer
    call fgets
    add esp, 12
          
    ; fgets should return null if we are at end of file...
    cmp eax, 0
    je _EndOfFile


    ; search the line for the search word
    push dword [EBP+12]
    push inputBuffer
    call strstr
    add esp, 8
    
    ; save the pointer returned by strstr -- this is a pointer to where the matching string starts within inputBuffer
    ; we can use this later to calculate the number of spaces to put before the "^^^^^" carets that go under the matching word
    mov [foundPointer], eax
    
    ; check EAX to see how the search went...
    cmp eax, 0
    je _NotFound ; if not found skip over printing the line
    
    ; ok we found the word, so let's print the line
        
    ; line number version -- still assume the whole line is always <=255 characters lone (including the newline) and just print it out...
    push dword inputBuffer
    push esi
    push dword lineNumberFormat
    call printf     ; printf("%d: %s", lineNumber, inputBuffer);
    add esp, 12
    
    ; and now let's print the carets "^^^^" under the search word
    mov ebx, [foundPointer]
    sub ebx, inputBuffer   ; this gives use the number of characters on the input line before the matching substring
    add ebx, 5             ; add 5 for "%3d: " the line number, colon, and space
                           ; note: line numbers > 999 will not line up the carets quite perfectly
                           
    ; now a quick loop to print a bunch of spaces...
_SpacesLoop:
    push spaceStr
    call printf
    add esp, 4
    dec ebx
    jnz _SpacesLoop
    
    ; now print the carets...  how many?
    push dword [EBP+12]   ; the command line arg -- our search word -- how long is it?
    call strlen    ; use strlen to get the length of the  command line arg
                   ;    -- could do this just once at the beginning of program and store it
    ; eax now has the length of the search word (return value of strlen) -- that is how many carets we need
    mov ebx, eax   ; let's keep that count in ebx where it won't be stomped on by calls to printf
    
_CaretsLoop:
    push caretStr
    call printf
    add esp, 4
    dec ebx
    jnz _CaretsLoop
    ; finally put a newline after the carets
    push newlineStr
    call printf
    add esp,4
      
_NotFound:
    inc esi  ; increment line count
    jmp _ReadLoop  


_EndOfFile:
    ; nothing to do but exit...

_exit:
    mov     eax, 1    ;sys_exit
    xor     ebx, ebx
    int     80H 



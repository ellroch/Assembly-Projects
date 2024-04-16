;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  This version adds line numbering
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


section .data
    needCmdLineArgMsg db "Please provide a search word as a command line argument.",0x0A,0x00
    lineNumberFormat db "%d: %s",0x00
    charFmt db "%c",0x00
    newlineStr db 0x0A,0x00
    caret db '^'
    space db ' '
    
section .bss
    inputBuffer resb 256

global _start
extern fgets
extern stdin
extern printf
extern strstr
extern fflush

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
    je _continue1
    
    ; no command line arg, so no word to search for... give an error msg then exit...
    push needCmdLineArgMsg
    call printf
    add esp,4
    ;jmp _exit
    call _flush

_continue1:    

    mov esi, 1   ; initialize line count
    
_readLoop:
    
    ; read a line (or part of a line) using fgets
    push dword [stdin]
    push dword 256
    push dword inputBuffer
    call fgets
    add esp, 12
          
    ; fgets should return null if we are at end of file...
    cmp eax, 0
    je _endOfFile


    ; search the line for the search word
    push dword [EBP+12]
    push inputBuffer
    call strstr
    add esp, 8
    
    ; check EAX to see how the search went...
    cmp eax, 0
    je _ContinueReadLoop  ; if not found skip over printing the line
    
    ; ok we found the word, so let's print the line
        
    ; line number version -- still assume the whole line is always <=255 characters lone (including the newline) and just print it out...
    push dword inputBuffer
    push esi
    push dword lineNumberFormat
    call printf
    add esp, 12

_ContinueReadLoop:
    inc esi  ; increment line count
    jmp _readLoop  


_endOfFile:
    ; nothing to do but exit...

_exit:
    mov     eax, 1    ;sys_exit
    xor     ebx, ebx
    int     80H 

_flush:
    push dword [stdin]
    call fflush
    add esp,4
    ret
    
_printSpaces:
   ; parameter
   ;    [EBP+8] number of spaces  ' '

_printCarets:
   ; parameter
   ;    [EBP+8] number of carets '^'

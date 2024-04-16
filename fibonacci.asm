;I realize after a minute here that my organization doesnt have any rhyme or or reason behind it... it made sense when I was building it but it might be confusing to read... sorry about that.

;things added:
; - user input subroutine
; - ascii -> binary subroutine:
;    - asks for both input vals and number of iterations to progress through the sequence
;
;things edited/modified:
; - printnum -> account for negative values
; - fibloop -> set some break conditions to track the steps taken and compare it to the counter given by the user


section .bss
	loopcount resb 4
	inner_loopcount resb 4
   val1Ascii resb 20
   val1len resb 4 ; will track the number of digits, help conversion
   val1 resb 4

   val2Ascii resb 20
   val2len resb 4 ; will track the number of digits, help conversion
   val2 resb 4

   countnumAscii resb 20
   countnumlen resb 4 ; will track the number of digits, help conversion
   countnum resb 4

	;the lower 2 are from the original program
   outbuf resb 4 
   printBuffer resb 20  ; bugger to store ascii text decimal number to be printed 
 
section .text 
   global _start 
 
   seed0 equ 0 ;set seed0=val1
   seed1 equ 1 ;set seed1=val2
  
_start:  
	mov word [loopcount], 0 

_read_val1:
	;first we prompt user for val1
	mov edx, val1_promptlen
	mov ecx, val1_prompt
	mov ebx, 1 ; file descriptor stdout
	mov eax, 4 ; system call sys_write
	int 0x80 
	;then we recieve val1 from user
	mov edx, 20
	mov ecx, val1Ascii
	mov ebx, 0; file descriptor stdin
	mov eax, 3; sys_read call
	int 0x80
	mov [val1len], eax
	;then we call the conversion subroutine on val1
	;to convert the string to a binary number
	jmp _ascii_to_bin
;-------------------------------------
_read_val2:

	;then we prompt user for val2
	mov edx, val2_promptlen
	mov ecx, val2_prompt
	mov ebx, 1 ; file descriptor stdout
	mov eax, 4 ; system call sys_write
	int 0x80 
	;then we recieve val2 from user
	mov edx, 20
	mov ecx, val2Ascii
	mov ebx, 0; file descriptor stdin
	mov eax, 3; sys_read call
	int 0x80
	;mov [val2len], eax
	; then we convert it again
	jmp _ascii_to_bin
;------------------------------------
_read_countnum:

	;then we prompt user for countnum
	mov edx, countnum_promptlen
	mov ecx, countnum_prompt
	mov ebx, 1 ; file descriptor stdout
	mov eax, 4 ; system call sys_write
	int 0x80 
	;then we recieve val1 from user
	mov edx, 20
	mov ecx, countnumAscii
	mov ebx, 0; file descriptor stdin
	mov eax, 3; sys_read call
	int 0x80
	;mov [countlen], eax
	;call the conversion again
	jmp _ascii_to_bin
;--------------------
_ascii_to_bin:

	mov edx, ecx ; move the buffer space (readin ascii)
					 ; to edx - use edx for counter
	mov ecx, 0   ; set counter to 0
	mov [inner_loopcount], eax ; moving readin count to ebx, will limit the counter
	mov eax, 0	 ; initialize eax to 0
_conversion_loop:

	add edx, 1
	mov ebx, [edx]
	;sub ebx, "0"
	
	;cmp ebx, 0
   ;jl _if_char_in
	;cmp ebx, 9
	;jg _if_char_in

	imul eax, 0x0A
	add eax, ebx

	add ecx, 1
	cmp ecx, [inner_loopcount]
	jne _conversion_loop

	mov ecx, [loopcount]

	cmp ecx, 0
	je _branch1
	cmp ecx, 1
	je _branch2
	cmp ecx, 2
	je _branch3
   
_branch1:
	mov [val1], eax
	add ecx, 1
	mov [loopcount], ecx
	jmp _read_val2
_branch2:
	mov [val2], eax
	add ecx, 1
	mov [loopcount], ecx
	jmp _read_countnum
_branch3:
	mov [countnum], eax
	jmp _sequence_init


_sequence_init:
   ;we can signal to the user that the sequence is beginning
	mov edx, seq_start_prompt_len
	mov ecx, seq_start_prompt
	mov ebx, 1 ; file descriptor stdout
	mov eax, 4 ; system call sys_write
	int 0x80 
	
	;
   mov esi, val1 ;seed0 = val1
   mov edi, val2 ;seed1 = val2
    
   ;print out esi 
    call _printEsi 
 
     
   ;print out edi 
    call _printEdi 
   
_get_start_vals:    
    ;ascii starting val1

    ;ascii starting val2

_ascii_to_signed_int:
    ;utility function for converting ascii decimal values into binary integer equivalents


_fibloop:    
    
    add esi,edi      ; put sum into eax 
    jo _exit_cleanly 
     
    ;print out esi 
    call _printEsi    
    
    add edi, esi   
    jo _exit_cleanly 
      
    ;print edi 
    call _printEdi  
      
    ; ** ?? Why does this work? 
    jmp _fibloop  
    
_if_char_in:
	mov edx, char_in_len
	mov ecx, char_in
	mov ebx, 1 ; file descriptor stdout
	mov eax, 4 ; system call sys_write
	int 0x80 

_exit_cleanly: 
    mov   ebx,0 
    mov   eax,1 
    int   0x80 
 
; define a couple "wrapper" routines for printing esi or eai 
_printEsi: 
    mov eax,esi 
    call _printnum 
    ret 
     
_printEdi: 
    mov eax,edi 
    call _printnum 
    ret  
     
_printnum: 
    ; lets print the number as plain decimal text to the stdout... 
     
    ; first setup & call the conversion routine 
    mov ebx,printBuffer   ; the wrappers took care of putting esi or edi into eax 
                          ; but _IntToAscii also needs pointer to buffer to store text 
    call _IntToAscii 
     
    ; now print the text it with a system call 
    mov edx, ecx   ; the converter leaves the byte count in ecx, 
                   ; but sys_write needs it in edx 
    mov ecx, ebx   ; likewise we need to put the pointer in the right place for sys_write 
    mov ebx, 1     ; file descriptor for stdout 
    mov eax, 4     ; the code for the sys_write call 
    int 0x80       ; interrupt with code 0x80 to generate a system call 
     
    ; just for fun lets still print the binary, but to stderr!!! 
    ; and then learn a bit more about i/o redirection in Linux/bash shell 
   ; mov   edx,4     ; length of text 
   ; mov   ecx,outbuf     ; pointer to start of message 
   ; mov   ebx,1       ; file descriptor for stdout 
   ; mov   eax,4       ; 4 is code for the  sys_write 
   ; int   0x80        ; interrup to generate a system call 
     
    ret 
 
_IntToAscii: 
    ; convert an unsigned 32bit integer in eax to a string of decimal digits 
    ; the string will be stored in buffer pointed to by ebx 
    ; ecx will store the count of decimal digits 
 
    ; eax -- the integer (an unsigned integer) 
    ; ebx -- pointer to string buffer (assumed to be at least 12 bytes!!) 
    ; ecx -- counter of decimal digits 
    ; esi -- store our divisor: 10   
 
    ; note because we work backwards from low to high digit we fill in from 
    ; the 12 byte in buffer and return pointer to first character of the 
    ; decimal version, which likely will not be the first byte of the buffer 
    ; calling code needs to keep track of it's original buffer pointer 
 
    asciiZero equ 0x30          ; define symbol for ascii code of zero 
                                 ; moved it here so if we copy/paste it goes together 
 
 
    add ebx,11           ; point to 12th byte of buffer (we will fill the digits in "backwards") 
 
    mov byte [ebx],0x0a  ; lets put a newline character here to make printing easier 
                         ; now we are not guaranteeing a valid string 
                         ; maybe we should really just let the calling code deal 
                         ; with whether it wants a newline or null or both or neither 
                         ; it really should not be the job of this subroutine! 
                          
                          
    mov ecx, 1         ; ecx will count our digits, make sure it starts at zero 
                       ; starting at 1 to include the newline character 
_IntToAscii_Loop: 
    dec ebx           ; decrement ebx to point to byte position of last decimal digit 
 
    ; is there an improvement to efficiency we can make here, related to this instruction?  why or why not? 
    mov ebp,10        ; we will be dividing by 10, keep it here… 
                      ; using ebp to store divisor, to avoid collision with esi&edi used by fibonacci program 
 
    mov edx,0x0000    ; the dividend is edx:eax, so we put 0's in high bits in edx 
    div ebp           ; will calculate eax / ebp 
                      ;    quotient --> eax 
                      ;    remainder --> edx 
 
    add edx,asciiZero ; add ascii code of '0' to remainder(which is put in edx by div command) 
                      ; conveniently, this gives ascii code of the digit,  
                      ;    because the ascii codes of digits are in order 0x30...0x39 
    mov [ebx], dl     ; store the digit into its position in the buffer 
 
    inc ecx           ; increment our digit counter 
 
    ;can these two instructions be simplified to one instruction? why or why not? 
    cmp eax, 0                   ; check if eax is zero... 
    jne _IntToAscii_Loop     ; if it was NOT a zero, the loop back for next digit 
 
    ret               ; return -- note that ebx now points to first (most significant) digit of decimal string 
 
section .data                   ;section declaration 
 
msg db      "Go away! I refuse to say 'hello', world!",0xa ;our dear string 
len equ     $ - msg             ;length of our dear string

val1_prompt db "First value in the sequence:",0xa
val1_promptlen equ $ - val1_prompt

val2_prompt db "Second value in the sequence:",0x0a
val2_promptlen equ $ - val2_prompt

countnum_prompt db "How many steps to take in the sequence:",0x0a
countnum_promptlen equ $ - countnum_prompt

seq_start_prompt db "given those parameters the sequence is:",0x0a
seq_start_prompt_len equ $ - seq_start_prompt

char_in db "There was a non-digit character in there...",0x0a
char_in_len equ $ - char_in





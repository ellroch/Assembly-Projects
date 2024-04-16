;  Lab0x03-main.asm
; NOTE: will not read more than 200 char, even if blank line is not entered

;read:  a-3 b-0 c-char* d-len
;write: a-4 b-1 c-char* d-len
extern _replaceChar
section .data ; initialized data
	prompt_searchChar db "Please input a character to be replaced:", 0x0a,0x00
	;  prompt_search_len db $-prompt_searchChar

	prompt_repchar db "Please input a character to replace it:", 0x0a, 0x00
	;  prompt_rep_len db $-prompt_repchar

	prompt_stringBuff db "Please input a string to operate on:", 0x0a, 0x00
	;  prompt_string_len db $-prompt_stringBuff

;	push dword [replace]
;	push dword [search]
;	push dword [buffer_index]
;	push dword String_buff

section .bss ; uninitialized data
	search resb 20
	replace resb 20
	string_buff resb 200

	len resb 4
section .text ; code
;	extern _replaceChar
	global _start

_start:

	; write prompt 1
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt_searchChar
	mov edx, 42
	int 80h


	; read input 'search'
	mov eax, 3
	mov ebx, 0
	mov ecx, search
	mov edx, 20
	int 80h

	; write prompt 2
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt_repchar
	mov edx, 41
	int 80h

	; read input 'replace'
	mov eax, 3
	mov ebx, 0
	mov ecx, replace
	mov edx, 20
	int 80h



_while_loop:


		; write prompt 3
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt_stringBuff
	mov edx, 38
	int 80h

	; read input to string_buff
	mov eax, 3
	mov ebx, 0
	mov ecx, string_buff    ; set pointer
	mov edx, 200
	int 80h

	mov [len], eax ; mov # of read chars to len

	;prepare parameters
	mov eax, 0
	mov al, [replace]
	push eax			; fourth arg (+20)
	mov eax, 0
	mov al, [search]
	push  eax			; thrid arg (+16)
	push dword [len]				; second arg (+12)
	push dword string_buff		; first arg  (+8)

	call _replaceChar

	; dont forget to clean up parameters
	add esp, 16 ; clears the 4 dwords pushed for args

	; write the altered string
	mov eax, 4
	mov ebx, 1
	mov ecx, string_buff
	mov edx, [len]
	int 80h


	; break condition:
	; if len <= 1 (len of read signals blnk line)
	mov eax, [len]
	cmp eax, 1
	jle _break_loop


_break_loop:

	; exit
	_exit_cleanly:
	mov ebx, 0
	mov eax, 1
	int 0x80

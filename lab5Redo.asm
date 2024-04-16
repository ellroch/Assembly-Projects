
EXTERN stdin
EXTERN gets
EXTERN strstr
EXTERN printf
EXTERN feof

section .data ; initialized data
	format_str db "%2d)  %s", 0x0a, 0x00
  test_str db "this is a test", 0x0a, 0x00




section .bss ; uninitialized data




section .text ; code
  GLOBAL _start
_start:
  push ebp
  mov ebp, esp
  ;stack status:
  ; ebp+4 = (int) ArgC
  ; ebp+8 = (char**) ArgV

  ;begin loop: While(!feof(stdin)){..}
_loopHead:
  push stdin
  call feof
  add esp, 4 ; clean stack
  ; eax= return val of feof (if not 0 break loop)
  cmp eax, 0
  jne _break_loop




  jmp _loopHead
_break_loop:

  call _exit







;_printLine(int lineNum, char* line)
;uses format_str
_printLine:

	push ebp
	mov ebp, esp
	;	stack state:
	;	[ebp+8]= int lineNum
	;	[ebp+12]= char* line
	push word [ebp+12]
	push word [ebp+8]
	push format_str
	call printf ; print the matching data woot

	;end func
	mov esp, ebp
	pop ebp
	ret
	;func has ended






; - only call from main
_exit:
	mov ebx,0
	mov eax,1
	int 0x80
; program has exited







_test_for_break:
	push ebp
	mov ebp, esp

	push eax
	push ecx
	push edx

	push test_str
	call printf

	pop edx
	pop ecx
	pop eax

	mov esp, ebp
	pop ebp
	ret

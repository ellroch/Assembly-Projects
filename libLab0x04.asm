section .data ; initialized data
  listprompt db "Numbers:             Running Total:", 0x0a, 0x00
  format_ref db "        % -12d               % -12d", 0x0a, 0x00
section .bss ; uninitialized data

section .text ; code
  EXTERN printf
  GLOBAL _sumAndPrintList ; _sumAndPrintList(int* list, int len)


  ;  int sum=0;
  ;  while (len>0){
  ;    sum+= list[len];
  ;    len--;
  ;  }
  ;  return sum;
  ;
  ; _sumAndPrintList(int* list, int len)
  ; int  sum     = eax
  ; int  len     = ebp+12(ecx)
  ; int* list    = ebp+8 (edx)

_sumAndPrintList:
  ; preparations
  push ebp
  mov ebp, esp


  mov eax, 0
  mov ecx, [ebp+12] ; ecx = len
  sub ecx, 1       ; len-1 = index value: this is done at the start of the loop
  imul ecx, 4       ; index value*4 = memory offset
  mov [ebp+12], ecx  ; save this locally for
  mov ecx, 0
  mov edx, [ebp+8]  ; edx = base list pointer
  ; run function
  push eax
  push edx
  push ecx
  push listprompt
  call printf
  add esp, 4
  pop ecx
  pop edx
  pop eax
_again:
  add eax, [ecx+edx]
  ; print current index value and
  push eax
  push edx
  push ecx
	; above 3 save register states before call
  push eax  ; param 3 (sum)
  push dword [ecx+edx]  ; param 2 (current num)
  push format_ref; param 1 (format string)
  call printf
  add esp, 12
  ; below 3 restores register states
  pop ecx
  pop edx
  pop eax
  ;end print
  add ecx, 4
  cmp ecx, [ebp+12]
  jle _again  ; doing this because it has to run for 0'th index
  ;cleanup and return

  mov esp, ebp ; these steps are redundant in this case :/
  pop ebp      ; but it's probably a good habit to build
  ret


; note: spcing differences in search func may apear
; I wrote it in an editor on host machine and copied over,
; it uses 2 spaces in place of tabs so may/may not result in
; different spacing....
; lot of memory interactions too, didn't have time to optimize
; I know it's inefficient but again.. it should work.

	EXTERN stdin
	EXTERN fgets
  	EXTERN fgetc
	EXTERN strstr
	EXTERN strlen
	EXTERN printf
	EXTERN fopen
	EXTERN fclose
	EXTERN feof



section .data ; initialized data
	fopen_mode db "r"
	format_str db "%2d)  %s", 0x0a, 0x00
	test_str db "this is a test", 0x0a, 0x00
	test_argC db "testing argC: %d", 0x0a, 0x00

section .bss ; uninitialized data





section .text ; code



	GLOBAL _start




_start:

;	push ebp
	mov ebp, esp
	;stack status:
	;	ebp+4 = (int) ArgC
	;	ebp+8 = (char**) ArgV

	mov eax, [ebp+8] ; eax = (char*) ArgV[0]
	add eax, 4
	push eax ; push (char*) Argv[1] to [ebp-4]
	call strlen ; will return len

	pop ecx ; mov (char*) ArgV[0] to ecx, add 4 to esp so esp=ebp again
	push eax ; push the searchword len to [ebp-4]
	mov eax, ecx
	push eax ; push (char*) Argv[1] to take [ebp-8]
	push stdin
		;Current Stack status:
	;	ebp+8 = char** ArgV
	;	ebp+4 = int ArgC
	;	ebp +0 = old ebp
	;	ebp -4 = (int) len(ArgV[0]) = lenght of searchword
	;	ebp -8 = (char*) ArgV[1] = the searchWord
	;	ebp -12= (FILE*) STDIN -- default

	call _search
	;since last thing on stack should still be file pointer just going to call fclose() without modifying stack
; prepare to exit / return stack to same as before
	mov esp, ebp
;	pop ebp
; exit
	call _exit
; _start() has ended












;end of main... subfuncs efined below



;func 1 search:
;C equivalent written at bottom as a guide... wrote that and translated since it's so large
;_search( FILE* file, char* search_str, int str_len)
_search:

	push ebp
	mov ebp, esp
	;	stack state:
  ;	[ebp+16]= str_len
  ;	[ebp+12]= search_str
	;	[ebp+8]= FILE* file
  ; eip
  ; ebp
  sub esp, 24 ; reserved for local variables, yay!
;//////////////////////////////////////////////bulk of func begins
; [ebp-4] =char* line
  mov word [ebp-4], 0          ; line
; [ebp-8] =char c
  mov word [ebp-8], 0          ; c
; [ebp-12]=FILE* scout=file
  mov eax, [ebp+8]
  mov [ebp-12], eax   ; scout
; [ebp-16]=int offset=0
  mov word [ebp-16], 0         ; offset
; [ebp-20]=int lineNum=0
  mov word [ebp-20], 0         ; lineNum
; [ebp-24]=char* flag=NULL(0)
  mov word [ebp-24], 0         ; flag

_loopHead:
;{
  ;break if feof(file)
  push word [ebp+8]
  call feof ; sets eax==0 if true
  cmp eax, 0
  je _break_loop
  add esp, 4
  ;c=fgetc(scout)
call _test_for_break
  push word [ebp-12]
  call fgetc
  mov [ebp-8], al ; it's a char
  mov bl, al
  add esp, 4
  ;offset+=1
  mov eax, [ebp-16]
  add eax, 1
  mov [ebp-16], eax
  ;if c==10 ('\n') goto _next_char
  cmp bl, 10 ; bl == c
  je _end_of_line
  ; same for feof(scout)
  push word [ebp-12]
  call feof
  add esp, 4
  cmp eax, 0
  je _end_of_line
  ;cue repeat: if got here both failed
  jmp _loopHead
  ;continue loop
_end_of_line:
; lineNum+=1
  mov eax, [ebp-20]
  add eax, 1
  mov [ebp-20], eax
  ;fgets(line,offset,file)
  push word [ebp+8]
  push word [ebp-16]
  push word [ebp-4]
  call fgets
  add esp, 12
  ;strstr(line, str)
  push word [ebp+12]
  push word [ebp-4]
  call strstr
  mov [ebp-24], eax
  add esp, 8
  ;if flag!=0 ... a.k.a. if flag=0 jmp
  cmp eax, 0
  je _here
  ;call printline(lineNum, line)
  push word [ebp-4]
  push word [ebp-20]
  call _printLine
  add esp, 8
_here:
  ;file=scout
  mov eax, [ebp-12]
  mov [ebp+8], eax
  ;offset=0
  mov word [ebp-16], 0
  jmp _loopHead
;}
_break_loop:
;//////////////////////////////////////////////bulk of func ends
	;end func
	mov esp, ebp
	pop ebp
	ret
	;
	; C-code equivalent:
;  void _search(FILE* file, char* str, int str_len){
;    char* line=NULL;       // ebp-4
;    char c;           // ebp-8
;    FILE* scout=file; // ebp-12
;    int offset=0;     // ebp-16
;    int lineNum=0;    // ebp-20
;    char* flag=NULL;       // ebp-24
;              // use as bool (o=false) to signal match_found
;
;    do{
;      if(!feof(file)){
;      c=fgetc(scout);
;      offset+=1
;        if(c==10|| feof(scout)){ // ascii for \n
;          lineNum+=1;
;          fgets(line, offset, file);
;          flag= strstr(line, str);
;          if (flag!=NULL){ //if match was found
;            //call printLine(lineNum, line);
;            file=scout;
;          }
;          else{// if no match was found
;            file=scout;
;          }
;          offset=0; // bottom of if: c==\n'
;        }
;      }
;      else{
;        break;
;      }
;    }while(1);
;    return;
;  }




;func 2 print:
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



;func 3 exit:
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

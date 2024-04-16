; libLab0x03.asm
;replaceChar(char*, int, char, char){
;	while(len>0){
;		if (text[len] == target){
;			text[len] = repChar;
;	      repCount++;
;		}
;	   len--;
;	}
;}
;	return repcount;

;NOTE: this runs across the string from back to front, but thats not a big deal is it?

	global _replaceChar
; int replaceChar(char* text, int text_len, char target, char rep)
_replaceChar:
; function prep code:
	push ebp
	mov ebp, esp
	sub esp, 4  ; reserve a byte for an integer to track # of replacements
; function code:
	; textPTr = ebp+8
	; length = ebp+12
	; target = ebp+16
	; repChar = ebp+20
	; returnVal = ebp-4
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0

	mov ecx, [ebp+0Ch] ; move length into counter register
	mov edx, [ebp+8h] ; move text pointer into data register
	mov dword [ebp-04h], 0 ; initialize local counter to 0;
	mov eax, [ebp+10h] ; move the target char into eax

	push edx
_loop:
	pop edx
	push edx
	add edx, ecx
	cmp al, [edx] ; is the currect char == target
	jne _noMatch

	mov al, [ebp+14h]	 ; mov repcahr into eax, prepare to replace
	mov [edx], al ; replace the char in the string

	mov eax, [ebp-4h]   ; mov counter into eax to be incremented
	inc eax				 ; increment it
	mov [ebp-4h], eax	 ; mov it back into memory

	mov eax, 0
	mov al, [ebp+10h]  ; put the target char back into eax for loop

_noMatch:
	loop _loop
	pop edx ; take it off the stack

; function cleanup code:
	mov eax, [ebp-4h] ; set up eax to return the counter of how many chars were replaced
	mov esp, ebp
   pop ebp
	ret

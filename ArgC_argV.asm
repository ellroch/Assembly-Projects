; print argv[2]

mov eax, 0
	lea eax, [ebp+8]

  push dword [eax+4]
  	push test_argv_str
	call printf
	add esp, 8



;print ArgC

push dword [ebp+4]
push test_argc_str
call printf
add esp, 8

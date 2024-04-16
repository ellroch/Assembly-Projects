extern printf, exit

section .data
fmtint  db  "%d", 10, 0
fmtstr  db  "%s", 10, 0

section .text
global main
main:

    push    dword[esp]
    push    fmtint
    call    printf                      ; print argc
    add     esp, 4 * 2

    mov     ebx, 1
PrintArgV:
    push    dword [esp + 4 * ebx]
    push    fmtstr
    call    printf                      ; print each param in argv
    add     esp, 4 * 2

    inc     ebx
    cmp     ebx, dword [esp]
    jng     PrintArgV

    call    exit

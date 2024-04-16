
;lab0x06-Problem2-main.o:     file format elf32-i386
extern _sumAtoB
extern clock
extern CLOCKS_PER_SEC
extern clock_t
extern printf

;section .data
  ;printStr db "Number of Calls to sumAtoB: %d, m=%d, n=%d, Result=%d,  Total time spent in sumAtoB: %Lf\n"
;Disassembly of section .text:
section .text

;00000000 <main>:
     lea    ecx,[esp+0x4]  ; refer to comment below
     and    esp,0xfffffff0 ; I dont know what thi is or is doing he
     push   DWORD  [ecx-0x4]
     push   ebp
     mov    ebp,esp
     push   ecx
     sub    esp,0x54
     fldz
     fstp   [ebp-0x28];TBYTE
     mov    DWORD  [ebp-0x3c],0x0
     jmp    bf
  twtw:
     mov    eax,DWORD  [ebp-0x3c]
     sub    eax,0x7d00
     mov    DWORD  [ebp-0x38],eax
     call   clock
     mov    DWORD  [ebp-0x34],eax
     sub    esp,0x8
     push   DWORD  [ebp-0x3c]
     push   DWORD  [ebp-0x38]
     call   _sumAtoB
     add    esp,0x10
     mov    DWORD  [ebp-0x30],eax
     call   clock
     mov    DWORD  [ebp-0x2c],eax
     mov    eax,DWORD  [ebp-0x2c]
     sub    eax,DWORD  [ebp-0x34]
     mov    DWORD  [ebp-0x4c],eax
     fild   DWORD  [ebp-0x4c]
     fld    ds:0x60;TBYTE
     fdivrp st(1), st
     fstp   [ebp-0x18];TBYTE
     fld    [ebp-0x28];TBYTE
     fld    [ebp-0x18];TBYTE
     faddp  st(1), st
     fstp   [ebp-0x28]
     mov    ecx,DWORD  [ebp-0x3c]
     mov    edx,0x10624dd3
     mov    eax,ecx
     imul   edx
     sar    edx,0x7
     mov    eax,ecx
     sar    eax,0x1f
     sub    edx,eax
     mov    eax,edx
     imul   eax,eax,0x7d0
     sub    ecx,eax
     mov    eax,ecx
     test   eax,eax
     jne    bb
     push   DWORD  [ebp-0x20]
     push   DWORD  [ebp-0x24]
     push   DWORD  [ebp-0x28]
     push   DWORD  [ebp-0x30]
     push   DWORD  [ebp-0x3c]
     push   DWORD  [ebp-0x38]
     push   DWORD  [ebp-0x3c]
     push   0x0
     call   printf
     add    esp,0x20
  bb:
     add    DWORD  [ebp-0x3c],0x1
  bf:
     cmp    DWORD [ebp-0x3c],0xfa00
     jle    twtw
     ;nop
     mov    ecx,DWORD [ebp-0x4]
     leave
     lea    esp,[ecx-0x4]
     ret

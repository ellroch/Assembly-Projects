
;lab0x06-Problem2-lib-original.o:     file format elf32-i386


;Disassembly of section .text:

;00000000 <sumAtoB>:
section .text
global _sumAtoB

_sumAtoB:
          push   ebp
          mov    ebp,esp

          sub    esp,0x10
          mov    eax, DWORD [ebp+0x8];DWORD
          mov    [ebp-0x8],eax ;DWORD
          mov    DWORD [ebp-0x4],0x0
          jmp    _h1f
  _h2:
  	      mov    eax, DWORD [ebp-0x8];DWORD
          add    [ebp-0x4],eax;DWORD
        	add    DWORD [ebp-0x8],0x1;DWORD
  _h1:
  	      mov    eax,DWORD [ebp-0x8];DWORD
          cmp    eax,DWORD [ebp+0xc];DWORD
          jle    _h2
          mov    eax,DWORD  [ebp-0x4]
          leave
          ret

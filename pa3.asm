TITLE pa3.asm
; Program computes math operations and uses registers
; Adam Smith
; 9-12-17

Include Irvine32.inc

;Macros/Symbolics
clearEAX TEXTEQU <mov EAX, 0>
clearEBX TEXTEQU <mov EBX, 0>
clearECX TEXTEQU <mov ECX, 0>
clearEDX TEXTEQU <mov EDX, 0>

.data
	; declare variables here
	valp BYTE 12h, 0Ah, 01010101b, 95h
	valq WORD 0Bh, 67h, 8ABCh
	valw DWORD 12345678h, 3DFh


	val2 BYTE ?
	val3 WORD ?
	l1 LABEL WORD
	arrayD DWORD 0F5h, 82h, 9h, 32h
	val1 BYTE ?
	val4 BYTE ?
	l2 LABEL WORD
	valo DWORD 12345678h
.code
main proc
	; write your code here
	clearEAX
	clearEBX
	clearECX
	clearEDX
	mov esi, 0
	;mov eax, arrayD
	mov esi, OFFSET valp
	mov esi, OFFSET valw
	;mov ebx, OFFSET val3
	;mov ecx, OFFSET arrayD
	;mov edx, OFFSET val1
	;mov eax, OFFSET val4
	mov cx, l1+4
	mov bx, l2+1
	mov ah, BYTE PTR valo
	mov ax, WORD PTR [valo+2]


call DumpRegs

	exit
main endp
end main
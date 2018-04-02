TITLE reorder.asm
; Program reorders an array
; Adam Smith
; 9-17-17

Include Irvine32.inc

;Macros/Symbolics
clearEAX TEXTEQU <mov EAX, 0>
clearEBX TEXTEQU <mov EBX, 0>
clearECX TEXTEQU <mov ECX, 0>
clearEDX TEXTEQU <mov EDX, 0>


.data
	; declare variables here
	arrayD DWORD 312,105,21 ; hex is 138,69,15 now, it should be 15,138,69
.code
main proc
	; write your code here
	clearEAX
	clearEBX
	clearECX
	clearEDX
	mov edx, arrayD ; puts 138 in edx
	xchg edx, [arrayD + 4];69 is now in edx
	xchg edx, [arrayD + 8];15 now in edx
	xchg edx, arrayD;15 is now in first element of arrayD
	mov eax, arrayD ; shows first element of reordered array in eax
	mov ebx, [arrayD+4] ; shows second element in ebx
	mov ecx, [arrayD+8] ; shows third element in ecx

	

call DumpRegs

	exit
main endp
end main
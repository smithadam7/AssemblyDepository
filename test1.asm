TITLE test1.asm
; Program computes math operations and uses registers
; Adam Smith
; 10-09-17

Include Irvine32.inc

;Macros/Symbolics
clearEAX TEXTEQU <mov EAX, 0>
clearEBX TEXTEQU <mov EBX, 0>
clearECX TEXTEQU <mov ECX, 0>
clearEDX TEXTEQU <mov EDX, 0>

.data
	; declare variables here
	A1 SBYTE -4h
	B2 SBYTE 6h
	C3 SBYTE 3
	D4 SBYTE 2
.code
main proc
	; write your code here

	;clears registers
	clearEAX
	clearEBX
	clearECX
	clearEDX
	mov esi, 0

	;loads values into registers
	movsx ax, A1
	movsx bx, B2
	movsx cx, C3
	movsx dx, D4

	;calulates
	sub al,B2
	sub cl,D4
	add ax,cx

	;moves answer to eax
	movsx edx,ax
	mov eax,edx ; answer stored in eax

	;mov ax, D4
call DumpRegs

	exit
main endp

;Funtion for recieving an integer from the user and storing in register
UserInt proc
;call WriteString
call ReadInt
ret
UserInt endp

;Function for generating random string
RandStr proc

ret
RandStr endp

end main
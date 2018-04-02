TITLE quiz.asm
; Program has a menu for random nums
; Adam Smith
; 10-12-17

Include Irvine32.inc


;Macros/Symbolics
clearEAX TEXTEQU <mov EAX, 0>
clearEBX TEXTEQU <mov EBX, 0>
clearECX TEXTEQU <mov ECX, 0>
clearEDX TEXTEQU <mov EDX, 0>
clearESI TEXTEQU <mov ESI, 0>
clearEDI TEXTEQU <mov EDI, 0>


.data
	; declare variables here
	array1 DWORD 20 DUP(?)
	Prompt1 BYTE 'Enter value for A: ',0
	Prompt2 BYTE 'Enter value for j: ',0
	Prompt3 BYTE 'Enter value for k: ',0
	varA DWORD ?
	varj DWORD ?
	vark DWORD ?
	output1 BYTE 'A = ',0
	output2 BYTE 'j = ',0
	output3 BYTE 'k = ',0
	outputprompt BYTE 'The array is: ',0Ah,0Dh,0
	
.code
main proc
	; write your code here
	;clear registers
	clearEAX
	clearEBX
	clearECX
	clearEDX
	clearESI
	clearEDI

	call Randomize; initializes seed value
	mov edx, OFFSET Prompt1
	call writestring ; displays prompt to screen
	call readdec ; reads in decimal number from keyboard
	mov varA,eax ; stores value

	;repeat for each value
	mov edx, OFFSET Prompt2
	call writestring
	call readdec
	mov varj,eax

	mov edx, OFFSET Prompt3
	call writestring
	call readdec
	mov vark,eax

	mov edx, OFFSET output1; for displaying value the user entered
	call writestring
	mov eax, varA;moves value to display
	call writedec;displays value
	call crlf;endline
	;repeat
	mov edx, OFFSET output2
	call writestring
	mov eax, varj
	call writedec
	call crlf

	mov edx, OFFSET output3
	call writestring ; writes string to window
	mov eax, vark
	call writedec
	call crlf ; endline

	mov edx, OFFSET outputprompt
	call writestring
	;-----------------
	mov ecx,varA; loop counter
	L1:
		mov eax, vark;sets top of range
		sub eax, varj;sets bottom of range
		call randomrange ;generates random number in this range
		add eax, varj ; moves range for desired random nums
		mov array1[esi],eax
		;inc esi
		add esi, TYPE array1
		;call writedec ; writes decimal to screen
		;call crlf;endline
		
		loop L1

;to make dumpmem work
mov esi, OFFSET array1
mov ebx, TYPE array1
mov ecx, LENGTHOF array1
call DumpMem; displays memory of array1
call WaitMsg ; press any key to continue irvine function

	exit
main endp


end main
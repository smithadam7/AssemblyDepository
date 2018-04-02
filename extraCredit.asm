TITLE pa3.asm
; Program computes random strings and uses registers
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
	N DWORD ? ; user input to be passed as argument
	user_message BYTE "Enter an unsigned integer: ",0 ;Message for user
	stringArray BYTE 10 DUP(0),0 ;array for the random strings that contains 100 chars
.code
main proc
	; write your code here
	clearEAX
	clearEBX
	clearECX
	clearEDX
	mov esi, 0
	;mov eax, N

	call UserInt ; calls function user int
	call Crlf ; endline
	call RandStr ; calls function RandStr
	;call Randomize
	;call RandomRange
	call Crlf ; endline
	call WaitMsg; press any key to continue irvine function

	exit
main endp

;-----Funtion for recieving an integer from the user-----------------------
;Asks user for an unsigned integer N and passes it back
;Recieves : EAX, EDX
;Returns : EAX = N which is number of strings to be displayed
;Requires Nothing
;------------------------------------------------------------------------------
UserInt proc ;start of function
.data
	user_message BYTE "Enter an unsigned integer: ",0 ;Message for user is local to this proc
.code
mov edx, OFFSET user_message; gets address of message to user
call WriteString ; displays the message to user
call ReadInt ; reads in an integer from user and stores in eax
mov N,eax
ret
UserInt endp ;end of function


;------Function for generating random string-------
; generates random strings of 10 capital letters
;Recieves EAX,ECX,ESI
;Returns: the random strings
;Requires : N
;----------------------------------------------------------------
RandStr proc Uses ESI ECX EAX; start of function
mov ecx, N
L1:
	push ecx ; pushes to stack
	mov ecx, 10 ; strings will be 10 chars long
	;add 5 after for range
	mov esi, OFFSET stringArray ; index of string

	L2:
		mov eax, 26 ; for each letter in alphabet
		call RandomRange
		add eax, 'A' ; sets range of 65
		mov [esi], al
		inc esi
		loop L2

	mov edx, OFFSET stringArray
	call setColor
	call WriteString; writes string to screen
	call Crlf; endline
	pop ecx ; pops from stack
	loop L1
	ret
RandStr endp; end of function

;------Function for generating random colors-------
; generates random strings of 10 capital letters
;Recieves EAX
;Returns: the random colors
;Requires : Nothing
;----------------------------------------------------------------
setColor proc ;
push eax; puts eax on stack
mov eax, 15; this is the range of colors
call RandomRange; random funciton in irvine library
add eax, 1; so black wont be chosen
call SetTextColor ; irvine functions that sets color for a text
pop eax ; removes top of stack
ret ;returns
setColor endp ; end of function

end main
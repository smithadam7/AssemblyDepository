TITLE pa5.asm
; Program has a menu for string operations
; Adam Smith
; 10-12-17

Include Irvine32.inc

maxStringLength = 51d

;Macros/Symbolics
clearEAX TEXTEQU <mov EAX, 0>
clearEBX TEXTEQU <mov EBX, 0>
clearECX TEXTEQU <mov ECX, 0>
clearEDX TEXTEQU <mov EDX, 0>
clearESI TEXTEQU <mov ESI, 0>
clearEDI TEXTEQU <mov EDI, 0>


.data
	; declare variables here
	UserOption BYTE 0h
	theString BYTE maxStringLength DUP (0)
	theStringLength BYTE ? ;user entered string length not the max length
	errorPrompt BYTE 'Error: Enter a valid integer 1-6',0Ah,0Dh,0
	
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
	
	startHere:
	call DisplayMenu
	call ReadHex
	mov UserOption, al

	;Procedure selection process
	;setting up for future procedure calls
	mov edx, OFFSET theString
	mov ecx, lengthof theString

	opt1: ;read a string
	cmp UserOption, 1
	jne opt2
	call clrscr
	mov ecx, maxStringLength
	call option1
	mov theStringLength, al
	jmp startHere

	opt2:;lowercase the string
	cmp UserOption, 2
	jne opt3
	call option2
	jmp startHere
	
	opt3:;remove non-letter elements
	cmp UserOption, 3
	jne opt4
	call option3
	jmp startHere
	
	opt4:;check if palindrome
	cmp UserOption, 4
	jne opt5
	call option4

	jmp starthere
	
	opt5:
	cmp UserOption, 5
	jne opt6
	call WriteString
	call crlf
	call waitmsg
	call crlf ; endline
	jmp startHere
	
	opt6:
	cmp UserOption, 6
	je leaveNow
	mov edx, OFFSET errorPrompt
	call WriteString
	call WaitMsg
	jmp starthere

	leaveNow:
	
call WaitMsg ; press any key to continue irvine function

	exit
main endp

DisplayMenu PROC uses EDX
;Description: displays menu
;recieves nothing
;returns nothing

.data
MenuPrompt1 BYTE 'MAIN MENU' , 0Ah, 0Dh,;character line feed
				'===========',0Ah,0Dh,
				'1. Enter a string', 0Ah, 0Dh,
				'2. Convert the string to lower case', 0Ah, 0Dh,
				'3. Remove all non-letter elements', 0Ah, 0Dh,
				'4. Is the string a palindrome?', 0Ah,0Dh,
				'5. Print the string', 0Ah,0Dh,
				'6. Quit',0Ah,0Dh,
				'Enter an option 1-6: ',0

.code
call clrscr ; clears screen
mov edx, OFFSET MenuPrompt1
call WriteString ;displays menu
ret
DisplayMenu endp

;DEScription: get string from user
;recieves offset of string in edx
;returns  user entered string offset not changed length of string returned in eax
option1 PROC
.data
userPrompt1 BYTE "Enter your string --> ",0
.code
push edx		; save offset of string to stack
mov edx, OFFSET userPrompt1
call WriteString
pop edx		;restore offset of string
call ReadString ;get user input
ret
option1 endp

option2 PROC uses edx ecx edi
;Desc: converts to lowercase
;recieves Offset of the string in edx, string length in ecx
;returns original string with all capital letters converted to lowercase
mov edi,0
loop2:
mov al, BYTE PTR [edx+edi];get element of string
cmp al,41h ;check if less than for lowercase
jb keepgoing ; if it is then continue
cmp al, 5Ah
ja keepgoing
add al, 20h ;makes lowercase
mov BYTE PTR [edx+edi],al
keepgoing:
inc edi
loop loop2
ret
option2 endp

option3 PROC
;Desc: removes all not letter elements
;recieves offset to string in edx , and string length in ecx
;returns string with non letter elements removed
;if above 41 remove character
.data
	tempstring BYTE maxStringLength DUP(0);temorary string
.code
mov edi, OFFSET tempstring
mov esi,0;clears
;check if letter is uppercase
loop3:
mov al, [edx+esi];gets element of string
cmp al,0;is it the end of the string
je final
cmp al,41h
jb nonLetter
cmp al,5Ah
ja checkLowercase
mov [edi],al
inc edi;next char
inc esi
jmp loop3

;check lowercase
checkLowercase:
cmp al,61h;ascii range for lowercase letters
jb nonLetter
cmp al,7Ah
ja nonLetter

mov [edi],al;new string element
inc edi;next element
inc esi
jmp loop3

nonLetter:
inc esi;continues on
jmp loop3

final:
mov [edi],al
mov esi,0

clearstring:
mov [theString+esi],0
loop clearstring

mov esi,0
ReplaceString:
	mov al, tempstring[esi];puts new char
	cmp al,0;until end
	je breakloop
	mov theString[esi],al;moves new element to string
	inc esi
	jmp ReplaceString
	
breakloop:
mov theString[esi],al;null
clearESI
clearEDI

ret
option3 endp

option4 PROC 
;Desc: tells if palindrome
;recieves Offset of the string in edx, string length in ecx
;returns if string is a palindrome or not
.data
	tempstring1 BYTE maxStringLength DUP(0),0
	yapalindrome BYTE 'Your string is a palindrome!',0
	nopalindrome BYTE 'Your string is not a palindrome.',0
.code
;reversing string onto stack
mov ebx,ecx;store the counter
mov edi,0
loop4a:
movzx eax, BYTE PTR [edx+edi];get element of string
cmp eax,0;check if end of string
je out1;if it is then leave the loop
push eax;push each char to stack
inc edi
loop loop4a

out1:
;retrieving reversed string from stack
mov ecx,edi;length of reversed string
mov edi,0
loop4b:
pop eax;takes char from stack
mov tempstring1[edi],al;puts it in tempstring1
inc edi
loop loop4b
;add null character
mov tempstring1[edi],0

;compare strings
mov ecx,edi;length of reversed string
mov edi,0
;mov esi, OFFSET tempstring1
loop4c:
mov al, BYTE PTR [edx+edi];get element of original string
mov bl, tempstring1[edi];gets element of reversed string
inc edi
cmp al, bl;compares each char
jne nopal;if they are not equal then it is not a palindrome
cmp al,0;at the end of the string
je yespal;conclude string is a palindrome
loop loop4c

yespal:
push edx;save offset edx to stack

mov edx, OFFSET yapalindrome ;put message for user
call writestring
pop edx;restore edx from stack
call crlf;endline
call waitmsg;continue
jmp donehere

nopal:
push edx;save offset in edx to stack
mov edx, OFFSET nopalindrome;message for user
call writestring;displays message
call crlf;endline
call waitmsg
pop edx;restores edx from stack

donehere:
ret
option4 endp

end main
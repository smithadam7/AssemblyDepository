TITLE hangman.asm
; Program has a hangman game, however if kiwi is chosen for the word in crashes
; Adam Smith
; 11-8-17

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
	UserOption BYTE 0h
	theString BYTE 51 DUP (0)
	;theStringLength DWORD ? ;user entered string length not the max length
	errorPrompt BYTE 'Error: Enter a valid integer 1-2',0Ah,0Dh,0
	gamePrompt BYTE 'Do you wish to guess a letter or the whole word: (1 for letter 2 for word)',0Ah,0Dh,0
	randVal DWORD ?
	stringoffset dword ?
	rules BYTE 'RULES: Try to guess a random word. You have 3 chances to guess the word ',0Ah,0Dh,
				'and 10 letter guesses. Good luck!',0Ah,0Dh,0

	;words
	String0 BYTE "kiwi" , 0h
	String1 BYTE "canoe" , 0h
	String2 BYTE "doberman" , 0h
	String3 BYTE "frame" , 0h
	String4 BYTE "banana" , 0h
	String5 BYTE "orange" , 0h
	String6 BYTE "frigate" , 0h
	String7 BYTE "ketchup" , 0h
	String8 BYTE "postal" , 0h
	String9 BYTE "basket" , 0h
	String10 BYTE "cabinet" , 0h
	String11 BYTE "birch" , 0h
	String12 BYTE "machine" , 0h
	String13 BYTE "mississippi" , 0h
	String14 BYTE "destroyer" , 0h
	String15 BYTE "tank" , 0h
	String16 BYTE "fruit" , 0h
	String17 BYTE "rhythm" , 0h
	String18 BYTE "denver" , 0h
	String19 BYTE "hangman" , 0h
	
.code
main proc
	; write your code here
		;display rules
	mov edx,offset rules
	call writestring
	startHere:
	;clear registers
	clearEAX
	clearEBX
	clearECX
	clearEDX
	clearESI
	clearEDI
	;choose random word
	call randomize
	mov eax,5000
	call randomrange
	add eax,1
	mov randVal,eax
;modulo example
;mov ax,0083h
;mov bl,2
;div bl ; al=41 bl= 1=the remainder
	mov ebx,19d
	div ebx;random number now in edx
	;inc edx
	mov randVal,edx
	mov edx,OFFSET string0
	mov ecx, randVal
	wordloop:
	push ecx
	l2:;nested loop
	mov ecx, 15
	cmp BYTE PTR [edx],0;endofstring?
	je outlo
	inc edx;next chsr
	loop l2
	outlo:
	pop ecx
	inc edx
	loop wordloop
	;offset to string is now in edx
	mov stringoffset,edx
	;call writestring
	call waitmsg
	
	;calc length of string in edx
	mov ecx,15
	mov edi,0;to store string length
	lenloop:
	cmp BYTE PTR[edx],0
	je menuo
	inc edi
	inc edx
	loop lenloop
	;mov theStringLength,edi
	
	menuo:
	call DisplayMenu
	call ReadHex
	mov UserOption, al
	
	;Procedure selection process
	opt1:
	cmp UserOption, 1
	jne opt2
	mov ecx,edi
	call option1
	
	call crlf ; endline
	jmp startHere
	
	opt2:
	cmp UserOption, 2
	je leaveNow
	mov edx, OFFSET errorPrompt;otherwise the user input an invalid character
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
				'1. Play the game', 0Ah, 0Dh,
				'2. Quit', 0Ah, 0Dh,
				'Enter an option 1-2: ',0

.code
call clrscr ; clears screen
mov edx, OFFSET MenuPrompt1
call WriteString ;displays menu
ret
DisplayMenu endp

;DEScription: gets chars from user and plays game
;recieves offset of string in edx and string length in ecx
;returns  winner or loser
option1 PROC
.data
	;local variables
	userchar BYTE ?
	UserOption2 BYTE 0h
	letterguesses BYTE 10d
	wordguesses BYTE 3d
	letterPrompt BYTE 'Guess a letter: ',0
	leftparen BYTE '(',0
	letguessleft BYTE ' letter guesses left)',0
	wordPrompt BYTE 'Guess a word: ',0
	displayWord BYTE 'Word = ',0
	winString BYTE '_ _ _ _ _ _ _ _ _ _ _ _ _ _ _',0
	youLost BYTE 'YOU LOST!',0
	youWin BYTE 'That is correct. You win : ',0
	wrongword1 BYTE 'That is incorrect. ',0
	wrongword2 BYTE ' word guesses remaining',0
	guessstring BYTE 51 DUP (0)
	aspace BYTE ' ',0
	guessChar BYTE ?
	theStringLength BYTE ? ;user entered string length not the max length
	correctletterAmount DWORD ?
	guessesCorrect DWORD 0d
.code
;set up a new word
push ecx;save to stack
mov edi,OFFSET winString
winstringreset:;loop for resetting the empty word
mov bl,'_';puts the underscores back
mov BYTE PTR [edi],bl
inc edi
mov bl,' ';puts the spaces back
mov BYTE PTR [edi],bl
inc edi
loop winstringreset
pop ecx;restore ecx
mov correctletterAmount,ecx
mov letterguesses,10d
mov wordguesses,3
topopt1:
;check if out of guesses
cmp letterguesses,0;when you run out of letter guesses you lose because otherwise too ez
je youlostha
cmp wordguesses,0;when out of word guesses you lose instantly
je youlostha

clearEDI;for offset on winning string
mov edi, OFFSET winString
;push edx		; save offset of string to stack

mov edx, OFFSET displayWord
call writestring
push ecx;save to stack
mov edx, stringoffset
mov guessChar,al
;display word
disloop:
mov al,guessChar
cmp al, BYTE PTR [edx];is the char in the word
jne underscore
mov al,BYTE PTR [edx]
mov BYTE PTR [edi],al;puts letter in underscore spot when correct
inc guessesCorrect
mov eax,guessesCorrect
cmp eax,correctletterAmount;when all the letters are chosen then win
je winning
clearEAX

underscore:
mov al , BYTE PTR [edi];puts underscore
call writechar
spacein:
inc edi;space location
mov al , BYTE PTR [edi]
call writechar
inc edi;next
inc edx;next element
loop disloop

;tell how many guesses are left
mov edx, OFFSET leftparen
call writestring
pop ecx;restore count
clearEAX
mov al,letterguesses
call writedec;number of letter guessses
mov edx, OFFSET letguessleft
call writestring
call crlf ; endline

mov edx, OFFSET gamePrompt
call WriteString
;pop edx		;restore offset of string
call ReadHex
mov UserOption2, al
	opt12:
	cmp UserOption2, 1
	jne opt22
	;get char from user with prompt
	dec letterguesses
	mov edx, OFFSET letterPrompt
	call writestring
	;input character
	call readchar
	call writechar
	;convert to lowercase
	cmp al,41h ;check if less than for lowercase
	jb keepgoingq ; if it is then continue
	cmp al, 5Ah
	ja keepgoingq
	add al, 20h ;makes lowercase
	keepgoingq:
	mov userchar,al
	
	call crlf ; endline
	jmp topopt1
	
	opt22:
	cmp UserOption2, 2
	jne badinput;user inputs an invalid char like an invalid
	dec wordguesses
	mov edx, OFFSET wordPrompt
	call writestring
	
	mov edx,OFFSET guessstring
	push ecx
	clearECX
	mov ecx,sizeof guessstring
	call readString
	mov theStringLength,al
	mov cl,theStringLength
	mov esi,OFFSET guessstring
	mov edx, stringoffset
		;cmp ecx,lengthof guessstring
		;jne wrongo
	;compare strings loop
	comparestringloop:
		mov al,BYTE PTR [edx]
		cmp al,0;if its the end of the string
		je winning
		cmp BYTE PTR [esi],al
		jne wrongo;user is wrong
		inc edx;next element
		inc esi;next element
		loop comparestringloop
	winning:;when the user wins
		mov edx, OFFSET youWin
		call writestring
		mov edx, stringoffset
		call writestring
		pop ecx;restore ecx
		jmp leavenow1
	wrongo:
	push edx
	mov edx,OFFSET wrongword1
	call writestring
	mov al,wordguesses
	call writedec
	mov edx, OFFSET wrongword2
	call writestring
	call crlf;endline
	pop edx
	clearECX
	pop ecx
	
	jmp topopt1
	
	badinput:;user put wrong char
	mov edx, OFFSET errorPrompt
	call WriteString
	call WaitMsg
	
	
	jmp topopt1;back to top

;user loses the game
youlostha:
mov edx,OFFSET youLost
call writestring
call crlf
call waitmsg;enter key to continue

leaveNow1:

ret
option1 endp

lowerconvert PROC uses edx ecx edi
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
lowerconvert endp

end main
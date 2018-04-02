TITLE pa6.asm
; Program has a menu for encrypting with the caesar cipher
; Adam Smith
; 11-10-17

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
	keyPrompt BYTE 'Would you like to enter a new key or use the old one?',0
	theKey BYTE maxStringLength DUP (0)
	theKeyLength BYTE ?
	
	
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
	
	;get key from user
	getKey:
	mov edx, OFFSET theKey
	mov ecx, maxStringLength
	call enterAKey
	mov theKeyLength, al
	clearEAX
	
	startHere:
	call DisplayMenu
	call ReadHex
	mov UserOption, al
	

	;Procedure selection process

	opt1: ;encrpyt a string
	mov edx, OFFSET theString
	cmp UserOption, 1
	jne opt2
	call clrscr
	;get the string from user
	mov ecx, maxStringLength
	call option1
	mov theStringLength, al
	
	;remove non chars
	mov ebx, OFFSET theStringLength
	movzx ecx, theStringLength
	mov edx, OFFSET theString
	mov esi,0
	call CharOnly
	;store string in edx for passing
	mov edx, OFFSET theString
	movzx ecx, theStringLength
	;make uppercase
	call ChangeCase
	;prepare registers for passing requirements for the encryption
	mov esi, OFFSET theString
	movzx ecx, theStringLength
	mov edi, OFFSET theKey
	call encryptString
	;display the result
	mov esi, OFFSET theString
	movzx ecx, theStringLength
	call Displayresult
	jmp startHere

	opt2:;decrypt the string
	;clear string
	mov edx, OFFSET theString
	;movzx ecx, theStringLength
	;call clearstring
	
	mov edx, OFFSET theString
	cmp UserOption, 2
	jne opt3
	call clrscr
	;call clearstring
	mov ecx, maxStringLength
	call option1
	mov theStringLength, al
	;makes the letters all uppercase
	mov edx, OFFSET theString
	movzx ecx, theStringLength
	call ChangeCase
	;remove non chars
	mov ebx, OFFSET theStringLength
	movzx ecx, theStringLength
	mov edx, OFFSET theString
	mov esi,0
	call CharOnly
	;decrypts the string using the key
	mov esi, OFFSET theString
	movzx ecx, theStringLength
	mov edi, OFFSET theKey
	call decryptString
	;sets registers for passing arguments for the result
	mov esi, OFFSET theString
	movzx ecx, theStringLength
	call Displayresult
	jmp startHere
	
	opt3:;
	cmp UserOption, 3
	jne opt4
	jmp getKey
	
	opt4:;
	cmp UserOption, 4
	jne opt5

	jmp leaveNow
	
	opt5:
	cmp UserOption, 5
	jne opt6
	call WriteString;displays string
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
				'1. Enter a string to encrypt', 0Ah, 0Dh,
				'2. Enter a string to decrypt', 0Ah, 0Dh,
				'3. Enter new key', 0Ah, 0Dh,
				'4. Quit', 0Ah,0Dh,
				'Enter an option 1-4: ',0
;				'5. Print the string', 0Ah,0Dh,
;				'6. Quit',0Ah,0Dh,
				;'Enter an option 1-4: ',0

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

ChangeCase PROC uses edx ecx edi
;Desc: converts to uppercase
;recieves Offset of the string in edx, string length in ecx
;returns original string with all capital letters converted to lowercase
mov edi,0
loop2:
mov al, BYTE PTR [edx+edi];get element of string
cmp al,61h ;check if less than for lowercase
jb keepgoing ; if it is then continue
cmp al, 7Ah
ja keepgoing
sub al, 20h ;makes lowercase
mov BYTE PTR [edx+edi],al
keepgoing:
inc edi
loop loop2
ret
ChangeCase endp

letters PROC
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
letters endp


enterAKey PROC
.data
userPrompta BYTE "Enter a key --> ",0
.code
push edx		; save offset of string to stack
mov edx, OFFSET userPrompta
call WriteString
pop edx		;restore offset of string
call ReadString ;get user input
ret
enterAKey endp

encryptString PROC
;Description:  Encrypts a string from the key
;Receives: Offset of string in esi
;          length of string in ecx
;		   Offset of key in edi
;Returns: encrypted string
.data
displayEncryption BYTE "Encrypted String: ",0
.code
;mov edx,0
eLoop:
clearEAX
cmp BYTE PTR [edi],0;repeat the key
je startAgain
jmp Encrypto

startAgain:
mov edi, OFFSET theKey;beginning of key

Encrypto:
mov al, BYTE PTR [edi];letter in key
mov bl,1Ah;26d
div bl ; modulo in ah
add [esi],ah;shifts the letter to the right
cmp BYTE PTR [esi], 'Z'
jle continua
sub BYTE PTR [esi],1Ah;26d
cmp BYTE PTR [esi], 'A'
jge continua
add BYTE PTR [esi],1Ah;26d
continua:
inc esi
inc edi
loop eLoop
ret
encryptString endp


decryptString PROC
;Description:  Encrypts a string from the key
;Receives: Offset of string in esi
;          length of string in ecx
;		   Offset of key in edi
;Returns: encrypted string
.data
displayDecryption BYTE "Decrypted String: ",0
.code
deLoop:
clearEAX
cmp BYTE PTR [edi],0;repeat the key
je startAgaind
jmp decrypto

startAgaind:
mov edi, OFFSET theKey;starts at beginning of key

decrypto:
mov al, BYTE PTR [edi];letter in key
mov bl,1Ah;26d
div bl ; modulo in ah
sub [esi],ah;shifts the letter to the right
cmp BYTE PTR [esi], 'Z'
jle checka

sub BYTE PTR [esi],1Ah;26d
jmp continua

checka:
cmp BYTE PTR [esi], 'A'
jge continua
add BYTE PTR [esi],1Ah;26d
continua:
inc esi
inc edi
loop deLoop
ret
decryptString endp

ClearString PROC USES EDX ECX ESI
;Description:  Clears a byte array given offset in edx and length in ecx
;Receives: Offset of string to be cleared in edx
;          length of string to be cleared in ecx
;Returns: nothing


;// increment through the passed array and set every element to zero
clearESI
ClearIt:
mov byte ptr [edx + esi], 0
inc esi
loop ClearIt

ret
ClearString ENDP

Displayresult PROC uses EDX
;Description: displays menu
;recieves the offset of string in edx and length in ecx and offset of key
;returns a print out of the string with a space every 5 characters

.data
reulst1 BYTE 'Result: ',0
keytext BYTE 'Key: ',0
spaceCounter BYTE 0
.code
push edx;save offset of string to stack
;call clrscr ; clears screen
mov edx, OFFSET keytext
call writestring
mov edx,OFFSET theKey
call writestring
call crlf
mov edx, OFFSET reulst1
call WriteString ;displays
pop edx 
;loop for the string
mov spaceCounter,0d;reset counter
loopo:
mov al, BYTE PTR [edx];letter in string
call writechar
inc spaceCounter;every five put a  space
cmp spaceCounter,5
je outo
cmp spaceCounter,10
je outo
cmp spaceCounter,15
je outo
cmp spaceCounter,20
je outo
cmp spaceCounter,25
je outo
cmp spaceCounter,30
je outo
cmp spaceCounter,35
je outo
cmp spaceCounter,40
je outo
cmp spaceCounter,45
je outo
cmp spaceCounter,50
je outo
jmp nonspace
outo:
mov al, ' '
call writechar
nonspace:
inc edx
loop loopo
call crlf;endline
call waitmsg
ret
Displayresult endp

CharOnly PROC USES ecx edx esi
;// Description:  Removes all non-letter elements
;// Receives:  ecx - length of string
;//            edx - offset of string
;//            ebx - offset of string length variable
;//            esi preserved
;// Returns: string with all non-letter elements removed

.data
tempstr BYTE 50 dup(0)        ;// hold string while working - 

.code
;// preserve edx, ecx
push edx
push ecx

;// clear tempstr for repeated calls from main
mov edx, offset tempstr
mov ecx, 50
call ClearString

;// restore ecx, edx
pop ecx
pop edx


push ecx                      ;// save value of ecx for next loop
clearEDI                      ;// use edi as index to step through the string
L3:
mov al, byte ptr [edx + esi]  ;// grab an element of the string

;// check to see if the element is a letter.  
cmp al, 5Ah
ja lowercase    ;// if above 5Ah has a chance of being lowercase
cmp al, 41h     ;// if below 41h will not be a letter so skip this element
jb skipit
jmp addit       ;// otherwise it is a capital letter and should be added to our temporary string

lowercase:
cmp al, 61h     
jb skipit       ;// if below then is not a letter but is in the range 5Bh and 60h
cmp al, 7Ah     ;// if above then it is not a letter, otherwise it is a lowercase letter
ja skipit

addit:          ;// if determined to be a letter, then it must be added to the temp string
mov tempstr[edi], al
inc edi         ;// move to next element of theString
inc esi         ;// move to next element of temp string
jmp endloop     ;// go to the end of the loop

skipit:         ;// skipping the element 
inc esi         ;// go to next element of theString

endloop:
loopnz L3

mov [ebx], edi   ;// updates length of string

pop ecx         ;// restores original value of ecx for the next loop

;// copies the temp string to theString will all non-letter elements removed
clearEDI
L3a:     
mov al, tempstr[edi]
mov byte ptr [edx + edi], al
inc edi
loop L3a

ret
CharOnly ENDP


end main

;modulo example
;mov ax,0083h
;mov bl,2
;div bl ; al=41 bl= 1=the remainder
TITLE hangman.asm
; Program that computes prime numbers
; Adam Smith
; 12-1-17

Include Irvine32.inc

;Macros/Symbolics
clearEAX TEXTEQU <mov EAX, 0>
clearEBX TEXTEQU <mov EBX, 0>
clearECX TEXTEQU <mov ECX, 0>
clearEDX TEXTEQU <mov EDX, 0>
clearESI TEXTEQU <mov ESI, 0>
clearEDI TEXTEQU <mov EDI, 0>

arraySize = 1000d

.data
	; declare variables here
	UserOption BYTE 0h
	boolArray SDWORD arraySize DUP (0)
	errorPrompt BYTE 'Error: Enter a valid integer 1-2',0Ah,0Dh,0
	
.code
main proc
	; write your code here
	clearEAX
	clearEBX
	clearECX
	clearEDX
	clearESI
	clearEDI
	
	;proto example
	;DisplayPrimes PROTO, 
	;ptrArrayb:PTR DWORD
	
	startHere:
	call DisplayMenu
	call ReadHex
	mov UserOption, al
	
	opt1: ;read a string
	cmp UserOption, 1
	jne opt2
	call clrscr;clear screen
	;PROTO
	FindPrimes PROTO, 
		ptrArray:PTR SDWORD
	INVOKE FindPrimes, ADDR boolArray
	
	jmp startHere

	opt2:;display primes
	cmp UserOption, 2
	jne opt3
	call clrscr
	DisplayPrimes PROTO, 
		ptrArrayb:PTR SDWORD
	INVOKE DisplayPrimes, ADDR boolArray

	jmp startHere
	
	opt3:;remove non-letter elements
	cmp UserOption, 3
	je leaveNow
	mov edx, OFFSET errorPrompt;put error when user puts invalid entry
	call WriteString
	call WaitMsg
	jmp starthere

	leaveNow:
	
call WaitMsg ; press any key to continue irvine function
	;INVOKE FindPrimes;, ADDR boolArray,LENGTHOF boolArray
	
	exit
main endp

DisplayMenu PROC
;Description: displays menu
;recieves nothing
;returns nothing

.data
MenuPrompt1 BYTE 'MAIN MENU' , 0Ah, 0Dh,;character line feed
				'===========',0Ah,0Dh,
				'1. Find Primes', 0Ah, 0Dh,
				'2. Display Primes', 0Ah, 0Dh,
				'3. Quit', 0Ah, 0Dh,
				'Enter an option 1-3: ',0

.code
call clrscr ; clears screen
mov edx, OFFSET MenuPrompt1
call WriteString ;displays menu
ret
DisplayMenu endp

;DEScription: find primes and store them in an array
;recieves offset of array
;returns  array
FindPrimes PROC, 
	ptrArray: PTR SDWORD
.data
userPrompt12 BYTE "Enter your number ",0

.code

	clearECX
	mov esi, ptrArray;puts array into register
	mov edi, -1;for comparing
	fillArray:
		mov eax, ecx
		add eax, 2
		mov [esi + (4 * ecx)], eax
		inc ecx
	
		cmp eax, arraySize;until end of array
		jb fillArray;jump if below
	
	clearECX
	;go through each integer multiple
	L1:
		mov ebx, ecx;store ecx
		inc ebx
		cmp [esi + (4 * ecx)], edi;compare if -1
		jne L2;jump if not equal
		
	restart1:
		inc ecx
		cmp ecx, arraySize;until array size
		jb L1;jump below
		jmp leavo
		
	L2:
		cmp [esi + (4 * ebx)], edi;compare if -1
		jne L3;jump if not equal
		
	restart2:
		inc ebx
		cmp ebx, arraySize;go until array size
		jb L2;jump below
		jmp restart1
		
		
	L3:
		clearEDX
		clearEAX
		mov eax, [esi + (4 * ebx)]
		div SDWORD PTR [esi + (4 * ecx)];if there is no remainder then the number is not prime
		cmp edx, 0
		je nonpr;jump if equal to 0
		
	goBack:
		jmp restart2
		
		
	nonpr:
		mov [esi + (4 * ebx)], edi;marks spot as not prime
		jmp goBack
		
	leavo:
		clearECX
		clearEBX
ret
FindPrimes endp

;DEScription: displays primes in the range
;recieves offset of array
;returns  primes within the range
DisplayPrimes PROC, 
	ptrArrayb:PTR SDWORD;array is passed in
.data
userPrompt1 BYTE "Display Primes from 0 - n, n < 1000. Enter integer n: ",0
conclusionPrompt1 BYTE "There are ",0
conclusionPrompt2 BYTE " primes between 2 and ",0
dashes BYTE "----------------------------------",0
errorCheck1 BYTE "Your input was incorrect try again. ",0
intN DWORD ?
rowCounter BYTE 0
primeCounter DWORD 0
.code
	topp:;when user inputs incorrectly
	clearECX
	mov edi, ptrArrayb;array is put in edi
	mov edx, OFFSET userPrompt1
	mov ebx,-1
	call writestring;prompt for user
	call readint
	cmp eax,1000
	ja errorCheck
	cmp eax,2
	jb errorCheck 
	jmp goodInput
	errorCheck:
	mov edx,OFFSET errorCheck1
	call writestring
	call waitmsg;press any key to continue
	call clrscr;clearscreen
	jmp topp
	goodInput:
	mov intN,eax;store user N
	dec eax;mov back one
	mov ecx,eax;counter is set
	mov esi,0
	mov edx,0
	mov dh,1;set up coord
	mov rowCounter,0;reset coord
	mov primeCounter,0
	Printp:
	cmp [edi + (4 * esi)], ebx;check if prime
	je notprime
	;inc primeCounter
	add primeCounter,1
	mov eax, [edi + (4 * esi)]
	cmp rowCounter,5
	jne onward
	add dh,1;row
	mov rowCounter,0
	mov dl,0;back to column
	onward:
	call GOTOXY;move cursor to coord
	call WriteDec
	add dl,5;column
	inc rowCounter

	inc esi
	jmp ContinueLoop

	notprime:
	inc esi
	
	ContinueLoop:
	loop Printp
	
	;outro words
	call crlf;endline
	mov edx,OFFSET dashes
	call writestring
	call crlf
	mov edx,OFFSET conclusionPrompt1
	call writestring
	mov eax,primeCounter
	call writeDec
	mov edx, OFFSET conclusionPrompt2
	call writestring
	mov eax,intN
	call writedec
	call crlf;endline
	call waitmsg
ret
DisplayPrimes endp
	
end main
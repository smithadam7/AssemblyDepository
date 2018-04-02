TITLE hangman.asm
; Program has a connect 3 game
; Adam Smith
; 12-8-17

Include Irvine32.inc

;Macros/Symbolics
clearEAX TEXTEQU <mov EAX, 0>
clearEBX TEXTEQU <mov EBX, 0>
clearECX TEXTEQU <mov ECX, 0>
clearEDX TEXTEQU <mov EDX, 0>
clearESI TEXTEQU <mov ESI, 0>
clearEDI TEXTEQU <mov EDI, 0>

rowlength = 4
.data
	; declare variables here
	UserOption BYTE 0h
	errorPrompt BYTE 'Error: Enter a valid integer 1-4',0Ah,0Dh,0
	rules BYTE 'RULES: The first player is randomly chosen. The goal if the game is to get 3 in a',0Ah,0Dh,'row horizontally, vertically, or diagonally before your opponent. Good luck!',0Ah,0Dh,0
	player1WinCount DWORD 0d
	player1LossCount Dword 0d
	player1TieCount Dword 0d
	;gameboard
	tableB BYTE 0,0,0,0
	Rowsize = ($ - tableB)
		BYTE 0,0,0,0
		BYTE 0,0,0,0
		BYTE 0,0,0,0
	;ascii block is 0DBh
	defaultColor = lightGray + (black * 16);default color scheme
	blueColor = blue + (blue * 16);blue on blue
	yellowColor = yellow + (yellow * 16);yellow on yellow
	blackcolor = black+ (black*16);black on black
	redcolor=lightgreen+(black*16);lightgreen on black
	
.code
main proc
	; write your code here
		;display rules
	mov eax,redcolor
	call setTextColor
	mov edx,offset rules
	call writestring
	mov eax,defaultColor
	call setTextColor
	call crlf;endline
	call waitmsg;press any key to continue
	call clrscr;clear screen 
	
	;protos
	blockplacer PROTO,
		ptrArray:PTR BYTE
		
	threeinarow PROTO,
		ptrArray:PTR BYTE
	
	clearboard PROTO,
		ptrArray:PTR BYTE
		
	mov ecx,rowlength;contains 4
	displayBoard PROTO,
		ptrArray:PTR BYTE
		
	
	;INVOKE displayBoard, ADDR tableB
	;call waitmsg
	startHere:
	;clear registers
	clearEAX
	clearEBX
	clearECX
	clearEDX
	clearESI
	clearEDI
	menuo:
	call DisplayMenu
	call ReadHex
	mov UserOption, al
	
	;Procedure selection process
	opt1:
	cmp UserOption, 1
	jne opt2
	;PROTO
	pvp PROTO, 
		ptrArray:PTR BYTE
	INVOKE pvp, ADDR tableB
	call crlf ; endline
	jmp startHere
	
	opt2:
	cmp UserOption,2
	jne opt3
	pvc PROTO, 
		ptrArray:PTR BYTE
	INVOKE pvc, ADDR tableB
	jmp starthere
	
	opt3:
	cmp UserOption,3
	jne opt4
	cvc PROTO, 
		ptrArray:PTR BYTE
	INVOKE cvc, ADDR tableB
	jmp starthere
	
	opt4:
	cmp UserOption, 4
	je leaveNow
	mov edx, OFFSET errorPrompt;otherwise the user input an invalid character
	call WriteString
	call WaitMsg
	jmp starthere

	leaveNow:
	
call WaitMsg ; press any key to continue irvine function

	exit
main endp

DisplayMenu PROC
;Description: displays menu
;recieves nothing
;returns nothing

.data
MenuPrompt1 BYTE 'MAIN MENU' , 0Ah, 0Dh,;character line feed
				'===========',0Ah,0Dh,
				'1. Player 1 vs Player 2', 0Ah, 0Dh,
				'2. Player 1 vs Computer 1',0Ah,0Dh,
				'3. Computer 1 vs Computer 2',0Ah,0Dh,
				'4. Quit', 0Ah, 0Dh,
				'Enter an option 1-4: ',0
p1statsprompt1 BYTE 'Player 1 games won: ',0
p1statsprompt2 BYTE 'Player 1 games lost: ',0
p1statsprompt3 BYTE 'Player 1 games tied: ',0

.code
call clrscr ; clears screen
mov edx, OFFSET MenuPrompt1
call WriteString ;displays menu
call crlf;endlime
call crlf;endlime
call crlf;endlime
call crlf;endlime
mov edx,OFFSET p1statsprompt1
call writestring
mov eax, player1WinCount
call writedec
call crlf
mov edx,OFFSET p1statsprompt2
call writestring
mov eax, player1LossCount
call writedec
call crlf
;mov edx,OFFSET p1statsprompt3
;call writestring
;mov eax, player1TieCount
;call writedec
;call crlf
ret
DisplayMenu endp

;DEScription: player vs player game
;recieves offset of gameboard, and player 1 win count
;returns  game win count
pvp PROC,
	ptrArray: PTR BYTE
	
	LOCAL maxmoves: BYTE, player1color: BYTE, player2color: BYTE
.data
	;local variables
	player1turn BYTE 'Player 1 turn',0
	player2turn BYTE 'Player 2 turn',0
	comp1urn BYTE 'Computer 1 turn',0
	comp2urn BYTE 'Computer 2 turn',0
	player1won BYTE 'Player 1 won!',0
	player2won BYTE 'Player 2 won!',0
	comp1won BYTE 'Computer 1 won!',0
	comp2won BYTE 'Computer 2 won!',0
	tiegame BYTE 'Tie game!',0
	errorcheck BYTE 'Invalid Input!',0
.code
	mov player1color,2
	mov player2color,1
	mov maxmoves,16d
	mov esi,ptrArray
	;mov ecx,rowlength;contains 4
	;displayBoard PROTO,
	;	ptrArray:PTR BYTE
	;INVOKE displayBoard, ADDR tableB
	
	;decide who goes randomly
	call randomize
	mov eax,123d
	call randomrange
	mov dl,2
	div dl
	;ah has remainder
	cmp ah,0
	
	jne player2turno;randomly decide who goes first
	;jump to starting player
	mov player1color,1
	mov player2color,2
	
	;player 1 blue's turn
	player1turno:
	call clrscr
	mov edx, offset player1turn
	call writestring;prompt
	call crlf;endline
	mov ecx,rowlength;contains 4
	displayBoard PROTO,
		ptrArray:PTR BYTE
	INVOKE displayBoard, ADDR tableB
	call readhex
	cmp eax,4;errorcheck
	ja errorchecko
	cmp eax,1
	jb errorchecko
	;place block in correct column
	dec maxmoves
	cmp maxmoves,0
	je gameresultTie
	mov dl,player1color
	;call blockplacer
	INVOKE blockplacer,ADDR tableB
	cmp p1bool,1;did the player win?
	jne player2turno;if no continue
	mov edx,OFFSET player1won;if yes tell them
	call crlf;endline
	call writestring
	;put player 1 stats
	add player1WinCount,1
	call crlf
	;call waitmsg
	jmp donepvp;and quit the pvp
	
	;player 2 yellow's turn
	player2turno:
	call clrscr
	mov edx, offset player2turn
	call writestring;prompt
	call crlf;endline
	mov ecx,rowlength;contains 4
	displayBoard PROTO,
		ptrArray:PTR BYTE
	INVOKE displayBoard, ADDR tableB
	call readhex
	cmp eax,4;errorcheck
	ja errorchecko
	cmp eax,1
	jb errorchecko
	;place block in correct column
	dec maxmoves
	cmp maxmoves,0
	je gameresultTie
	mov dl,player2color
	;call blocplacer
	INVOKE blockplacer,ADDR tableB
	cmp p1bool,1;did the player win?
	jne player1turno;if no continue
	mov edx,OFFSET player2won;if yes tell them
	add player1LossCount,1
	call crlf;endline
	call writestring
	call crlf
	;call waitmsg
	jmp donepvp;and quit the pvp
	
	jmp player1turno
	
	errorchecko:
	mov edx,OFFSET errorcheck
	call writestring
	call crlf;endline
	jmp donepvp
	gameresultTie:
	add player1TieCount,1
	mov edx,OFFSET tiegame
	call writestring
	donepvp:
	call waitmsg;press any key to continue
	INVOKE clearboard, ADDR tableB;reset the game board to empty
	
ret
pvp endp

;DEScription: player vs player game
;recieves offset of gameboard, and player 1 win count
;returns  game win count
pvc PROC,
	ptrArray: PTR BYTE
	
	LOCAL maxmoves: BYTE, player1color: BYTE, player2color: BYTE

	mov player1color,2
	mov player2color,1
	mov maxmoves,16d
	mov esi,ptrArray
	;mov ecx,rowlength;contains 4
	;displayBoard PROTO,
	;	ptrArray:PTR BYTE
	;INVOKE displayBoard, ADDR tableB
	
	;decide who goes randomly
	call randomize
	mov eax,123d
	call randomrange
	mov dl,2
	div dl
	;ah has remainder
	cmp ah,0
	
	jne comp2turno;randomly decide who goes first
	;jump to starting player
	mov player1color,1
	mov player2color,2
	
	;player 1 blue's turn
	player1turnoc:
	call clrscr
	mov edx, offset player1turn
	call writestring;prompt
	call crlf;endline
	mov ecx,rowlength;contains 4
	displayBoard PROTO,
		ptrArray:PTR BYTE
	INVOKE displayBoard, ADDR tableB
	call readhex
	cmp eax,4;errorcheck
	ja errorcheckop
	cmp eax,1
	jb errorcheckop
	;place block in correct column
	dec maxmoves
	cmp maxmoves,0
	je gameresultTie
	mov dl,player1color
	;call blockplacer
	INVOKE blockplacer,ADDR tableB
	cmp p1bool,1;did the player win?
	jne comp2turno;if no continue
	mov edx,OFFSET player1won;if yes tell them
	call crlf;endline
	call writestring
	;put player 1 stats
	add player1WinCount,1
	call crlf
	;call waitmsg
	jmp donepvc;and quit the pvp
	
	;player 2 yellow's turn
	comp2turno:
	call clrscr
	mov edx, offset comp2urn
	call writestring;prompt
	call crlf;endline
	mov ecx,rowlength;contains 4
	displayBoard PROTO,
		ptrArray:PTR BYTE
	INVOKE displayBoard, ADDR tableB
	;call readhex
	;cmp eax,4;errorcheck
	;ja errorcheckop
	;cmp eax,1
	;jb errorcheckop
	;place block in correct column
		mov eax,2000
	call delay
	push edx
	clearEDX
	mov eax,123d
	call randomrange;random number in eax
	inc eax
	mov dl,4
	div dl
	;movzx eax,dl
	movzx eax,ah
	pop edx
	dec maxmoves
	cmp maxmoves,0
	je gameresultTie
	mov dl,player2color
	;call blocplacer
	INVOKE blockplacer,ADDR tableB
	cmp p1bool,1;did the player win?
	jne player1turnoc;if no continue
	mov edx,OFFSET comp2won;if yes tell them
	add player1LossCount,1
	call crlf;endline
	call writestring
	call crlf
	;call waitmsg
	jmp donepvc;and quit the pvp
	
	jmp player1turnoc
	
	errorcheckop:
	mov edx,OFFSET errorcheck
	call writestring
	call crlf;endline
	jmp donepvc
	gameresultTie:
	add player1TieCount,1
	mov edx,OFFSET tiegame
	call writestring
	donepvc:
	call waitmsg;press any key to continue
	INVOKE clearboard, ADDR tableB;reset the game board to empty
	
ret
pvc endp

;DEScription: player vs player game
;recieves offset of gameboard, and player 1 win count
;returns  game win count
cvc PROC,
	ptrArray: PTR BYTE
	
	LOCAL maxmoves: BYTE, player1color: BYTE, player2color: BYTE

	mov player1color,2
	mov player2color,1
	mov maxmoves,16d
	mov esi,ptrArray
	;mov ecx,rowlength;contains 4
	;displayBoard PROTO,
	;	ptrArray:PTR BYTE
	;INVOKE displayBoard, ADDR tableB
	
	;decide who goes randomly
	call randomize
	mov eax,123d
	call randomrange
	mov dl,2
	div dl
	;ah has remainder
	cmp ah,0
	
	jne comp2turnor;randomly decide who goes first
	;jump to starting player
	mov player1color,1
	mov player2color,2
	
	;player 1 blue's turn
	cvc1turn:
	call clrscr
	mov edx, offset comp1urn
	call writestring;prompt
	call crlf;endline
	mov ecx,rowlength;contains 4
	displayBoard PROTO,
		ptrArray:PTR BYTE
	INVOKE displayBoard, ADDR tableB
	mov eax,2000
	call delay
	;cmp eax,4;errorcheck
	;ja errorcheckopcvc
	;cmp eax,1
	;jb errorcheckopcvc
	;place block in correct column
	dec maxmoves
	cmp maxmoves,0
	push edx
	clearEDX
	mov eax,123d
	call randomrange;random number in eax
	inc eax
	mov dl,4
	div dl
	;movzx eax,dl
	movzx eax,ah
	pop edx
	je gameresultTiecvc
	mov dl,player1color
	;call blockplacer
	INVOKE blockplacer,ADDR tableB
	cmp p1bool,1;did the player win?
	jne comp2turnor;if no continue
	mov edx,OFFSET comp1won;if yes tell them
	call crlf;endline
	call writestring
	call crlf
	;call waitmsg
	jmp donecvc;and quit the pvp
	
	;player 2 yellow's turn
	comp2turnor:
	call clrscr
	mov edx, offset comp2urn
	call writestring;prompt
	call crlf;endline
	mov ecx,rowlength;contains 4
	displayBoard PROTO,
		ptrArray:PTR BYTE
	INVOKE displayBoard, ADDR tableB
	mov eax,2000;for a 2 second delay
	call delay
	push edx
	clearEDX
	mov eax,123d
	call randomrange;random number in eax
	inc eax;for the random columns
	mov dl,4
	div dl
	movzx eax,ah;remainder goes to eax for the blockplacer
	pop edx
	dec maxmoves
	cmp maxmoves,0
	je gameresultTiecvc
	mov dl,player2color
	;call blocplacer
	INVOKE blockplacer,ADDR tableB
	cmp p1bool,1;did the player win?
	jne cvc1turn;if no continue
	mov edx,OFFSET comp2won;if yes tell them
	call crlf;endline
	call writestring
	call crlf
	;call waitmsg
	jmp donecvc;and quit the pvp
	
	jmp cvc1turn
	
	errorcheckopcvc:
	mov edx,OFFSET errorcheck;if something bad happens, then exit game and tell user they did bad
	call writestring
	call crlf;endline
	jmp donecvc
	gameresultTiecvc:
	add player1TieCount,1
	mov edx,OFFSET tiegame
	call writestring
	donecvc:
	call waitmsg;press any key to continue
	INVOKE clearboard, ADDR tableB;reset the game board to empty
	
ret
cvc endp

;DEScription: display game game
;recieves offset of gameboard, and player 1 win count
;returns  game win count
displayBoard PROC,
	ptrArray: PTR BYTE
.data
	;local variables
	board BYTE '---1------2------3------4----',0ah,0dh,0
	border BYTE '------------------------------',0
	block BYTE 0DBh
	userPrompta BYTE 'Enter a column to place a block 1-4: ',0
	userColumn BYTE 0d
	rowcounterpvp BYTE ?
	spaceString BYTE '     ',0
	p1bool BYTE 0
	p2bool BYTE 0
	badcolumn BYTE 'Block placed in full column, turn wasted.',0
.code
	
	;mov esi,ptrArray
	;mov edi,0;increment through array
	;display the board
	;save registers to stack
	push eax
	push ebx
	push edx
	push esi
	push edi
	mov edx,OFFSET userPrompta;user prompt is displayed from edx
	call writestring
	call crlf;endline
	mov edx, OFFSET board;shows the board top with column annotations
	call writestring;shows the column numbers
	call crlf
	
	mov edi,0
	clearEDX
	clearEAX
	
	DisplayRows:;each row
	mov ebx,ptrArray;array is passed into the functions
	cmp ecx,edi
	je doneDisp;when it is done
	mul ecx;calculates row 
	add ebx,eax;
	mov esi,0;clear
	inc edi
	push edi;saves to stack
	mov edi,0;clears
	
	DisplayColumns:;each column
	cmp ecx,edi;check row end
	je doneRow;when its done
	push eax;sav to stack
	mov al,'|'
	call writechar;lines f=for the game
	mov al,' ';gameboard spaces
	call writechar
	mov al, [ebx+esi];moves array peice into register for comparing
	;check color
	cmp BYTE PTR al,0;zero represents nothing
	jne pvpcheckblue
	mov eax,blackcolor;black
	call setTextColor
	mov edx,OFFSET spaceString
	call writestring
	mov eax,defaultColor
	call setTextColor;restre correct colors
	jmp doneColor
	
	pvpcheckblue:;check for blue
	cmp BYTE PTR al,1;1 is bljue
	jne pvpcheckyellow;otherwise it is yellow
	mov eax,blueColor
	call setTextColor
	mov edx,OFFSET spaceString;put blue spaces
	call writestring
	mov eax,defaultColor
	call setTextColor
	jmp doneColor
	
	pvpcheckyellow:
	mov eax,yellowColor;make it yellow
	call setTextColor
	mov edx,OFFSET spaceString;put spaces and color them
	call writestring
	mov eax,defaultColor;make colors default
	call setTextColor
	
	doneColor:;when the coloring is finished
	mov eax,defaultColor
	call setTextColor
	pop eax;restore
	inc esi;next
	inc edi;next
	jmp DisplayColumns
	
	doneRow:
	mov al,'|'
	call writechar
	call crlf
	mov edx,offset border
	call writestring
	call crlf;endline
	pop edi
	mov eax,edi
	jmp DisplayRows
	
	doneDisp:

;restore registers from stack
pop edi
pop esi
pop edx
pop ebx
pop eax
;call waitmsg;press any key to continue	
ret
displayBoard endp

;description puts block in right column
;recives board array and column location in eax
;returns modified array
blockplacer proc,
	ptrArray: PTR BYTE
	dec eax;for arrays
	mov esi,eax;column
	mov eax,3
	mov ebx,ptrArray;array is now in ebx
	push edx;multiplying uses
	mul ecx
	add ebx,eax
	pop edx;restored from stack
	;mov esi,0;column
	mov edi,4;coutner
	
	;when player puts a block on a full column , the block and turn is wasted
	checku:
	cmp ecx,esi;see if comlumn is full
	je fullcolumn;if equal jump
	cmp BYTE PTR [ebx+esi],0;see if empty
	je emptyspot
	sub ebx,4
	dec edi;decrement register
	jmp checku
	
	emptyspot:
	mov [ebx+esi],dl;correct color goes in;should be dl
	mov edi,1
	jmp insertdone
	
	fullcolumn:
	mov edi,0
	push edx
	mov edx,offset badcolumn
	call crlf
	call writestring
	call waitmsg
	call crlf
	pop edx
	
	jmp insertdone
	
	insertdone:
	;now we will check for three in a row 
	;push edx
	mov edi,[ebx+esi];last blocklocation
	INVOKE threeinarow, ADDR tableB;threeinarow?
	;call writestring
	;call waitmsg
	;pop edx
	
	ret;urn
blockplacer endp

;description checks for 3 in a row
;recives board array and, color in dl
;returns winner or loser
threeinarow proc,
	ptrArray: PTR BYTE
	;local vars to keep track of directional correctness
	LOCAL romatch:BYTE,columnmatch:BYTE,diagmatch:BYTE
	mov ebx,ptrArray;put araay in ebx reg
	mov romatch,0;initialize local vars
	mov columnmatch,0
	mov diagmatch,0
	
	;reset
	mov p1bool,0
	;8 directions to check
	;1left:
	;cmp BYTE PTR[ebx+[esi-1]],dl
	;jne threeinarowNo
	;add romatch,1
	;;2left
	;cmp BYTE PTR [ebx+[esi-2]],dl
	;jne threeinarowNo
	;mov p1bool,1
	;jmp timetoret
	;mov edx,offset player1won
	;call writestring
	;call waitmsg
	;threeinarowNo:
	;checkrigh1
	;cmp BYTE PTR[ebx+[esi+1]],dl
	;jne checkright2
	;add romatch,1
	;cmp romatch,2
	;jne checkright2
	;mov p1bool,1
	;jmp timetoret
	
	;right2
	;checkright2:
	;cmp BYTE PTR[ebx+[esi+2]],dl
	;jne checkuptop1
	;add romatch,1
	;cmp romatch,2
	;jne checkuptop1
	;mov p1bool,1
	;jmp timetoret
	
	;checkuptop1:
	
	;24 POSSIBILITEIES 
	clearESI
	;step1
	cmp BYTE PTR[ebx+[esi]],dl;is it blue/yellow
	jne step2
	cmp BYTE PTR[ebx+[esi+4]],dl
	jne step2
	cmp BYTE PTR[ebx+[esi+8]],dl
	jne step2
	mov p1bool,1;if 3 equal blue/yellow
	
	step2:
	cmp BYTE PTR[ebx+[esi+4]],dl;is it blue
	jne step3
	cmp BYTE PTR[ebx+[esi+8]],dl
	jne step3
	cmp BYTE PTR[ebx+[esi+12]],dl
	jne step3
	mov p1bool,1;if 3 equal blue
	
	step3:
	cmp BYTE PTR[ebx+[esi+1]],dl;is it blue
	jne step4
	cmp BYTE PTR[ebx+[esi+5]],dl
	jne step4
	cmp BYTE PTR[ebx+[esi+9]],dl
	jne step4
	mov p1bool,1;if 3 equal blue
	
	step4:
	cmp BYTE PTR[ebx+[esi+5]],dl;is it blue
	jne step5
	cmp BYTE PTR[ebx+[esi+9]],dl
	jne step5
	cmp BYTE PTR[ebx+[esi+13]],dl
	jne step5
	mov p1bool,1;if 3 equal blue
	
	step5:
	cmp BYTE PTR[ebx+[esi+2]],dl;is it blue
	jne step6
	cmp BYTE PTR[ebx+[esi+6]],dl
	jne step6
	cmp BYTE PTR[ebx+[esi+10]],dl
	jne step6
	mov p1bool,1;if 3 equal blue
	
	step6:
	cmp BYTE PTR[ebx+[esi+6]],dl;is it blue
	jne step7
	cmp BYTE PTR[ebx+[esi+10]],dl
	jne step7
	cmp BYTE PTR[ebx+[esi+14]],dl
	jne step7
	mov p1bool,1;if 3 equal blue
	
	step7:
	cmp BYTE PTR[ebx+[esi+3]],dl;is it blue
	jne step8
	cmp BYTE PTR[ebx+[esi+7]],dl
	jne step8
	cmp BYTE PTR[ebx+[esi+11]],dl
	jne step8
	mov p1bool,1;if 3 equal blue
	
	step8:
	cmp BYTE PTR[ebx+[esi+7]],dl;is it blue
	jne step9
	cmp BYTE PTR[ebx+[esi+11]],dl
	jne step9
	cmp BYTE PTR[ebx+[esi+15]],dl
	jne step9
	mov p1bool,1;if 3 equal blue
	
	;horizontal 3 combos
	step9:
	cmp BYTE PTR[ebx+[esi+0]],dl;is it blue
	jne step10
	cmp BYTE PTR[ebx+[esi+1]],dl
	jne step10
	cmp BYTE PTR[ebx+[esi+2]],dl
	jne step10
	mov p1bool,1;if 3 equal blue
	
	step10:
	cmp BYTE PTR[ebx+[esi+1]],dl;is it blue
	jne step11
	cmp BYTE PTR[ebx+[esi+2]],dl
	jne step11
	cmp BYTE PTR[ebx+[esi+3]],dl
	jne step11
	mov p1bool,1;if 3 equal blue
	
	step11:
	cmp BYTE PTR[ebx+[esi+4]],dl;is it blue
	jne step12
	cmp BYTE PTR[ebx+[esi+5]],dl
	jne step12
	cmp BYTE PTR[ebx+[esi+6]],dl
	jne step12
	mov p1bool,1;if 3 equal blue
	
	step12:
	cmp BYTE PTR[ebx+[esi+5]],dl;is it blue
	jne step13
	cmp BYTE PTR[ebx+[esi+6]],dl
	jne step13
	cmp BYTE PTR[ebx+[esi+7]],dl
	jne step13
	mov p1bool,1;if 3 equal blue
	
	step13:
	cmp BYTE PTR[ebx+[esi+8]],dl;is it blue
	jne step14
	cmp BYTE PTR[ebx+[esi+9]],dl
	jne step14
	cmp BYTE PTR[ebx+[esi+10]],dl
	jne step14
	mov p1bool,1;if 3 equal blue
	
	step14:
	cmp BYTE PTR[ebx+[esi+9]],dl;is it blue
	jne step15
	cmp BYTE PTR[ebx+[esi+10]],dl
	jne step15
	cmp BYTE PTR[ebx+[esi+11]],dl
	jne step15
	mov p1bool,1;if 3 equal blue
	
	step15:
	cmp BYTE PTR[ebx+[esi+12]],dl;is it blue
	jne step16
	cmp BYTE PTR[ebx+[esi+13]],dl
	jne step16
	cmp BYTE PTR[ebx+[esi+14]],dl
	jne step16
	mov p1bool,1;if 3 equal blue
	
	step16:
	cmp BYTE PTR[ebx+[esi+13]],dl;is it blue
	jne step17
	cmp BYTE PTR[ebx+[esi+14]],dl
	jne step17
	cmp BYTE PTR[ebx+[esi+15]],dl
	jne step17
	mov p1bool,1;if 3 equal blue
	
	;diagonals
	step17:
	cmp BYTE PTR[ebx+[esi+0]],dl;is it blue
	jne step18
	cmp BYTE PTR[ebx+[esi+5]],dl
	jne step18
	cmp BYTE PTR[ebx+[esi+10]],dl
	jne step18
	mov p1bool,1;if 3 equal blue
	
	step18:
	cmp BYTE PTR[ebx+[esi+5]],dl;is it blue
	jne step19
	cmp BYTE PTR[ebx+[esi+10]],dl
	jne step19
	cmp BYTE PTR[ebx+[esi+15]],dl
	jne step19
	mov p1bool,1;if 3 equal blue
	
	step19:
	cmp BYTE PTR[ebx+[esi+4]],dl;is it blue
	jne step20
	cmp BYTE PTR[ebx+[esi+9]],dl
	jne step20
	cmp BYTE PTR[ebx+[esi+14]],dl
	jne step20
	mov p1bool,1;if 3 equal blue
	
	step20:
	cmp BYTE PTR[ebx+[esi+1]],dl;is it blue
	jne step21
	cmp BYTE PTR[ebx+[esi+6]],dl
	jne step21
	cmp BYTE PTR[ebx+[esi+11]],dl
	jne step21
	mov p1bool,1;if 3 equal blue
	
	step21:
	cmp BYTE PTR[ebx+[esi+2]],dl;is it blue
	jne step22
	cmp BYTE PTR[ebx+[esi+5]],dl
	jne step22
	cmp BYTE PTR[ebx+[esi+8]],dl
	jne step22
	mov p1bool,1;if 3 equal blue
	
	step22:
	cmp BYTE PTR[ebx+[esi+3]],dl;is it blue
	jne step23
	cmp BYTE PTR[ebx+[esi+6]],dl
	jne step23
	cmp BYTE PTR[ebx+[esi+9]],dl
	jne step23
	mov p1bool,1;if 3 equal blue
	
	step23:
	cmp BYTE PTR[ebx+[esi+6]],dl;is it blue
	jne step24
	cmp BYTE PTR[ebx+[esi+9]],dl
	jne step24
	cmp BYTE PTR[ebx+[esi+12]],dl
	jne step24
	mov p1bool,1;if 3 equal blue
	
	step24:
	cmp BYTE PTR[ebx+[esi+7]],dl;is it blue
	jne step25
	cmp BYTE PTR[ebx+[esi+10]],dl
	jne step25
	cmp BYTE PTR[ebx+[esi+13]],dl
	jne step25
	mov p1bool,1;if 3 equal blue
	
	;comment block
	COMMENT !
	
	mov p1bool,1;if 3 equal blue
	!
	step25:
	
	;timetoreturn
	timetoret:
	ret;urn
threeinarow endp

;description clears the board to its original state
;recives board array 
;returns modified array
clearboard proc,
	ptrArray: PTR BYTE
	
	;saves registers to stack
	push eax
	push ebx
	push esi
	push edi
	mov edi,0;clear reg
	mov eax,0;clear reg
	
	findarow:
	mov ebx,ptrArray;puts array into ebx
	cmp ecx,edi;when done
	je doneclear
	mul ecx;row index * row size
	add ebx,eax;row offset
	mov esi,0
	inc edi;next
	push edi
	mov edi,0
	
	clearcolumn:
	cmp ecx,edi;when done
	je doneclearrow
	push eax;save value of eax just in case
	mov al,0;;put 0 in al
	mov [ebx+esi],al;put zero back in the array
	pop eax;restore value of eax
	inc esi;next
	inc edi;next
	jmp clearcolumn
	
	doneclearrow:
	pop edi;restore from stack
	mov eax,edi
	jmp findarow
	
	doneclear:
	pop edi;restore registers from the stack
	pop esi
	pop ebx
	pop eax
	
	ret;urn
clearboard endp


end main
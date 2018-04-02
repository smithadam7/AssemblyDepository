title Inclassgrades.asm
;Adam Smith
;Quiz 4

include irvine32.inc

.data

Grades dword 50 dup (0)
lenArray byte 0;

.code

main PROC

mov eax, 0
mov ebx, offset lenArray
call userInt

mov ebx, offset Grades
movzx ecx, lenArray
call FillArray


;// Call to your procedures go here
movzx ecx, lenArray
call AlphaGrade

movzx ecx , lenArray
;call AssignColor

movzx eax, lenArray
;call PrintGrade

movzx ecx , lenArray
call PrintColor

call WaitMsg

exit
main ENDP

;// procedures

userInt PROC
;// Desc:  Gets an unsigned integer input from the user and places that value in a variable
;// Receives:  Offset of variable in EBX
;// Returns:  Nothing

.data
promptUser BYTE " Please enter a number <= 50 : ", 0h
oops BYTE "Invalid Entry.  Please try again.", 0h

.code
starthere:
   call clrscr
   mov edx, offset promptUser
   call writestring
   call readDec
cmp eax, 50d
ja tooBig
   mov [ebx], eax
ret

tooBig:
   mov edx, offset oops
   call writestring
   call waitmsg
jmp starthere

userInt ENDP

FillArray PROC
;// Desc:  Fills an array with a randomly generated numbers in the range 50 - 100
;// Receives:  Offset of a DWORD array in EBX
;//            Length of the Array in ECX
;// Returns:  Nothing

.code
mov esi, 1              ;// why is this 1? Hint:  It's not a mistake __________________________
call randomize

FillIt:
   mov eax, 51d
   call randomrange;puts random seed
   add eax, 50d            ;// what does this do? ______________________
   mov[ebx + esi], eax
   add esi, 4              ;// why can't we use TYPE here? _____________
loop FillIt


ret
FillArray ENDP



AlphaGrade PROC
mov esi, 1
mov edi, 0

;check each letter range
AssignGrade:
	cmp BYTE PTR [ebx + esi], 59d
	jg GradeD
	mov BYTE PTR [ebx + edi], 'F';place an f
	add esi, 4;next
	add edi, 4;next
	jmp Continue
	
GradeD:
	cmp BYTE PTR [ebx + esi], 69d
	jg GradeC
	mov BYTE PTR [ebx + edi], 'D'
	add esi, 4;nest
	add edi, 4;next
	jmp Continue
	
GradeC:
	cmp BYTE PTR [ebx + esi], 79d
	jg GradeB
	mov BYTE PTR [ebx + edi], 'C'
	add esi, 4;nect
	add edi, 4;next
	jmp Continue

GradeB:
	cmp BYTE PTR [ebx + esi], 89d
	jg GradeA
	mov BYTE PTR [ebx + edi], 'B'
	add esi, 4;nekst
	add edi, 4;nekst
	jmp Continue
	
GradeA:
	mov BYTE PTR [ebx + edi], 'A'
	add esi, 4;next
	add edi, 4;next
	jmp Continue
	
Continue:
loop AssignGrade;goes until no more numbers
	
ret
AlphaGrade ENDP

PrintGrade proc
;desc: prints number in bits 8-15 of the array and letter in bits 0-7 of corresponding word
;recieves offset of dword array in ebx and length of array in eax
;returns numbers and letters in array
mov ecx,eax;puts lenarray into loop counter
mov edx,0
mov esi,1
mov edi,0
mov dh,1


Printgr:
mov al,BYTE PTR [ebx+esi]
call WriteDec
mov dl,5;puts 5 spaces
call Gotoxy
;call PrintColor
mov al, BYTE PTR [ebx+edi]
call WriteChar
inc dh
add esi,4
add edi,4
call crlf
loop Printgr

ret
PrintGrade ENDP


AssignColor proc
mov edi,0
mov esi,0
loopcolor:
cmp BYTE PTR [ebx+edi],'A'
jne colorB
ror Grades,32
;ror ebx,2
;ror esi,1
;mov eax, green + (black * 16);green on black
mov BYTE PTR [ebx+edi],0
mov BYTE PTR [ebx+esi],2
jmp onward

colorB:
cmp BYTE PTR [ebx+edi],'B'
jne colorC
;ror esi,1
;ror ebx,2
ror Grades,8
mov BYTE PTR [ebx+edi],0
mov BYTE PTR [ebx+esi],2
jmp onward

colorC:
cmp BYTE PTR [ebx+edi],'C'
jne colorD
;ror esi,1
ror Grades,8
;ror ebx,2
mov BYTE PTR [ebx+edi],0
mov BYTE PTR [ebx+esi],14
jmp onward

colorD:
cmp BYTE PTR [ebx+edi],'D'
jne colorF
;ror esi,1
;ror ebx,2
ror Grades,8
mov BYTE PTR [ebx+edi],14
mov BYTE PTR [ebx+esi],0
jmp onward

colorF:
;ror esi,1
;ror ebx,2
ror Grades,8
mov BYTE PTR [ebx+edi],0
mov BYTE PTR [ebx+esi],4
jmp onward

onward:
add esi,4
add edi,4
;rol ebx,2
rol Grades,8
;rol esi,1
loop loopcolor
ret 
AssignColor ENDP


PrintColor proc
mov edx,0
mov edi,0
mov esi,1
mov dh,1

loopcolor1:
mov eax, lightgray + (black*16);default colors
call settextcolor
mov al,BYTE PTR [ebx+esi];puts number
call WriteDec;writes number
mov dl,5;puts 5 spaces
call Gotoxy;moves curson 5 spaces

;set color for coresponding letter
cmp BYTE PTR [ebx+edi],'A'
jne colorB1
mov eax, green + (black * 16);green on black
jmp onward1

colorB1:
cmp BYTE PTR [ebx+edi],'B'
jne colorC1
mov eax, green + (black * 16);green on blaack
jmp onward1

colorC1:
cmp BYTE PTR [ebx+edi],'C'
jne colorD1
mov eax, yellow + (black * 16);yellow on black
jmp onward1

colorD1:
cmp BYTE PTR [ebx+edi],'D'
jne colorF1
mov eax, black + (yellow * 16);black on lelow
jmp onward1

colorF1:
mov eax, red + (black * 16);red on black
jmp onward1

onward1:
call settextcolor;sets color based on letter
mov al, BYTE PTR [ebx+edi];movs the char
call WriteChar;writes the char
inc dh
add esi,4
add edi,4
call crlf;endline

loop loopcolor1
mov eax, lightgray + (black*16);default colors
call settextcolor
ret
PrintColor ENDP

END main

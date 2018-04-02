TITLE fibonacci.asm
; Program does fibonacci(6) with an array
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
	; fibonacci array fib(6)=8,fib(5)=5,fib(4)=3,fib(3)=2,fib(2)=1
	fibA BYTE 5 DUP(?) ;creates array for the fibonacci numbers
	fib0 BYTE 0 ;starting number
	fib1 BYTE 1 ;starting number

.code
main proc
	; write your code here
	clearEAX;clears registers 
	clearEBX
	clearECX
	clearEDX

	mov al,fib0
	add al,fib1 ;calculates fib2
	mov fibA,al ;puts fib2 into the array

	add al,fib1;calcs fib3
	mov [fibA+1],al  ;puts fib3 into array

	add al,[fibA];calcs fib4
	mov [fibA+2],al

	add al,[fibA+1];calcs fib5
	mov [fibA+3],al

	add al,[fibA+2];calcs fib5
	mov [fibA+4],al

	;move array to ebx in reverse order little endian: 08050302
	mov bx, WORD PTR [fibA+1]
	mov bx, WORD PTR [fibA+2]
	mov ebx, DWORD PTR [fibA+1]


	;mov ebx, BYTE PTR

call DumpRegs;shows registers

	exit
main endp
end main
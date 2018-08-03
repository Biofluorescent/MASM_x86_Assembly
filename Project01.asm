TITLE Basic Arithmetic     (Project01.asm)

; Author: Tanner Quesenberry
; Description: This program will introduce the program, author and instructions. The user is prompted
;				for two numbers and the sum, difference, product, quotient, and remainder will be
;				calculated and displayed to the user based off the user's input.
; References: Assembly Language 7th Edition (Class textbook)
;			  http://stackoverflow.com/questions/23358537/assembly-round-floating-point-number-to-001-precision-toward-%e2%88%9e?rq=1 (Strategy for rounding FPU)

INCLUDE Irvine32.inc



.data

number_1	DWORD	?	; user input 1
number_2	DWORD	?	; user input 2
sum			DWORD	?	; addition result
difference	DWORD	?	; subtraction result
product		DWORD	?	; multiplication result
quotient	DWORD	?	; division result 1
remainder	DWORD	?	; division result 2
scale		DWORD	1000
name_1		BYTE	"	By Tanner Quesenberry", 0
title_1		BYTE	"	Basic Arithmetic", 0
intro_1		BYTE	"Welcome. Please enter 2 integers and you will be shown ", 0
intro_2		BYTE	"the sum, difference, product, quotient, and remainder.", 0
prompt_1	BYTE	"First number: ", 0
prompt_2	BYTE	"Second number: ", 0
plus		BYTE	" + ", 0
minus		BYTE	" - ", 0
multiply	BYTE	" x ", 0
divide		BYTE	" / ", 0
equal		BYTE	" = ", 0
leftover	BYTE	" remainder ", 0
floatq		BYTE	"Floating-point quotient rounded to nearest .001 = ", 0
goodbye		BYTE	"Come back again. Goodbye!", 0
validate	BYTE	"Your second number must be less than your first number!", 0
prompt_3	BYTE	"Would you like to enter more numbers? (Enter lowercase 'y'): ", 0
yes			BYTE	"y", 0
ec_1		BYTE	"**EC: Program repeats if user decides to enter more numbers.", 0
ec_2		BYTE	"**EC: Program validates second number is less than first.", 0
ec_3		BYTE	"**EC: (Attempted) Program calculates and displays quotient as floating-point rounded to nearest .001", 0

.code
main PROC

; Initialize the FPU
	FINIT

; Display name and title
	mov EDX, OFFSET title_1
	call WriteString
	mov EDX, OFFSET name_1
	call WriteString
	call CrLf
	mov EDX, OFFSET ec_1
	call WriteString
	call CrLf
	mov EDX, OFFSET ec_2
	call WriteString
	call CrLf
	mov EDX, OFFSET ec_3
	call WriteString
	call CrLf
	call CrLf

; Introduce program
	mov EDX, OFFSET intro_1
	call WriteString
	call CrLf
	mov EDX, OFFSET intro_2
	call WriteString
	call CrLf
	call CrLf

; Get user data
TOP:							; Repeat here if user elects
	mov EDX, OFFSET prompt_1
	call WriteString
	call ReadInt
	mov number_1, EAX
	mov EDX, OFFSET prompt_2
	call WriteString
	call ReadInt
	mov number_2, EAX
	call CrLf

; Check if second number is smaller than first number
	mov EAX, number_2
	cmp EAX, number_1			; If number_2 > number_1
	jg ERROR					; Jump to validation statement

; Calculate required values
	mov EAX, number_1			; Add user input, store in variable
	add EAX, number_2
	mov sum, EAX

	mov EAX, number_1			; Subtract user input, stroe in variable
	sub EAX, number_2
	mov difference, EAX

	mov EAX, number_1			; Multiply user input, store in variable
	mov EBX, number_2
	mul EBX
	mov product, EAX

	mov EAX, number_1			; Divide user input, store in variables
	mov EBX, number_2
	div EBX
	mov quotient, EAX
	mov remainder, EDX

								; Calculate floating-point quotient
	FILD number_1				; Add number_1 as float to ST(0)
	FIDIV number_2				; Divide ST(0) by number_2 as a float, result in ST(0)
	FIMUL scale					; Scale up by 1000
	FRNDINT						; Round by converting to int
	FIDIV scale					; Scale down by 1000

; Display results
	mov EAX, number_1			; Display Addition results
	mov EDX, OFFSET plus
	call WriteDec
	call WriteString
	mov EAX, number_2
	mov EDX, OFFSET equal
	call WriteDec
	call WriteString
	mov EAX, sum
	call WriteDec
	call CrLf

	mov EAX, number_1			; Display Subtraction results
	mov EDX, OFFSET minus
	call WriteDec
	call WriteString
	mov EAX, number_2
	mov EDX, OFFSET equal
	call WriteDec
	call WriteString
	mov EAX, difference
	call WriteDec
	call CrLf

	mov EAX, number_1			; Display Multiplication results
	mov EDX, OFFSET multiply
	call WriteDec
	call WriteString
	mov EAX, number_2
	mov EDX, OFFSET equal
	call WriteDec
	call WriteString
	mov EAX, product
	call WriteDec
	call CrLf

	mov EAX, number_1			; Display Division results
	mov EDX, OFFSET divide
	call WriteDec
	call WriteString
	mov EAX, number_2
	mov EDX, OFFSET equal
	call WriteDec
	call WriteString
	mov EAX, quotient
	mov EDX, OFFSET leftover
	call WriteDec
	call WriteString
	mov EAX, remainder
	call WriteDec
	call CrLf
	
	mov EDX, OFFSET floatq		; Display quotient as floating-point number
	call WriteString
	call WriteFloat				; Writes float from FPU stack at ST(0)
	call CrLf
	call CrLf

; Ask if more input required
	mov EDX, OFFSET prompt_3
	call WriteString
	call ReadChar				; Character read into AL
	call CrLf
	cmp AL, yes
	je TOP						; Loop to top if (input == 'y')
	call CrLf
	jmp BYE						; No: jump to Goodbye

; Say goodbye
ERROR:							; Output error if number 2 > 1
	mov EDX, OFFSET validate
	call WriteString
	call CrLf
BYE:
	mov EDX, OFFSET goodbye
	call WriteString
	call CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main

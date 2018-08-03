TITLE Fibonacci Numbers     (Project02.asm)

; Author: Tanner Quesenberry
; Description: This program will introduce the program, author and instructions. The user
;			   is prompted for the number of Fibonacci terms to display. Terms are output
;				5 per row with 5 spaces separating each term. Up to 46 terms may be displayed.
; References: Assembly Language 7th Edition (Class textbook)

INCLUDE Irvine32.inc

UPPER EQU <46>						; Max int for user input
LOWER EQU <1>						; Minimum int for user input
TERMS EQU <5>						; Int to compare counter to

.data

userName		BYTE	33 DUP(0)	; String to be entered by user
userTerms		DWORD	?			; integer to be entered by user
termA			DWORD	1			; Fibonacci term placeholder (previous term)
termB			DWORD	0			; Fibonacci term placeholder (current term)
next			DWORD	1			; Next Fibonacci term / use in loop
counter			DWORD	0			; To compare to in calling CrLf in loop every 5 terms
program_title	BYTE	"      Fibonacci Numbers", 0
programmer_name	BYTE	"Programmed by Tanner Quesenberry", 0
prompt_1		BYTE	"Please enter your name: ", 0
greet_user		BYTE	"Hello there, ", 0
intro_2a		BYTE	"Please enter the number of Fibonacci terms to be displayed.", 0
intro_2b		BYTE	"The number must be an integer in the range of [1 - 46]", 0
prompt_2		BYTE	"How many terms would you like to display? ", 0
range_error		BYTE	"That number is out of range. Enter a term in [1 - 46]", 0
spaces			BYTE	"     ", 0
fun				BYTE	"Math is fun isn't it?", 0
goodbye			BYTE	"See you later, ", 0


.code
main PROC

; Display Program Title and Programmer Name
	mov EDX, OFFSET program_title
	call WriteString
	call CrLf
	mov EDX, OFFSET programmer_name
	call WriteString
	call Crlf
	call Crlf

; Get User Name and Greet User 
	mov EDX, OFFSET prompt_1
	call WriteString
	mov EDX, OFFSET userName
	mov ECX, 32						; Allow input up to 32 characters
	call ReadString
	mov EDX, OFFSET greet_user
	call WriteString
	mov EDX, OFFSET userName
	call WriteString
	call CrLf
	call CrLf

; User Instructions: Prompt user for number of Fibonacci Terms in range [1-46]
	mov EDX, OFFSET intro_2a
	call WriteString
	call CrLf
	mov EDX, OFFSET intro_2b
	call WriteString
	call CrLf
	call CrLf

; Get and validate user term input (do-while loop)
	jmp do
top:
	mov EDX, OFFSET range_error		; Output error
	call WriteString
	call CrLf
do:
	mov EDX, OFFSET prompt_2		; User enters input
	call WriteString
	call ReadInt
	cmp EAX, UPPER					; if input > UPPER
	ja top							; repeat loop
	cmp EAX, LOWER					; if input < LOWER
	jb top							; repeat loop

	mov userTerms, EAX
	call CrLf

; Calculate and display Fibonacci terms to nth term 
; (5 terms per line w/ 5 spaces between terms)
	mov ECX, userTerms
	mov EDX, OFFSET spaces			; To space out numbers
L1:
	mov EAX, next					; Output current term
	call WriteDec
	mov EAX, termB					; Add term A to B
	add EAX, termA
	mov termB, EAX
	mov EAX, next					; Assign A = next
	mov termA, EAX
	mov EAX, termB					; Assign next = B
	mov next, EAX
	call WriteString				; Output spaces
	inc counter
	mov EAX, counter
	cmp EAX, TERMS					; If term count == TERMS
	jb unequal
	call CrLf						; Output newline
	sub EAX, TERMS					; Reset counter
	mov counter, EAX
unequal:
	loop L1

; Display Parting message including user's name
	call CrLf
	call CrLf
	mov EDX, OFFSET fun
	call WriteString
	call CrLf
	mov EDX, OFFSET goodbye
	call WriteString
	mov EDX, OFFSET userName
	call WriteString
	call CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main

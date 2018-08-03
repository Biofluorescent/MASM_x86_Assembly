TITLE Combinatorics with Low Level I/O     (Project06B.asm)

; Author: Tanner Quesenberry
; Description: This program gives out random combinatoric problems for the user to solve. After each guess, the answer
;				is given and a message is output to the user declaring the correctness of their answer. They are then
;				asked if they want to do another problem. New problems are generated until the user decides to quit.
; References: Lecture slides
;			  Textbook
;			  Demo6.asm, Demo7.asm, Demo8.asm

INCLUDE Irvine32.inc

; CONSTANTS

LOWR			EQU		<1>
LOWN			EQU		<3>
HIGHN			EQU		<12>
MAXLENGTH		EQU		<10>

; Macro that writes a string
; Receives: OFFSET of string address
; Returns: none
; Preconditions: passed as offset
; Registers Changed: EDX
displayString MACRO string
	push	EDX
	mov		EDX, string
	call	WriteString
	pop		EDX
ENDM
.data

program_title		BYTE		"Combinatorics and Low level I/O Procedures     By Tanner Quesenberry", 0			; intro messages
intro_1a			BYTE		"This program is used to practice solving combinatoric problems.", 0
intro_1b			BYTE		"You are asked to determine the number of combinations of r items from", 0
intro_1c			BYTE		"a set of n items. The program generates random numbers for each and ", 0
intro_1d			BYTE		"gives you a problem. Enter your answer and it will be evaluated. You", 0
intro_1e			BYTE		"may repeat as many times as you want. Good luck!", 0

r					DWORD		?																					; store random nums and factorial results
n					DWORD		?
n_fact				DWORD		1
r_fact				DWORD		1
nr_fact				DWORD		1
result				DWORD		?
yes					BYTE		"y", 0
no					BYTE		"n", 0
response			DWORD		?			
answerS				BYTE		MAXLENGTH DUP(?)																	; user guess as string
answerD				DWORD		?																					; user guess as int
problem				BYTE		"Problem: ", 0																		; Strings used throughout program after intro
set					BYTE		"Number of elements in the set: ", 0
choose				BYTE		"Number of elements to choose from the set: ", 0
prompt_1			BYTE		"How many ways can you choose? ", 0
prompt_2			BYTE		"Do another problem? (y/n): ", 0
error				BYTE		"Invalid response. ", 0
report_1			BYTE		"There are ", 0
report_2			BYTE		" combinations of ", 0
report_3			BYTE		" items from a set of ", 0
correct				BYTE		" is correct! Great job!", 0
incorrect			BYTE		" is incorrect. Get back to practicing.", 0

goodbye				BYTE		"See you next time!", 0

.code
main PROC
	
	; Seed random number generator
	call	Randomize

	; Introduction
	push	OFFSET program_title
	push	OFFSET intro_1a
	push	OFFSET intro_1b
	push	OFFSET intro_1c
	push	OFFSET intro_1d
	push	OFFSET intro_1e
	call	introduction

PROB:

	; Show current problem
	push	OFFSET problem
	push	OFFSET set
	push	OFFSET choose
	push	OFFSET n
	push	OFFSET r
	call	showProblem

	; Get user answer
	push	OFFSET answerD
	push	OFFSET error
	push	OFFSET prompt_1
	push	OFFSET answerS
	call	getData


	; Calculate combination/factorial
	push	OFFSET n_fact
	push	OFFSET r_fact
	push	OFFSET nr_fact
	push	r
	push	n
	push	OFFSET result
	call	combinations


	; Show Problem results
	push	answerD
	push	OFFSET correct
	push	OFFSET incorrect
	push	result
	push	OFFSET report_1
	push	OFFSET report_2
	push	OFFSET report_3
	push	n
	push	r
	call	showResults


	; Ask to loop
	push	OFFSET response
	push	OFFSET yes
	push	OFFSET no
	push	OFFSET error
	push	OFFSET prompt_2
	call	doAnother

	; Do another problem is user chooses
	cmp		response, 1
	je		PROB

	; End program with message
	push	OFFSET goodbye
	call	farewell


	exit	; exit to operating system
main ENDP

; Procedure introduces program and user instructions
; Receives: addresses of program_title, intro_1a, intro_1b, intro_1c, intro_1d, intro_1e
; Returns: none
; Preconditions: none
; Registers Changed: EDX in Macro
introduction PROC
	;push	EBP
	pushad
	mov		EBP, ESP

	displayString	[EBP + 56]		; title
	call	CrLf
	call	CrLf
	displayString	[EBP + 52]		; intro_1a
	call	CrLf
	displayString	[EBP + 48]		; intro_1b
	call	CrLf
	displayString	[EBP + 44]		; intro_1c
	call	CrLf
	displayString	[EBP + 40]		; intro_1d
	call	CrLf
	displayString	[EBP + 36]		; intro_1e
	call	CrLf
	call	CrLf

	;pop		EBP
	popad
	ret		24
introduction ENDP


; Procedure shows problem after generating random numbers
; Receives: OFFSETS of problem, set, choose, r and n
; Returns: none
; Preconditions: none
; Registers Changed: EAX, EBX, EDX, ESI
showProblem PROC
	;push	EBP
	pushad
	mov		EBP, ESP


	mov		ESI, [EBP + 40]			; generate random n value
	mov		EAX, HIGHN
	sub		EAX, LOWN
	inc		EAX
	call	RandomRange
	add		EAX, LOWN
	mov		[ESI], EAX

	mov		ESI, [EBP + 36]			; generate random r value
	sub		EAX, LOWR				; EAX remains from above as n is high for r
	inc		EAX
	call	RandomRange
	add		EAX, LOWR
	mov		[ESI], EAX

	displayString	[EBP + 52]		; display problem
	call	CrLf
	displayString	[EBP + 48]		; display set
	mov		EBX, [EBP + 40]			; display n
	mov		EAX, [EBX]
	call	WriteDec
	call	CrLf
	displayString	[EBP + 44]		; display choose
	mov		EBX, [EBP + 36]			; display r
	mov		EAX, [EBX]
	call	WriteDec
	call	CrLf

	;pop		EBP
	popad
	ret		20
showProblem ENDP


; Procedure gets data from user and validates it
; Receives: address of answerD, answerS, prompt_1, error
; Returns: none
; Preconditions: none
; Registers Changed: EAX, EBX, ECX, EDX
getData PROC
	;push	EBP
	pushad
	mov		EBP, ESP
	jmp		T1

	
E1:											; Display error if number invalid
	displayString [EBP + 44]
	call	CrLf
T1:											
	mov		EAX, [EBP + 48]					; Reset user answer
	mov		EBX, 0
	mov		[EAX], EBX						
	displayString [EBP + 40]				; Get number as string from user
	mov		EDX, [EBP + 36]
	mov		ECX, MAXLENGTH
	call	ReadString
											
											; Validate input
	mov		ESI, [EBP + 36]					; user input
	mov		EBX, 10							; multiplier used to convert
	mov		ECX, 0							; accumulate string as int
	cld
RE1:

	
	lodsb									; load next byte to check
	cmp		al, 0							; check if null terminator
	je		COMP

	push	EAX								; save current string value
	
	mov		EAX, ECX						; More to convert means
	mul		EBX								; mult current num by 10
	mov		ECX, EAX						
	
	pop		EAX								; restore string value

	cmp		al, 48							; check if < 0
	jb		E1
	cmp		al, 57							; check if > 9
	ja		E1
	sub		al, 48							; get integer
	movsx	EDX, ax
	add		ECX, EDX						; add to total

	jmp		RE1
											
COMP:										; string to int complete
	mov		EAX, [EBP + 48]
	mov		[EAX], ECX						; store answer

	call	CrLf
	;pop		EBP
	popad
	ret		16
getData ENDP




; Procedure calculates combinations for n and r
; Receives: values to compute, address to store in
; Returns: none
; Preconditions: none
; Registers Changed: EAX, EBX, ECX
combinations PROC
	;push	EBP
	pushad
	mov		EBP, ESP

											; reset _fact variables for repeat use
	mov		EBX, 1
	mov		EAX, [EBP + 56]
	mov		[EAX], EBX
	mov		EAX, [EBP + 52]
	mov		[EAX], EBX
	mov		EAX, [EBP + 48]
	mov		[EAX], EBX
	mov		EAX, [EBP + 36]
	mov		EBX, 0							; reset results
	mov		[EAX], EBX

											; get factorial of n
	push	[EBP + 40]
	push	[EBP + 56]
	call	factorial
											; get factorial of r
	push	[EBP + 44]
	push	[EBP + 52]
	call	factorial
											; get factorial of n - r
	mov		EAX, [EBP + 40]
	sub		EAX, [EBP + 44]
	cmp		EAX, 0
	je		NOCALC							; if n - r = 0, do not calulate factorial
											; leave nr_fact as 1, cannot divide by 0 later
	push	EAX
	push	[EBP + 48]
	call	factorial
				
NoCALC:							
											; calculate combinations, n! / r!(n-r)!
	mov		EBX, [EBP + 52]
	mov		EAX, [EBX]						; r! in EAX
	mov		ECX, [EBP + 48]
	mov		EBX, [ECX]						; (n - r)! in EBX
	mul		EBX
	mov		ECX, [EBP + 36]
	mov		[ECX], EAX						; r!(n-r)! in result
	mov		EBX, [EBP + 56]
	mov		EAX, [EBX]						; n! in EAX
	mov		ECX, [EBP + 36]
	mov		EBX, [ECX]						; r!(n-r)! in EBX
	div		EBX
	mov		EBX, [EBP + 36]
	mov		[EBX], EAX						; n! / (r!(n-r)!) in result


	;pop		EBP
	popad
	ret		24
combinations ENDP



; Procedure calculates factorial of a number stores in address passed on stack
; Receives: value to compute, address to store in
; Returns: none
; Preconditions: storage address must contain 1 when passed
; Registers Changed: EAX, EBX, ECX
factorial PROC
	;push	EBP
	pushad
	mov		EBP, ESP

	mov		ECX, [EBP + 36]			; address to store result
	mov		EAX, [ECX]				; value in result
	mov		EBX, [EBP + 40]			; num to factorialize
	mul		EBX
	mov		[ECX], EAX				; put result back in address
	cmp		EBX, 1					; base case
	jbe		finish

recursive:
	dec		EBX						; decrement number by 1
	push	EBX						; push n
	push	ECX						; push storage address
	call	factorial

finish:

	;pop		EBP
	popad
	ret		8
factorial ENDP



; Procedure show results of combinatoric numbers
; Receives: address of corrert, incorrect, report 1, 2 and 3, value of n, r, result, answer
; Returns: none
; Preconditions: none
; Registers Changed: EAX, EDX in macro
showResults PROC
	;push	EBP
	pushad
	mov		EBP, ESP

	displayString [EBP + 52]		; Output problem answers
	mov		EAX, [EBP + 56]
	call	WriteDec
	displayString [EBP + 48]
	mov		EAX, [EBP + 36]
	call	WriteDec
	displayString [EBP + 44]
	mov		EAX, [EBP + 40]
	call	WriteDec

									; compare user answer with actual result
	mov		EAX, [EBP + 68]
	cmp		EAX, [EBP + 56]
	je		WIN
	call	CrLf
	call	WriteDec
	displayString [EBP + 60]
	jmp		U1
									; display congrats or more practice message
WIN:
	call	CrLf
	call	WriteDec
	displayString [EBP + 64]

U1:
	call	CrLf
	call	CrLf
	;pop		EBP
	popad
	ret		36
showResults ENDP

; Procedure that asks if repeat required
; Receives: address of yes, no, response, error, prompt_2
; Returns: none
; Preconditions: none
; Registers Changed: EAX, EBX, EDX
doAnother PROC
	;push	EBP
	pushad
	mov		EBP, ESP
	jmp		Ask

Wrong:										; Invalid response, repeat
	call	CrLf
	displayString [EBP + 40]

Ask:
	displayString [EBP + 36]					; Ask to repeat
	call	ReadChar
	mov		EDX, [EBP + 48]					; Perform comparisons to yes and no
	cmp		AL, [EDX]
	je		Y1
	mov		EDX, [EBP + 44]
	cmp		AL, [EDX]
	je		N1
	jmp		Wrong							; Ask again if not 'y' or 'n'
Y1:
	mov		EAX, [EBP + 52]					; Assign true to response
	mov		EBX, 1
	mov		[EAX], EBX
	jmp		GOT
N1:											; Assign false to response
	mov		EAX, [EBP + 52]
	mov		EBX, 0
	mov		[EAX], EBX

GOT:
	call	CrLf
	call	CrLf
	;pop		EBP
	popad
	ret		20
doAnother ENDP


; Procedure displays goodbye message
; Receives: address of goodbye
; Returns: none
; Preconditions: none
; Registers Changed: EDX in macro
farewell PROC
	;push	EBP
	pushad
	mov		EBP, ESP

	displayString	[EBP + 36]
	
	call	CrLf
	;pop		EBP
	popad
	ret		4
farewell ENDP


END main

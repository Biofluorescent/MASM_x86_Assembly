TITLE Composite Number     (Project04.asm)

; Author: Tanner Quesenberry
; Description: This program prompts the user to enter the number of composite numbers they would like to be displayed up to 400. User input out of range will be denied
;			   and new input then requested. The program then calculates and displays the composites 10 per line to the user up to the requested amount. A goodbye message is then output.
; References: Assembly Language 7th Edition (class textbook)
;			  demo3.asm (class example of basic procedures)
;			  http://stackoverflow.com/questions/2255960/masm-division-overflow (for problem with integer overflow during division)
;			  https://www.quora.com/Write-a-simple-algorithm-to-check-whether-the-given-number-is-prime-or-not (general method for determining if number is prime)

INCLUDE Irvine32.inc

UPPER EQU <400>						; Highest acceptable user input
TERMS EQU <10>						; Int to compare counter to

.data

userNumber			DWORD		?																	; number of user requested composites
isPrime				DWORD		1																	; use in isComposite PROC
limit				DWORD		?																	; use in isComposite PROC
currentNum			DWORD		4																	; Increment testing for composites, 4 is first composite
divisor				DWORD		2																	; Increment to test for composites
counter				DWORD		0																	; To compare to in calling CrLf in loop every 10 terms
program_title		BYTE		"      Composite Numbers", 0
programmer_name		BYTE		"Programmed by Tanner Quesenberry", 0
intro_1a			BYTE		"This program calculates and displays composite numbers.", 0
intro_1b			BYTE		"Please enter the number of composite numbers to display.", 0
intro_1c			BYTE		"You may request up to 400 numbers to display.", 0
prompt_1			BYTE		"Numbers to display [1 ... 400] : ", 0
error_message		BYTE		"Out of range. Enter again.", 0
spaces				BYTE		"    ", 0
goodbye				BYTE		"Thanks your playing. Come back soon. Farewell!", 0

.code
main PROC

	call	 introduction					; Introduce program
	call	 getUserData					; Get User data	/ validate subprocedure
	call	 showComposites					; Show Composite numbers / isComposite subprocedure
	call	 farewell						; Farewell message

	exit	; exit to operating system
main ENDP



; Procedure introduces program and user instructions
; Receives: none
; Returns: none
; Preconditions: none
; Registers Changed: EDX
introduction PROC
	mov		EDX, OFFSET program_title
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET programmer_name
	call	WriteString
	call	CrLf
	call	CrLf
	mov		EDX, OFFSET intro_1a			; User instructions
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET intro_1b
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET intro_1c
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introduction ENDP


; Procedure gets user data and calls validate procedure
; Receives: none
; Returns: user input for global variable userNumber
; Preconditions: none
; Registers Changed: EAX, EBX, EDX
getUserData PROC
R1:
	mov		EDX, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		userNumber, EAX
	call	validate
	cmp		EBX, 1							; Loop if invalid input
	je		R1
	ret
getUserData ENDP


; Verfies user data within limits
; Receives: none
; Returns: EBX = 1 and output error message if input out of range
; Preconditions: none
; Registers Changed: EAX, EBX, EDX
validate PROC
	mov		EBX, 0							; Reset EBX
	mov		EAX, userNumber
	cmp		EAX, UPPER						; if input < upper
	jle		L1								; jump to next test
	mov		EDX, OFFSET error_message		; Else: Display error
	call	WriteString
	call	CrLf
	mov		EBX, 1							; Set EBX = 1
	jmp		L3
L1:
	cmp		EAX, 1							; if input >= 1
	jge		L3								; jump to end of proc
	mov		EDX, OFFSET error_message		; Else: Display error
	call	WriteString
	call	CrLf
	mov		EBX, 1							; set EBX = 1
L3:
	ret
validate ENDP


; Outputs n composite numbers
; Receives: none
; Returns: output of composite numbers for n user terms
; Preconditions: none
; Registers Changed: EAX, ECX, EDX
showComposites PROC
	mov		ECX, userNumber					; set loop counter
	mov		EDX, OFFSET spaces
	jmp		C1

PRIME:										; If not composite, increment and test again
	inc		currentNum

C1:
	call	isComposite
	mov		EAX, isPrime
	cmp		EAX, 0							; If 0 then composite
	jne		PRIME							; else skip display of number
	mov		EAX, currentNum
	call	WriteDec						; Display number and spaces
	call	WriteString
	inc		currentNum						; Increment to next number to evaluate
	inc		counter							; Increment terms output
	mov		EAX, counter
	cmp		EAX, TERMS						; Output new line every 10 terms
	jb		unequal
	call	CrLf
	sub		EAX, TERMS
	mov		counter, EAX
unequal:
	loop	C1

	ret
showComposites ENDP

; Determines if number is composite
; Receives: none
; Returns: isPrime set to 1 or 0 based on currentNum
; Preconditions: none
; Registers Changed: EAX, EBX, EDX
isComposite PROC USES EAX EBX EDX
; save registers?

	mov		EAX, 1							; set prime to true
	mov		isPrime, EAX

	mov		EAX, 2							; reset divisor
	mov		divisor, EAX

	mov		EAX, currentNum					; determine limit = num / 2 + 1
	mov		EBX, 2
	sub		EDX, EDX						; zero extend edx
	div		EBX
	inc		EAX
	mov		limit, EAX


											; divide num by 2 to limit
D1:
	sub		EDX, EDX						; reset EDX to 0
	mov		EAX, currentNum					; Divide number by divisor
	div		divisor
	cmp		EDX, 0							; if remainder == 0, then composite
	je		D2
	inc		divisor							; increment divisor
	mov		EAX, divisor
	cmp		EAX, limit						; test new divisor against limit
	jae		D3								; end testing if divisor >= limit
	jmp		D1								; else repeat division with new divisor

											
D2:											; num is composite
	mov		EAX, 0
	mov		isPrime, EAX


D3:											; jump to D3 means number is not composite, (aka prime)
	ret
isComposite ENDP


; Outputs goodbye message
; Receives: none
; Returns: none
; Preconditions: none
; Registers Changed: EDX
farewell PROC
	call	CrLf
	mov		EDX, OFFSET goodbye
	call	WriteString
	call	CrLf
	ret
farewell ENDP

END main

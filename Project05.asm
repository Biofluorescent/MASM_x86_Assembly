TITLE Random Integer Sorting     (Project05.asm)

; Author: Tanner Quesenberry
; Description: This program uses indriect addressing and parameter passing to fill an array with
;			   random numbers from 100 to 999 for the user requested amount of numbers from 10 to 200.
;				The array is then displayed, sorted, and displayed again along with the median of the list.
; References: Assembly Language (Class textbook)
;			  Some code borrowed from Lectures 18 to 20 as allowed


INCLUDE Irvine32.inc

; CONSTANTS

MIN			EQU		<10>
MAX			EQU		<200>
LO			EQU		<100>
HI			EQU		<999>

; Local variables for sorting/median

K_local			EQU		DWORD	PTR		[EBP - 4]
I_local			EQU		DWORD	PTR		[EBP - 8]
J_local			EQU		DWORD	PTR		[EBP - 12]
Limit_local		EQU		DWORD	PTR		[EBP - 16]

.data

userRequest			DWORD		?
list				DWORD		200 DUP(?)
program_title		BYTE	"Random Integer Sorting             By Tanner Quesenberry", 0
intro_1a			BYTE	"This program will generate random integers from 100 to 999.", 0
intro_1b			BYTE	"It then displays the list, sorts it, displays the medium integer", 0
intro_1c			BYTE	"and then displays the sorted list in descending order.", 0
prompt				BYTE	"How many integers would you like generated? (10 to 200): ", 0
error				BYTE	"Invalid integer input. Try again.", 0
median				BYTE	"The median integer is ", 0
unsorted			BYTE	"The unsorted random integers are:", 0
sorted				BYTE	"The sorted randon integers are:", 0
spaces				BYTE	"    ", 0


.code
main PROC

	; Seed random number generator
	call	Randomize					
	
	; Introduce the program
	push	OFFSET program_title
	push	OFFSET intro_1a
	push	OFFSET intro_1b
	push	OFFSET intro_1c
	call	introduction

	; Get user data
	push	OFFSET error
	push	OFFSET prompt
	push	OFFSET userRequest
	call	getData

	; Fill the array with random integers
	push	OFFSET list
	push	userRequest
	call	fillArray

	; Display unsorted list
	push	OFFSET spaces
	push	OFFSET unsorted
	push	OFFSET list
	push	userRequest
	call	displayList

	; Sort the list
	push	OFFSET list
	push	userRequest
	call	sortList


	; Display the median
	push	OFFSET median
	push	OFFSET list
	push	userRequest
	call	displayMedian

	; Display the sorted list
	push	OFFSET spaces
	push	OFFSET sorted
	push	OFFSET list
	push	userRequest
	call	displayList

	exit	; exit to operating system
main ENDP

; Procedure introduces program and user instructions
; Receives: addresses of program_title, intro_1a, intro_1b, intro_1c
; Returns: none
; Preconditions: none
; Registers Changed: EDX
introduction PROC
	push	EBP
	mov		EBP, ESP
	mov		EDX, [EBP + 20]				; program_title
	call	WriteString
	call	CrLf
	call	CrLf
	mov		EDX, [EBP + 16]				; User instructions, intro_1a
	call	WriteString
	call	CrLf
	mov		EDX, [EBP + 12]				; intro_1b
	call	WriteString
	call	CrLf
	mov		EDX, [EBP + 8]				; intro_1c
	call	WriteString
	call	CrLf
	call	CrLf
	pop		EBP
	ret		16
introduction ENDP


; Gets data from the user and validates it
; Receives: addresses of error, prompt, userRequest
; Returns: none
; Preconditions: none
; Registers Changed: EAX, EBX, EDX
getData PROC
	push	EBP
	mov		EBP, ESP
	jmp		Do
R1:
	mov		EDX, [EBP + 16]				; Error message
	call	WriteString
	call	CrLf
Do:
	mov		EDX, [EBP + 12]				; prompt message
	call	WriteString
	call	ReadInt
	cmp		EAX, MIN					; If input < 10
	jb		R1
	cmp		EAX, MAX					; If input > 200
	ja		R1
	mov		EBX, [EBP + 8]				; userRequest address
	mov		[EBX], EAX
	pop		EBP
	ret		12
getData ENDP



; Fills the array with the user specified number of random integers
; Receives: address of list, userRequest value
; Returns: none
; Preconditions: none
; Registers Changed: EAX, ECX, ESI
fillArray PROC
	push	EBP
	mov		EBP, ESP
	mov		ESI, [EBP + 12]				; list address into esi
	mov		ECX, [EBP + 8]				; intialize loop counter
L1:
	mov		EAX, HI						; Generate random integer from 100 to 999
	sub		EAX, LO
	inc		EAX
	call	RandomRange
	add		EAX, LO
	mov		[ESI], EAX					; store integer in list element
	add		ESI, 4						; increment to next list element
	loop	L1

	pop		EBP
	ret		8
fillArray ENDP


; Sorts list using selection sort
; Receives: address of list, userRequest value
; Returns: none
; Preconditions: none
; Registers Changed: EAX, EBX, ECX, EDX, ESI
sortList PROC
	push	EBP
	mov		EBP, ESP
	sub		ESP, 16						; create locals
	mov		K_local, 0					; K starting value
	mov		EAX, [EBP + 8]
	mov		Limit_local, EAX
	dec		Limit_local					; limit for k = userRequest - 1

OL:										; start outer loop
	mov		EAX, K_local
	cmp		EAX, Limit_local				
	je		finish						; when k = request - 1, outer loop ends
	mov		I_local, EAX				; i = k
	
	mov		J_local, EAX				; Set inner loop
	inc		J_local						; j = k + 1

IL:										; Start inner loop
	mov		EBX, J_local
	cmp		EBX, [EBP + 8]				; j = request ends inner loop
	je		ILEND
	mov		ESI, [EBP + 12]				; Array start address

	mov		EAX, 4
	mul		J_local								
	mov		EBX, EAX					; Array element j offset addition
	mov		EAX, 4
	mul		I_local
	mov		ECX, EAX					; Array element i offset addition
	
	mov		EAX, [ESI + EBX]			; array[j]
	mov		EDX, [ESI + ECX]			; array[i]
	cmp		EAX, EDX					; cmp array[j] array[i]
	jbe		SMALLER
	mov		EAX, J_local				; set i = j  if j > i
	mov		I_local, EAX

SMALLER:
	inc		J_local
	jmp		IL

ILEND:
	mov		EAX, 4
	mul		K_local								
	mov		EBX, EAX					; Array element k offset addition
	mov		EAX, 4
	mul		I_local
	mov		ECX, EAX					; Array element i offset addition

	mov		ESI, [EBP + 12]				; list start address
	add		ESI, EBX					; array[k] offset
	push	ESI
	mov		ESI, [EBP + 12]				; list start address
	add		ESI, ECX					; array[i] offset
	push	ESI
			
	call	exchange					; exchange array[k], array[i]
	inc		K_local
	jmp		OL

finish:

	mov		ESP, EBP					; remove locals from stack
	pop		EBP
	ret		8
sortList ENDP

; Exhcange elements of list 
; Receives: addresses of list[i], list[j]
; Returns: none
; Preconditions: none
; Registers Changed: EAX, ESI
exchange PROC
	pushad
	mov		EBP, ESP
	mov		ESI, [EBP + 36]				; address of 1st element
	mov		EAX, [ESI]					; list[i] in EAX
	mov		ESI, [EBP + 40]				; second element address
	XCHG	EAX, [ESI]					; swap EAX, list[j]
	mov		ESI, [EBP + 36]				; address of 1st element
	mov		[ESI], EAX					; list[i] has list[j] value
	popad
	ret		8
exchange ENDP

; Displays the contents of the list, 10 elements per line
; Receives: address of list, string title, spaces, userRequest value
; Returns: none
; Preconditions: none
; Registers Changed: EAX, EBX, ECX, EDX, ESI
displayList PROC
	push	EBP
	mov		EBP, ESP
	mov		ESI, [EBP + 12]				; list address into esi
	mov		ECX, [EBP + 8]				; intialize loop counter
	mov		EDX, [EBP + 16]				; Display title
	mov		EBX, 0						; Use EBX to count element output
	call	CrLf
	call	WriteString
	mov		EDX, [EBP + 20]				; spaces
	call	CrLf

L2:
	mov		EAX, [ESI]					; Display list element
	call	WriteDec
	call	WriteString					; Output spaces between integers
	add		ESI, 4						; Increment to next element
	inc		EBX
	cmp		EBX, 10						; If 10 elements output
	jb		unequal
	call	CrLf						; Output new line
	mov		EBX, 0

unequal:
	loop	L2
	call	CrLf

	pop		EBP
	ret		12
displayList ENDP


; Displays the median of the list
; Receives: address of list and median string, userRequest value
; Returns: none
; Preconditions: none
; Registers Changed: EAX, EBX, EDX, ESI
displayMedian PROC
	push	EBP
	mov		EBP, ESP
	sub		ESP, 8

	mov		ESI, [EBP + 12]				; list starting address
	mov		EAX, [EBP + 8]				; userRequest value
	mov		EBX, 2
	div		EBX							; div userRequest by 2
	cmp		EDX, 1						; if remainder = 1,then median = quotient + 1
	jne		EvenList					; else jump to even list calcluation
	mov		EBX, 4
	mul		EBX							; get list element offset for median
	mov		EAX, [ESI + EAX]			; get median element
	jmp		NoRound


EvenList:								; Middle 2 elements below
	mov		K_local, EAX				; quotient in K_local
	sub		EAX, 1						; quotient - 1 in EAX
	mov		EBX, 4
	mul		EBX
	mov		I_local, EAX				; q - 1 element OFFSET
	mov		EAX, K_local
	mov		EBX, 4
	mul		EBX							; q element OFFSET in EAX
	mov		EAX, [ESI + EAX]			; calculate median
	mov		EDX, I_local
	mov		EDX, [ESI + EDX]
	add		EAX, EDX
	mov		EBX, 2
	mov		EDX, 0						; reset EDX to 0
	div		EBX							; median in EAX

	cmp		EDX, 0
	je		NoRound						; Round up if necessary
	inc		EAX

NoRound:
	mov		EDX, [EBP + 16]
	call	CrLf
	call	WriteString					; display median
	call	WriteDec
	call	CrLf

	mov		ESP, EBP
	pop		EBP
	ret		12
displayMedian ENDP

END main

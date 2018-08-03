TITLE Integer Accumulator     (Project03.asm)

; Author: Tanner Quesenberry
; Description: This program will introduce the program, the author, and instructions. The user
;			   is prompted repeatedly for numbers in the range of -1 to -100 to accummulate together.
;              The user quits by entering a positive number. The program then outputs the total valid
;              numbers entered, the sum of those numbers and the rounded average.
; References: Assembly Language 7th Edition (Class textbook)

INCLUDE Irvine32.inc

LOWER EQU <-100>					; Lowest acceptable user input

.data

userName		BYTE	33 DUP(0)	; String to be entered by user
counter			DWORD	0			; Track total numbers entered
accumulator		SDWORD	0			; Store running total of user numbers
average			SDWORD	?			; Store user average
remainder		SDWORD	?			; Store remainder of IDIV
to_positive		SDWORD	-1			; Turn negative number positive, used in rounding logic
line_number		DWORD	1			; For EC
program_title	BYTE	"     Integer Accumulator", 0
programmer_name	BYTE	"Programmed by Tanner Quesenberry", 0
prompt_1		BYTE	"Please enter your name: ", 0
greeting		BYTE	"Welcome to this great program, ", 0
intro_1a		BYTE	"You are allowed to enter integers in the range of [-100, -1].", 0
intro_1b		BYTE	"All numbers in this range will be accumulated and averaged for you.", 0
intro_1c		BYTE	"When you are done entering numbers, input a positive number to see the results.", 0
prompt_2		BYTE	": Enter a number: ", 0
error_1			BYTE	": Error, number not in range.", 0
result_1a		BYTE	"You entered ", 0
result_1b		BYTE	" valid number(s).", 0
result_2		BYTE	"The sum of your valid numbers is ", 0
result_3		BYTE	"The rounded average is ", 0
special_message	BYTE	"You didn't enter any numbers. Don't be sneaky!", 0
goodbye			BYTE	"Thanks for using the Accumulator! Come back soon, ", 0
ec_1			BYTE	"**EC: Program numbers lines during user input.", 0

.code
main PROC

; Display program title and programmer name
	mov EDX, OFFSET program_title
	call WriteString
	call CrLf
	mov EDX, OFFSET programmer_name
	call WriteString
	call CrLF
	mov EDX, OFFSET ec_1
	call WriteString
	call CrLf
	call CrLf

; Get user name and greet user
	mov EDX, OFFSET prompt_1
	call WriteString
	mov EDX, OFFSET userName
	mov ECX, 32							; Allow input up to 32 characters
	call ReadString
	mov EDX, OFFSET greeting
	call WriteString
	mov EDX, OFFSET userName
	call WriteString
	call CrLf
	call CrLf

; Display instructions to user
	mov EDX, OFFSET intro_1a
	call WriteString
	call CrLf
	mov EDX, OFFSET intro_1b
	call WriteString
	call CrLf
	mov EDX, OFFSET intro_1c
	call WriteString
	call CrLf
	jmp L1

; Repeatedly prompt user for number in range of -100 to -1 (inclusive)
; Validate, count, and accumulate these numbers.
L3:
	mov EAX, line_number
	call WriteDec
	inc line_number
	mov EDX, OFFSET error_1			; Output error if number not in range
	call WriteString
	call CrLf
L1:
	mov EAX, line_number
	call WriteDec
	inc line_number
	mov EDX, OFFSET prompt_2
	call WriteString
	call ReadInt
	cmp EAX, LOWER					; If input < LOWER
	jl L3							; Repeat loop
	test EAX, EAX					; If input positive (SF = 0)
	jns L2							; End loop (Jump if not signed)
	inc counter						; Else: +1 to total numbers entered
	add accumulator, EAX			; Add input to user total
	jmp L1							; Repeat
L2:
	cmp counter, 0					; If no valid numbers entered
	jle special						; Jump to special message

; Calculate rounded integer average of negative numbers
	mov EAX, accumulator			
	cdq								; Sign extend EAX into EDX
	mov EBX, counter
	idiv EBX						; Quotient in EAX, remainder in EDX
	mov average, EAX
	mov remainder, EDX				; Get remainder and make positive
	mov EAX, remainder
	mul to_positive
	mov remainder, EAX
	mov EAX, counter				; Determine round up or down
	sub EAX, remainder				; If counter - remainder < remainder, 
	cmp EAX, remainder				; Round down i.e. -1.67 goes to -2
	jge results						; Skip decrement to round up
	dec average						; Decrement average to round down

; Display results
results:
	call CrLf
	mov EDX, OFFSET result_1a		; Number of valid negative numbers entered
	call WriteString
	mov EAX, counter
	mov EDX, OFFSET result_1b
	call WriteDec
	call WriteString
	call CrLf
	mov EDX, OFFSET result_2		; Sum of valid negative numbers
	call WriteString
	mov EAX, accumulator
	call WriteInt
	call CrLf
	mov EDX, OFFSET result_3		; Rounded Average
	call WriteString
	mov EAX, average
	call WriteInt
	call CrLf
	jmp farewell

special:							; Special message if no valid numbers are entered
	call CrLf
	mov EDX, OFFSET special_message
	call WriteString
	call CrLf

farewell:							; Goodbye message
	mov EDX, OFFSET goodbye
	call WriteString
	mov EDX, OFFSET userName
	call WriteString
	call CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main

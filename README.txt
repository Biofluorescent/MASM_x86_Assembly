Program #1
Objectives: 
1.Introduction to MASM assembly language 
2.Defining variables (integer and string) 
3.Using library procedures for I/O 
4.Integer arithmetic 

Description:      
Write and test a MASM program to perform the following tasks: 
1.Display your name and program title on the output screen. 
2.Display instructions for the user. 
3.Prompt the user to enter two numbers. 
4.Calculate the sum, difference, product, (integer) quotient and remainder of the numbers. 
5.Display a terminating message.


Program #2
Objectives:
1)Getting string input
2)Designing and implementing a  counted loop
3)Designing and implementing a post-test loop
4)Keeping track of a previous value
5)Implementing data validation

Problem Definition:
Write a program to calculate Fibonacci numbers.
•Display the program title and programmer’s name.  Then get the user’s name, and greet the user.
•Prompt the user to enter the number of Fibonacci terms to be displayed.  Advise the user to enter an integer in the range [1 .. 46]. 
•Get and validate the user input (n)  .   
•Calculate and display all of the Fibonacci numbers up to and including the nth term.  The results should be displayed 5 terms per line with at least 5 spaces between terms.
•Display a parting message that includes the user’s name, and terminate the program.


Program #3
Objectives: more practice with
1.Implementing data validation 
2.Implementing anaccumulator
3.Integer arithmetic
4.Defining variables (integer and string)
5.Using library procedures for I/O
6.Implementing control structures (decision, loop, procedure)

Description: 
Write and test a MASM program to perform the following tasks:
1.Display the program title and programmer’s name.
2.Get the user’s name, and greet the user.
3.Display instructions for the user.
4.Repeatedly prompt the user to enter a number.  Validate the user input to be in [-100, -1] (inclusive).  Count and accumulate the valid user numbers until a non-negative number is entered.  (The non-negative number is discarded.)
5.Calculate the (rounded integer) average of the negative numbers. 
6.Display:
	i.the number of negative numbers entered  (Note: if no negative numbers were entered, display a special message and skip to iv.)  
	ii.the sum of negative numbers entered
	iii.the average, rounded to the nearest integer (e.g. -20.5 rounds to -20)
	iv.a parting message (with the user’s name)


Program #4
Objectives:
1)Designing and implementing  procedures
2)Designing and implementing loops
3)Writing nested loops
4)Understanding data validation 

Problem Definition:
Write a program to calculate composite numbers.  
First, the user is instructed to enter the number of composites to be displayed, and is prompted to enter an integer in the range [1 .. 400].  
The user enters a number, n, and the program verifies that 1 = n= 400.  
If n is out of range, the user is re-prompted until s/he enters a value in the specified range.  
The program then calculates and displays all of the composite numbers up to and including the nth composite.  
The results should be displayed 10 composites per line with at least 3 spaces between the numbers. 


Program #5
Objectives: 
1.using indirect addressing
2.passing parameters
3.generating “random” numbers
4.working with arrays

Description: 
Write and test a MASM program to perform the following tasks:
1.Introduce the program.
2.Get a user request in the range [min = 10 .. max = 200].
3.Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elements of an array. 
4.Display the list of integers before sorting, 10 numbers per line.
5.Sort the list in descending order (i.e., largest first). 
6.Calculate and display the median value, rounded to the nearest integer. 
7.Display the sorted list, 10 numbers per line. 


Program #6
Objectives:
1)Designing, implementing, and callinglow-level I/O procedures
2)Implementing recursion
	a.parameter passing on the system stack
	b.maintaining activation records (stack frames)

Problem Definition:
A system is required for statistics students to use for drill and practice in combinatorics.  
In particular, the system will ask the student to calculate the number of combinations of r items taken from a set of n items (i.e., nCr ).  
The system generates random problems with n in [3 .. 12] and r in [1 .. n]  .  
The student enters his/her answer, and the system reports the correct answer and an evaluation of the student’s answer.  
The system repeats until the student chooses to quit.
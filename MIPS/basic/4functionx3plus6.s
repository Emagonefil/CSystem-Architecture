		
		.data		
		.text

main:
		
		li $v0, 5               #Read in an interger
		syscall
		
		
		move $a0, $v0
		jal CUBE                #call cube subrountine
		
		
		addi $t0, $v1, 6        #compute x^3+6 = v1 + 6  and print
		li $v0, 1               #print the result
		move $a0, $t0
		syscall
		
		li $v0, 10               #exit the program
		syscall
		
		
		
		#subrountine to compute the cube of its argument
CUBE:
		mul $s1, $a0, $a0       #using a0 to pass the parameters, using s1 register to store 
		mul $s1, $s1, $a0
		move $v1, $s1           #using v1 to store the return value v1 = x^3
		jr $ra          
		

                  .data
string1:		.asciiz	"Print this.\n"		# declaration for string variable, 
						# .asciiz directive makes string null terminated

	    	    .text
main:	
        li	$v0, 4			# load appropriate system call code into register $v0;
						# code for printing string is 4
　　　　　　　　　　　　　　　　　　　　　　　　　　　　  
		la	$a0, string1		# load address of string to be printed into $a0
　　　　　　　　　　　　　　　　　　　　　　　　　　　　
		syscall				# call operating system to perform print operation

        li $v0, 10
        syscall

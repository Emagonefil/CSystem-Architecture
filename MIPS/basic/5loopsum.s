# Simple MIPS code that reads in n numbers, adds them, and prints the answer


                .data
                .align 2
                
input:          .asciiz "\nHow many numbers?>"
input2:         .asciiz"\nEnter a number>"
cr:             .asciiz"\n"
err:            .asciiz"Error - n must be at least 2 - quitting\n"
DONE:           .asciiz"\nDone. \n"

                .text
                .globl main
main:
#Get number of numbers to add
                li $v0, 4           #system call code 4 for print string
                la $a0, input       #argument string as input
                syscall
                li $v0, 5           #system call code 5 to read int input
                syscall
                
                move $s1, $v0       #add number to current s1
                addi $t0, $s1, -2   #n mst be at least 2
                bltz $t0, INPUTERR  #call error handler
                
#loop1 executes n (in s1)times
                li $t0, 0           #set loop counter to 0
                li $s0, 0           #initialise s0 to hold the sum
LOOP1:
                sub $t1, $t0, $s1   #loop condition
                bgez $t1, PRINTERS
                li $v0, 4
                la $a0, input2
                syscall
                li $v0, 5
                syscall
                add $s0, $s0, $v0
                addi $t0, $t0, 1
                j LOOP1
                
PRINTERS:
                li $v0, 1
                move $a0, $s0
                syscall
                li $v0, 4
                la $a0, cr
                syscall
                
EXIT:
                li $v0, 10
                syscall
                
INPUTTERR:
                li $v0, 4
                la $a0, err
                syscall
                j EXIT
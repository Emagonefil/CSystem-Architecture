#the complexcity is O(2^n)
.data                               #a0=y
msg1:.asciiz "\nProvide an integer for the Fibonacci computation: \n"      #if (y==0) return 0;
msg2:.asciiz "\nThe Fibonacci numbers are:"
msg3:.asciiz " :"
msg4:.asciiz "\n"

.text                               #if (y==1) return 1;
.globl main                         #return( fib(y-1)+fib(y-2) );
main:
    
li $v0,4
la $a0,msg1
syscall                             #print msg1
li $v0,5
syscall                             #read an int n
add $t8,$v0,$zero                   #move n from $v0 to $t8 t8 = n

li $t9,4                            # $t9 = constant 4
# allocate heap space for int array:    
li $v0,9                            # syscall code 9: allocate heap space
mul $a0,$t8,$t9                     # calculate the amount of heap space a0 = t8 * t9    a0 = n * 4
syscall
move $s3,$v0                        # $s3: base address of a int array

li $v0,4
la $a0,msg2
syscall                             #print msg2




move $t2,$zero                      #t7 index
move $t3, $t2                       #t3 couter -->copy of t2 index
memo:
 
move $a0, $t3
jal fib
add $t2, $t2, $t2               # double the index
add $t2, $t2, $t2               # double the index again (now 4x)
add $t1, $t2, $s3               # combine the two components of the address
sw $v0, 0($t1)                  # store the value into the array cell

li $v0,4
la $a0,msg4
syscall                             #print msg4

li $v0,1
add $a0,$t3,$zero                   #print index
syscall

li $v0,4
la $a0,msg3
syscall                             #print msg3

li $v0,1                            #print fibo vale
lw $t4, 0($t1)


lw $a0, 0($t1)                      # store the value into the array cell
syscall


addi $t3, $t3, 1                    #for loop to create memo
beq $t3, $t8, Exit
j memo


Exit:
li $v0,10
syscall

fib:
addi $sp,$sp,-12 #save in stack
sw $ra,0($sp)
sw $s0,4($sp)
sw $s1,8($sp)

add $s0,$a0,$zero
addi $t1,$zero,1
beq $s0,$zero,return0
beq $s0,$t1,return1

addi $a0,$s0,-1
jal fib
add $s1,$zero,$v0                   #s1=fib(y-1)
addi $a0,$s0,-2
jal fib                             #v0=fib(n-2)

add $v0,$v0,$s1                     #v0=fib(n-2)+$s1
exitfib:

lw $ra,0($sp)                       #read registers from stack
lw $s0,4($sp)
lw $s1,8($sp)
addi $sp,$sp,12                     #bring back stack pointer
jr $ra

return1:
li $v0,1
j exitfib
return0 :    
li $v0,0
j exitfib


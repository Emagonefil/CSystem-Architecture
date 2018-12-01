# MIPS assignment BubbleSort
#
#
#
#t1 = 4N                  #s0 = N
#t0 = head pointer        #s1 = 4N
#t1 = current INTEGERS    #s2 = head of the heap
#                         #s3 = s1 + s2
# jal xxxx
# jr $ra
#



.data

msg1:	                      .asciiz	"Enter the length of list: "
intPrompt:                  .asciiz "Please enter the next element: "
msg2:                       .asciiz " "

.text

.globl main
main:

li   $v0, 4     # print_string syscall code = 4
la   $a0, msg1  # load the address of msg1
syscall

# Get input N from user and save
li   $v0, 5     # read_int syscall code = 5
syscall
move $s0,$v0    # syscall results returned in $s0; e.g. t1 = 5 = v0 (copy register move)
              # NOTE: s0 = N
# Allocate the 4N memory
li    $t0, 4
mul   $s1, $s0, $t0 # compute 4*N; s1 = s0 * 4; e.g. when input is 5, t1 = 0x14
                  # NOTE: s1 = 4N
move  $a0, $s1      # move s1 into a0 as the argument of heap allocation
li    $v0, 9        # set v0
syscall
move  $s2, $v0      # get address from v0 and store in t0
                  # NOTE: s2 = head of heap

add   $s3, $s1, $s2 # s3 = s1 + s2
                  # NOTE: s3 = end of heap

li $t7, 4           # t7 = 4
sub $s4, $s3, $t7   # s4 = s3 - 4
                  # NOTE: s4 = last item of array



# Initialize memory pointer
move  $t0, $s2      # NOTE: t0 = current heap pointer



inputArrayLoop:

# Prompt to enter next int
li   $v0, 4
la   $a0, intPrompt
syscall

# Allow user to enter an integer
li   $v0, 5
syscall
move $t1, $v0      # NOTE: t1 = current input

# Put integer into register
sw   $t1, 0($t0)   # store current int into memory
# addi $t0, $t0, 4
addi $t0, $t0, 4
bne  $t0, $s3, inputArrayLoop  # when t7 equals to s3 (end of heap), break



jal BubbleSort


# TODO: make below a function
BubbleSort:
#t0 heap  t1 = 4n
#s0 = N, s1 = 4N, s2 = head of heap, s3 = end of heap
#j = t0, i = t1, temp = t2

# Initialize [j]
move  $t0, $s2      # NOTE: t0 = current heap pointer; t0=head+4*0
outerLoop:
# for j in range(N-1):
li $t6, 0
sub $v0, $s3, $t6   # v0 = N
# li $t6, 4
# sub $v0, $s3, $t6   # v0 = N - 1
beq	$t0, $v0, exit	# if j = v0, end

# Initialize [i]
cont:

move  $t1, $s2      # NOTE: t0 = current heap pointer;  t0=head+4*0
innerLoop:


#   for i range(N-j-1):
sub $t7, $s3, $t0 #t7 = s3-t0
add $t7, $t7, $s2 #t7 = s3-t0 +s2
li  $t6, 4
sub $t7, $t7, $t6 #t7 = s3-t0+s2-4
#sub $t7, $t7, $t6 #t7 = t7 - 4


beq $t1, $t7, outerLoopEnd  # if i == N-j-1 then


lw    $t2, 0($t1)   # NOTE: t2 = a[i]
lw    $t3, 4($t1)   # NOTE: t3 = a[i+1]

#     if alist i > alist[i + 1]
bgt    $t2, $t3, swap  # if 2>  t3en
j innerLoopEnd
swap:
#       temp = alist[i]
#       aslit[i] = alist[i+1]
#       alist[i+1] = temp

# TODO: improve here
move   $t4, $t2
move   $t2, $t3
move   $t3, $t4
sw     $t2, 0($t1)      # a[i] = t2
sw     $t3, 4($t1)      # a[i+1] = t2

innerLoopEnd:

addi  $t1, $t1, 4   # i = i + 1

j innerLoop

outerLoopEnd:
addi  $t0, $t0, 4   # j = j + 1

j outerLoop

jr $ra







exit:
# Initialize memory pointer
move  $t0, $s2      # NOTE: t0 = current heap pointer
outputArrayLoop:

li		$v0, 1        # print the value at array(t0)
lw		$t1, 0($t0)   #t0, s2, head of the heap
move  $a0, $t1
syscall
addi  $t0, $t0, 4

# Print a space
li	$v0, 4         # print_string syscall code = 4
la	$a0, msg2
syscall

bne   $t0, $s3,  outputArrayLoop

end:

# exit the program
li    $v0, 10
syscall

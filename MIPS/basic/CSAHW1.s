	.data
	.align 2
k:      .word   4       # include a null character to terminate string
s:      .asciiz "bac"
n:      .word   6
L:      .asciiz "abc"
        .asciiz "bbc"
        .asciiz "cba"
        .asciiz "cde"
        .asciiz "dde"
        .asciiz "dec"
	
    .text
### ### ### ### ### ###
### MainCode Module ###
### ### ### ### ### ###
main:
    li $t9,4                # $t9 = constant 4
    
    lw $s0,k                # $s0: length of the key word
    la $s1,s                # $s1: key word
    lw $s2,n                # $s2: size of string list
    
# allocate heap space for string array:    
    li $v0,9                # syscall code 9: allocate heap space
    mul $a0,$s2,$t9         # calculate the amount of heap space
    syscall
    move $s3,$v0            # $s3: base address of a string array
# record addresses of declared strings into a string array:  
    move $t0,$s2            # $t0: counter i = n
    move $t1,$s3            # $t1: address pointer j 
    la $t2,L                # $t2: address of declared list L
READ_DATA:
    blez $t0,FIND           # if i >0, read string from L
    sw $t2,($t1)            # put the address of a string into string array.
    
    subi $t0,$t0,1
    addi $t1,$t1,4
    add $t2,$t2,$s0
    j READ_DATA
 
FIND: 
### write your code ###

# alloc heap memory for all strings
    li $v0, 9
    mul $a0, $s0, $s2
    syscall
    move $s4, $v0
    li $s5, 0       # i= 0

Copy_String_Loop:  
    # $s5 = i, $s2 = n
    bge $s5, $s2, Exit_Copy_Loop #if i >= n, then exit Loop
    sll $t0, $s5, 2                 # i*4 | $t0 = $s5 << 2
    add $t1, $s3, $t0               # $t1 = $s3 + $t0
    lw  $a0, 0($t1)                 # a0 = string address 
    mul $t0, $s5, $s0               # i*k
    add $a1, $s4, $t0               # a1 =  str1[0]
    move $a2, $s0
    jal Memory_Byte
    
    addi $s5, $s5, 1
    j Copy_String_Loop
Exit_Copy_Loop:    

#sort strings in the heap
    li $s5, 0       # i= 0
Sort_String_Loop:
    # $s5 = i, $s2 = n
    sub $t7, $s5, $s2               # $t0 = left - right
    beqz $t7, Exit_Sort_String      # return if $t7 = 0 (\0)
    mul $t0, $s5, $s0               # i*k
    add $a0, $s4, $t0               # a0 =  str2[0]
    li  $a1, 0                      # left of MergeSort  (0)
    subi $a2, $s0, 2                # right of MergeSort (k-2)
    jal MergeSort                   # call merg sort 
    addi $s5, $s5, 1
    j Sort_String_Loop
Exit_Sort_String:        

# sorts the string s 
    move $a0, $s1
    li $a1, 0
    subi $a2, $s0, 2                 # right of MergeSort (k-2)
    jal MergeSort

# checks how many sorted strings are identical to the sorted strings
    li $s5, 0 # i = 0
    li $s6, 0 # for count
 Find_Data_Loop:
    sub $t7, $s5, $s2           # $t0 = left - right
    beqz $t7, Exit_Find_Data_Loop    # return if $t7 = 0 (\0)
    mul $t0, $s5, $s0               # i*k
    add $a0, $s4, $t0               # a0 =  &heap_memory[i] (heap_memory+i*k)
    move $a1, $s1                   # a1 = s
    jal CompareString
    sub $t7, $v0, $0
    beqz $t7, Find_Next
    addi $s6, $s6, 1                # count+1
Find_Next:
    addi $s5, $s5, 1                # i++
    j Find_Data_Loop
Exit_Find_Data_Loop:  

#pint count value
    move $a0, $s6
    li $v0, 1
    syscall
#quit program
	li $v0, 10
	syscall 

#def mergesort(l):
MergeSort:
    subi $sp, $sp, 16       #save in stack
	sw $ra, 0($sp)          # ra
	sw $s0, 4($sp)          # left
	sw $s1, 8($sp)          # right
	sw $s2, 12($sp)         # mid
	
	bge $a1, $a2, FINISH_MS #if left >= right, then skip sort
	move $s0, $a1
	move $s1, $a2
		
	add $t0, $s0, $s1
	srl $s2, $t0, 1         # mid = (left + right)/2;

	# MERGE_SORT LHS of array, MergeSort(string, left, mid);
	move $a1, $s0           # left
	move $a2, $s2           # mid
	jal MergeSort

	# MERGE_SORT RHS of array, MergeSort(string, mid + 1, right);
	addi $a1, $s2, 1        # mid+1
	move  $a2, $s1          # right
	jal MergeSort

	# Merge(string, left, mid, right);
	move $a1, $s0           # left
	move $a2, $s2           # mid
	move $a3, $s1           # right
	jal Merge

FINISH_MS:	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16  
	jr $ra

Merge:
    subi $sp, $sp, 16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	#alloc stack memory
	addi $s2, $a3, 1
	sub $sp, $sp ,$s2
	move $s1, $sp
	
    #copy string
	move $s0, $a0                   # $s0 - string 
	move $t4, $a1                   #  i = left

For_Loop:
    sub $t7, $t4, $a3
    bgtz $t7, Exit_For_Loop         # if left > right exit Loop
	add $t0, $t4, $s0
	lb  $t1, 0($t0) #t1=string[i]
	add $t0, $t4, $s1
	sb  $t1, 0($t0) #buf[i] =string[i]
	addi $t4, $t4, 1
	j For_Loop
Exit_For_Loop:
    move $t4, $a1    #i = left;
	move $t5, $a1    #left_i = left;
	addi $t6, $a2, 1 #right_i = mid + 1;

Loop1: 
    # if left_i > mid exit Loop
    sub $t7, $t5, $a2
    bgtz $t7, Exit_Loop1     
    # if right_i >= right exit Loop     
    sub $t7, $t6, $a3
    bgtz $t7, Exit_Loop1  
	add $t0, $s1, $t5
	lb  $t1, 0($t0)                 # Index
	add $t0, $s1, $t6
	lb  $t2, 0($t0)                 # buf[right_i]
	add $t3, $s0, $t4               # t3 = &string[i]
    sub $t7, $t1, $t2               # $t0 = left - right
    bgez $t7, BUF                   # if buf[left_i] >= buf[right_i] , then next buf_right
	sb  $t1, 0($t3)
	addi $t5, $t5, 1                # Index++
	j Loop1_Next
BUF:
	sb  $t2, 0($t3)
	addi $t6, $t6, 1                # Index++
Loop1_Next:
	addi $t4, $t4, 1                # i++
	j Loop1
	Exit_Loop1:
	
Loop2:
	sub $t7, $t5, $a2
    bgtz $t7, Exit_Loop2            # if left_i > mid exit Loop
	add $t0, $s1, $t5
	lb  $t1, 0($t0)                 # load byte
	add $t3, $s0, $t4
	sb  $t1, 0($t3)                 # result heap
	addi $t4, $t4, 1                # i++
	addi $t5, $t5, 1                # left_i++
	j Loop2
	Exit_Loop2:
	
Loop3:
	sub $t7, $t6, $a2
    bgtz $t7, Exit_Loop3            # if right_i > right exit Loop
	add $t0, $s1, $t6
	lb $t2, 0($t0)                  # load byte
	add $t3, $s0, $t4
	sb  $t2, 0($t3)                 # result heap
	addi $t4, $t4, 1                # i++
	addi $t6, $t6, 1                # right_i++
	j Loop3
Exit_Loop3:
	add $sp, $sp ,$s2               # recover $sp 
    j FINISH_MS

# Compare two string is equal or not
# $a0 - base of heap_1,$a1 - base of heap_2,$v0 - return value, 1 means equal, return 0 not equal		
CompareString:		
        subi $sp, $sp, 4
		sw   $ra, 0($sp)
		move $t1, $a0
		move $t2, $a1
		li   $v0, 0                     # Setdefault 0
Cs_Loop:
		lb  $t3, 0($t1)                 # first byte
		lb  $t4, 0($t2)                 # first byte
		beq $t3, $0, Exit_Cs_Loop       #   heap_1 != '\0'
		beq $t4, $0, Exit_Cs_Loop       #   heap_2 != '\0'
		bne $t3, $t4, Cs_Quit           #   if t3 != t4 quit
		addi $t1, $t1, 1                #   heap_1++
		addi $t2, $t2, 1                #   heap_2++
		j Cs_Loop
Exit_Cs_Loop:		
		bne $t3, $0, Cs_Quit            # if t3 !=0 quit
		bne $t4, $0, Cs_Quit            # if t4 !=0 quit
		li $v0, 1                       # return 1
Cs_Quit:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
# copy memory by byte
Memory_Byte:
    # t1 = a0, t2 = a1 , t3 i=0
    move $t1, $a0
    move $t2, $a1
    move $t3, $0            # i = 0

Memory_Byte_Loop:
    sub $t7, $t3, $a2      
    bgez $t7, Exit          # if i >= length, then exit Loop
    lb $t0, 0($t1)
    sb $t0, 0($t2)
    addi $t3, $t3, 1        # i++
    addi $t1, $t1, 1        # a0++
    addi $t2, $t2, 1        # a1++
    j Memory_Byte_Loop      # Loop

Exit:   
    jr $ra

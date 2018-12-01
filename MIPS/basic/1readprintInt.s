        .data
        var1:    .word       23
        .text
main:

lw      $t0, var1           #load the varible1 for the tempory register

li      $v0, 5
syscall
move    $t1, $v0            #read an integer from user

li      $v0, 1              #Any interrupt command will be load immidiate int v0
move    $a0, $t1            #give a0 what number you neeed to print out
syscall 

li      $v0, 10
syscall
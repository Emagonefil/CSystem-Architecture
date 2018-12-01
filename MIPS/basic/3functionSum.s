                .data
                .text
main:
                li $a1, 3
                li $a2, 4
                li $a3, 5
                
                jal SUM
                
                li $v0, 1
                syscall
                move $a0, $v1
                
                li $v0, 10
                syscall
            
SUM:            add $t0, $a1, $a2
                add $t0, $t0, $a3
                move $v0, $t0
                jr $ra
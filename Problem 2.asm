.data
str: .asciiz "Utility"
.text

.globl main
main:
    li $t0,0		#counter starting at first letter of the word		     
    li $t1,7		#number of chars in the word
    li $s0,0            #counter of vowles
    la $a1,str

    loop:
    beq $t0,$t1,end
    lb $t2,($a1)	#loading letter[current]
    addi $a1,$a1,1	#moving pointer to next char
    addi $t0,$t0,1	

    beq $t2,'a',inc
    beq $t2,'e',inc
    beq $t2,'i',inc
    beq $t2,'o',inc
    beq $t2,'u',inc
    beq $t2,'A',inc
    beq $t2,'E',inc
    beq $t2,'I',inc
    beq $t2,'O',inc
    beq $t2,'U',inc
    j loop		#else none of vowels are found it goes back to the loop
    inc:
    addi $s0,$s0,1	#if vowel is found
    j loop

    end:

    li $v0,1
    addi $a0,$s0,0	#printing vowels' counter
    syscall


    li $v0,10
    syscall


.end main
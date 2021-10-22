.data
result: .word 3 0 1 5 10 20
newLine: .asciiz"\n"
.text
.globl main
main:
    li $t0,0				# $t0 = i
    li $t2,6				# $t2 = a 
    li $t3,0
    outerloop:
        beq $t0,$t2,end
        li $t1,0			# $t1 = j
        li $s0,0
        innerloop:
        beq $t1,$t0,cont		# j < i
	    lw $s1,result($t3)
            add $s0,$s1,$t1		
            addi $t1,$t1,1
	    sw $s0,result($t3)		#replace new result with old result in the array
            j innerloop
       cont:
       
       addi $t3,$t3,4			#moving pointer to the next integer
       addi $t0,$t0,1	
       j outerloop
    end:

    
    li $t0,0
    li $t1,6
    li $t3,0
    la $a1,result
    printloop:
        beq $t0,$t1,exit
        lw $s3,result($t3)
        add $a0,$s3,$0			#printing array's element one by one
        li $v0,1
        syscall
	addi $t3,$t3,4
        addi $t0,$t0,1
	la $a0,newLine
	li $v0,4
	syscall
        j printloop
    exit:
    
    li $v0,10
    syscall


.end main
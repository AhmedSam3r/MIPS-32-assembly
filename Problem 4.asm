.data
msgEven: .asciiz "Number is Even\n"
msgOdd:  .asciiz "Number is Odd\n"
.text
.globl main
main:
    li $a1,9

    jal isOdd			#calling function

    beq $v1,$0,even		#if return is 0 then number is even
    la $a0,msgOdd		#else return is 1 number is odd
    li $v0,4			
    syscall			#printing odd here
    li $v0,10
    syscall			#ending program if odd

    even:
    la $a0,msgEven		
    li $v0,4
    syscall			#printing even here
    li $v0,10			
    syscall			#ending program if even

    
    
    isOdd:
    addi $sp,$sp,-4
    sw $ra,($sp)

    jal isEven			#calling another function isEvenFunction()

    lw $ra,0($sp)
    addi $sp,$sp,4

    beq $v1,1,one
    li  $v1,1               	#odd return=1
    jr $ra			            
    one:                   	    #even return=0
    li $v1,0			
    jr $ra

    isEven:			
    li $t1,2
    rem $t0,$a1,$t1
    beq $t0,0,makeEvenEqOne 	#returning 0 in case of even
    li $v1,0                	# zero means false in c-program
    jr $ra
    makeEvenEqOne:
    li $v1,1             	 # one means true in c-program
    jr $ra			 




    
.end main
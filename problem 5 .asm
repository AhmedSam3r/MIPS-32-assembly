.data
#31th bit sign bit in decimal,  (1000 0000 0000 0000 0000 0000 0000 0000)base 2     
signMask: .word 2147483648
#23th:30th exponent bits in decimal ,(0111 1111 1000 0000 0000 0000 0000 0000)base 2
exponentMask: .word 2139095040
#0:22th mantissa bits in decimal    ,(0000 0000 0111 1111 1111 1111 1111 1111)base 2
mantissaMask: .word 8388607
#1.xxxxxx format of mantissa         ,(0000 0000 1000 0000 0000 0000 0000 0000)base 2
pointOneMantissa: .word 8388608
#normalizing the numbers 24th bit    ,(0000 0000 1000 0000 0000 0000 0000 0000)base 2
normalizingMask:.word 8388608

.text

.globl main
main:
    li $a0,15000.5         
    li $a1,320000.2    
    jal floating_add
    #return result of adding two floating points using ieee754
    add $a0,$0,$v0          
    li $v0,1
    syscall

    li $v0,10
    syscall


    floating_add:
    #loading masks 
    lw $t0,signMask
    lw $t1,exponentMask
    lw $t2,mantissaMask
    
    # first number X = 0100 0010 0000 1111 0000 0000 0000 0000 (binary)
    and $s1,$a0,$t0                                  #X:s1(sign register)   
    and $s2,$a0,$t1                                  #X:s2(exponent register)  
    and $s3,$a0,$t2                                  #X:s3(mantissa register)

    # second number Y = 0100 0001 1010 0100 0000 0000 0000 0000 (binary)
    and $s5,$a1,$t0                                 #Y:s5(sign register)    
    and $s6,$a1,$t1                                 #Y:s6(exponent register) 
    and $s7,$a1,$t2                                 #Y:s7(mantissa register) 
    
    #operations on both X & Y exponents,Note: exponent is biased by +127 which means zero represented by (01111111)
    addi $s2,$s2,-127
    addi $s6,$s6,-127

    #add leading 1.0 mantissa
    lw $t4,pointOneMantissa
    #operation on both X & Y mantissas 23th bit 1.xxxxx
    or $s3,$s3,$t4
    or $s7,$s7,$t4

    # assigning greater exponent
    beq $s2,$s6,continue
    bgt $s2,$s6,else
        sub $t4,$s2,$s6
        #shifting right smaller  mantissa of x with amount = to the difference between the two exponents
        srav $s7,$s7,$t4                               
        #adding smaller exponent till it becomes equals the greater exponent  
        add $s6,$s6,$t4

    else:
        #shifting right smaller mantissa of y 
        sub $t4,$s6,$s2                             
        srav $s3,$s3,$t4
        #shifting smaller exponent till it becomes equals the greater exponent  
        add $s2,$s2,$t4 
    
    continue:     
    
    #make sure that both signs equals the sign of greater mantisssa
    bge $s3,$s7,else2
       li $s5,0
        add $s5,$s1,$0             
        j out
    else2:
        li $s1,0
        add $s1,$s5,$0

    out:

    #adding the two mantissas    
    add $a2,$s3,$s7

    #normalizing the numbers 24th bit -->0000 0000 1#0#00 0000 0000 0000 0000 0000
    lw $t5,normalizingMask
    and $t5,$t5,$a2
    beq $t5,$0,doneNorm
    srl $a2,$a2,1
    #srl $t5,$t5,1
    addi $s2,$s2,1
    doneNorm:
    
    #removing the leading one
    lw $t1,mantissaMask
    and $a2,$a2,$t1

    #adding 127 to the exponent
    addi $a3,$s2,127
    lw  $t4, exponentMask
    and $a3,$a3,$t4

    #or $a0,$s1,$a2         
    or $a0,$a2,$a3
    or $a0,$a0,$s1

    #return result 
    add $v0,$a0,$0
    

    jr $ra

.end main

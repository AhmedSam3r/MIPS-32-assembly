.data
.text

.globl main
main:
    li $v0,5
    syscall 
    addi $s0,$v0,0    	#$s0 is g as an input

    li $v0,5
    syscall
    addi $s1,$v0,0    	#$s1 is h as an input

    ble $s0,$s1,else
    bgt $s0,$0,else	# if g<=h && g>0
    li $s0,0
    add $s0,$s1,$s0 	#g = h                   
    j exit

    else:
    li $s1,0  
    add $s1,$s1,$s0    	 #else  h = g             
    
    exit:
    li $v0,10
    syscall


.end main
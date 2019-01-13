#useful functions



#print a string defined in a label
.macro println(%label)
li $v0, 4
la $a0, %label
syscall 	
.end_macro

#read the input fp and put into $f0
.macro readInput()
li $v0, 6
syscall 
.end_macro

#move the fp to $f12 and print it 
.macro printInput(%input)
mov.s $f12, %input	#move content to printer register
li $v0, 2		#printer syscall2 for positive single
syscall	
.end_macro

#variables
.data
	
.text
.globl main

#main program
main:
	println(num1)
	readInput()
	
	mfc1 $t4, $f0 
	
	#beqz $t0, exit
	
	movf.s $f4, $f0
	
	println(num2)
	readInput()
	
	mfc1 $t6, $f0
	#beqz $t0, exit
	
	movf.s $f6, $f0

additionActual:

	add.s $f8, $f4, $f6
	
	println(result)
	printInput($f8)
	
	
	


additionCalc: # t4 num1, t6 num2
	
	fp1: # [ s1 | s2 | s3 ]
		sll $s3, $t4, 9#fraction of num1
		
		srl $s2, $t4,23 
		sll $s2, $s2,1 #exponent of num1
		
		srl $s1, $t4,31 #sign of num1
		
	fp2: # [ s4 | s5 | s6 ]
		sll $s6, $t6, 9#fraction of num2
		
		srl $s5, $t6,23 
		sll $s5, $s2,1 #exponent of num2
		
		srl $s4, $t6,31 #sign of num2
		
	sub $s0, $s1, $s2
	beq $s0, 0, add1 # (+ +)
	beq $s0, 1, add2 # (- +)
	beq $s0, -1, add3 # (+ -)
	
	# [ s1 | s2 | s3 ]
	# [ s4 | s5 | s6 ]
	
	add1:# pos1 + pos2
		sgt $s0, $s2, $s5
		beq $s0, 1, comp1
		beq $s0, 0, comp2
		beq $s0, -1, comp3
		
		comp1:# exp: pos1 > pos2
			sub $t1, $s2, $s5 
			div $t1, $2
			mflo $t1 #shamt
			
			#srl $s6, $s6, $t1
			move $s5, $s2
			
			add $t1, $s3, $s6
			
			#shamt(t1) #result = $v1
			addi $v1,$v1, 1
			#sll $t2, $1, $v1
			
			add $t1,$t2,$t1
			
			#slti $t2, $t1, 8388608
			
			move $t9,$t1
			
			j done
			
			
				
			
		comp2:# exp: pos1 = pos2
			sgt $s0, $s3, $s6
			beq $s0, 1, comp1
			beq $s0, 0, comp2
			beq $s0, -1, comp3
			
			calc1: # frac: pos1 > pos2 => num1 > num2
				
			calc2: # frac: pos1 ) pos2 => num1 = num2
			
			calc3: # frac: pos1 > pos2 => num1 < num2
			
		comp3:# exp: pos1 < pos2
		
		
		
		j add_done
	add2:
		j add_done
	add3:
		j add_done

add_done:
	  	
    	
	#beqz $t9, done
	srl $t9, $t9, 1

done:	

	
	println(result)
	li  $v0, 1           # service 1 is print integer
   	add $a0, $0, $t9  # load desired value into argument register $a0, using pseudo-op
    	syscall  
    	


	j exit



	
#ends the program
exit:
	li $v0,10
	syscall 






.data
num1:	.asciiz "\nEnter num1: "
num2:	.asciiz "\nEnter num2: "

result:	.asciiz "\nResult: "
raw:	.asciiz "\nRaw value : "
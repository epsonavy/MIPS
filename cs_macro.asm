# Macro----------
.macro print_str($str)
li $v0, 4   	#System call code for print_str
la $a0, $str  	#Address of the string to print
syscall 	#Print the string
.end_macro 	
	
.macro print_int($arg)
li $v0, 1	#System call code for print_int
li $a0, $arg	#Integer to print
syscall		#Print the integer
.end_macro 
	
.macro print_float($arg)
li $v0, 2	#System call code for print_float
li $a0, $arg	#Integer to print
syscall		#Print the integer
.end_macro 	
	
.macro print_double($arg)
li $v0, 3	#System call code for print_double
li $a0, $arg	#Integer to print
syscall		#Print the integer
.end_macro 

# Macro: read_int
# Usage: read_int(<reg>)	
.macro read_int($arg) 
li $v0, 5	#read integer
syscall	
move $arg $v0	#move the data to target reg
.end_macro

# Macro:  print_reg_int 
# Usage:  print_reg_int(<reg>) 	
.macro print_reg_int($arg) 
li $v0, 1	#read integer
move $a0, $arg
syscall	
.end_macro

# Argument 1: Register name
# Argument 2: Upper half word value
# Argument 3: Lower half word value
.macro lwi($reg, $ui, $li)
lui $reg, $ui
ori $reg, $reg, $li
.end_macro 

.macro exit
li $v0, 10	#exit call code
syscall		#exit from program
.end_macro

.macro push($arg)
sw $arg, 0x0($sp)
addi $sp, $sp, -4
.end_macro 

.macro pop($arg)
addi $sp, $sp, +4
lw $arg, 0x0($sp)
.end_macro

#char-------------
.macro print_char($arg)
li $v0, 11    	
move $a0, $arg	
syscall 	
.end_macro 

.macro read_char($arg)
li $v0, 12    	 	
syscall 
move $arg $v0	
.end_macro 
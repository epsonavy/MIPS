# Author : Pei Lian Liu

.macro exit
li $v0, 10	#exit call code
syscall		#exit from program
.end_macro

.macro print_str($str)
li $v0, 4   	#System call code for print_str
la $a0, $str  	#Address of the string to print
syscall 	#Print the string
.end_macro

.macro print_reg_int($arg)
li $v0, 1	#read integer
move $a0, $arg
syscall
.end_macro

.data
show_a:	.asciiz "var_a : "
sortmsg: .asciiz "After Insertion sort...\n"
comma:	.asciiz ","
endl:   .asciiz "\n"

var_a: .word 64, 25, 12, 22, 11
var_m: .word 5

.text
.globl main
main:
	print_str(show_a)
	la $s0, var_a  # Load address of var_a
	la $s1, var_m  # load address of var_m
	lw $t5, 0($s1) # $t5 = length of var_a
	lw $t0, 0($s0)
printloop:
	beqz $t5, endprint
	subi $t5, $t5, 1
	print_reg_int($t0)
	print_str(comma)
	addi $s0, $s0, 4
	lw $t0, 0($s0)
	j printloop
endprint:
	print_str(endl)

	la $a0, var_a  # Load address of var_a, $a0 = base address af the array
	la $s1, var_m  # load address of var_m
	lw $a1, 0($s1) # $a1 = size of the array
	jal  insertionSort # selectionSort(a0,a1)

report:
	print_str(sortmsg)
	print_str(show_a)
	la $s0, var_a  # Load address of var_a
	la $s1, var_m  # load address of var_m
	lw $t5, 0($s1) # $t5 = length of var_a
	lw $t0, 0($s0)
printloop2:
	beqz $t5, endprint2
	subi $t5, $t5, 1
	print_reg_int($t0)
	print_str(comma)
	addi $s0, $s0, 4
	lw $t0, 0($s0)
	j printloop2
endprint2:
	print_str(endl)
	exit

insertionSort:
	addi	$sp, $sp, -28 # save values on stack
	sw	$fp, 28($sp)
	sw	$ra, 24($sp)
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3,  8($sp)
	addi	$fp, $sp, 28

	move	$s1, $zero	# i = 0

	addi	$s1, $s1, 1	# i = 1
	subi	$s2, $a1, 1	# lenght -1

loop:
	bgt 	$s1, $s2, loop_exit # if i > length-1 -> exit loop
	move	$s3, $s1	# j = i
loop2:
	ble	$s3, $zero, loop2_exit	# if j <= 0 ->exit loop2

	subi	$s0, $s3, 1	# $s0 = j - 1
	sll	$t0, $s0, 2	# [j-1] * 4
	add	$t0, $a0, $t0	# A + [j-1] * 4

	sll	$t1, $s3, 2	# j * 4
	add	$t1, $a0, $t1	# A + j * 4

	lw	$t2, 0($t0)
	lw	$t3, 0($t1)

	ble	$t2, $t3, loop2_exit # A[j-1] <= A[j] ->exit loop2

swapbegin:
	move	$a1, $s0
	move	$a2, $s3
	jal	swap
	subi	$s3, $s3, 1	# j -= 1
	j 	loop2
loop2_exit:
	addi	$s1, $s1, 1	# i += 1
	j 	loop
loop_exit:

	lw	$fp, 28($sp)	# restore values from stack
	lw	$ra, 24($sp)
	lw	$s0, 20($sp)
	lw	$s1, 16($sp)
	lw	$s2, 12($sp)
	lw	$s3,  8($sp)
	addi	$sp, $sp, 28
	jr	$ra		# return

# swap two elements in array $a0, and
# $a1, $a2 are the different index of this array
swap:
	sll	$t1, $a1, 2	# i * 4
	add	$t1, $a0, $t1	# v + i * 4

	sll	$t2, $a2, 2	# j * 4
	add	$t2, $a0, $t2	# v + j * 4

	lw	$t0, 0($t1)	# $t0 = v[i]
	lw	$t3, 0($t2)	# $t3 = v[j]

	sw	$t3, 0($t1)	# v[i] = v[j]
	sw	$t0, 0($t2)

	jr	$ra

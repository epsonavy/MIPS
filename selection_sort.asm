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
sortmsg: .asciiz "After Selection sort...\n"
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
	jal  selectionSort # selectionSort(a0,a1)

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

selectionSort:
	addi	$sp, $sp, -28 # save values on stack
	sw	$fp, 28($sp)
	sw	$ra, 24($sp)
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3,  8($sp)
	addi	$fp, $sp, 28

	move 	$s0, $a0		# base address of the array
	move	$s1, $zero		# i = 0

	subi	$s2, $a1, 1		# lenght -1
sort_loop:
	bge 	$s1, $s2, sort_exit	# if i >= length-1 then exit loop

	move	$a0, $s0		# base address
	move	$a1, $s1		# i
	move	$a2, $s2		# length - 1

	jal	findMini
	move	$s3, $v0		# return value from findmini

	move	$a0, $s0		# array
	move	$a1, $s1		# i
	move	$a2, $s3		# mini

	jal	swap

	addi	$s1, $s1, 1		# i += 1
	j	sort_loop		# loop again

sort_exit:
	lw	$fp, 28($sp)		# restore values from stack
	lw	$ra, 24($sp)
	lw	$s0, 20($sp)
	lw	$s1, 16($sp)
	lw	$s2, 12($sp)
	lw	$s3,  8($sp)
	addi	$sp, $sp, 28
	jr	$ra


# find the minimum value
findMini:
	move	$t0, $a0		# base of the array
	move	$t1, $a1		# mini = first = i
	move	$t2, $a2		# last

	sll	$t3, $t1, 2		# first * 4
	add	$t3, $t3, $t0		# index = base array + first * 4
	lw	$t4, 0($t3)		# min = v[first]

	addi	$t5, $t1, 1		# i = 0
mini_for:
	bgt	$t5, $t2, mini_end	# if $t5 > $t2 go to mini_end

	sll	$t6, $t5, 2		# i * 4
	add	$t6, $t6, $t0		# index = base array + i * 4
	lw	$t7, 0($t6)		# v[index]

	bge	$t7, $t4, mini_if_exit	# if v[i] >= min then skip

	move	$t1, $t5		# mini = i
	move	$t4, $t7		# min = v[i]

mini_if_exit:
	addi	$t5, $t5, 1		# i += 1
	j	mini_for

mini_end:
	move 	$v0, $t1		# return mini
	jr	$ra

# swap two elements $a0 = base of the array
# $a1, $a2  two different index  from this array
swap:
	sll	$t1, $a1, 2		# i * 4
	add	$t1, $a0, $t1		# v + i * 4

	sll	$t2, $a2, 2		# j * 4
	add	$t2, $a0, $t2		# v + j * 4

	lw	$t0, 0($t1)		# v[i]
	lw	$t3, 0($t2)		# v[j]

	sw	$t3, 0($t1)		# v[i] = v[j]
	sw	$t0, 0($t2)

	jr	$ra

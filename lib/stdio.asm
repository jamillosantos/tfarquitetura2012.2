# version: 1.1.0
# label prefix: b#_

.globl printStr
.globl printInt
.globl printHex
.globl readStr

################################################################################
.macro _stdio_savestack()
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $v0, 8($sp)
.end_macro

.macro _stdio_restorestack()
	lw $a0, 4($sp)
	lw $v0, 8($sp)
	addi $sp, $sp, 8
.end_macro

################################################################################
printHex:
	# $a0 = the integer to print
	
	# prologo ----------
	addiu $sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	addu  $fp, $0, $sp
	# ------------------
	
	addi $2, $0, 34  # print integer service
	syscall

	# epilogo ----------
	addu  $sp, $0, $fp
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu $sp, $sp, 8
	# ------------------

	jr $ra

################################################################################
.macro printHex(%hex)
	_stdio_savestack

	move $a0, %hex
	li $v0, 34
	syscall

	_stdio_restorestack
.end_macro

################################################################################
printStr:
	# a0 = address of null-terminated string to print
	
	# prologo ----------
	addiu   $sp, $sp, -8
	sw	  $ra, 4($sp)
	sw	  $fp, 0($sp)
	addu	$fp, $0, $sp
	# ------------------
	
	addi $2, $0, 4  # print string service
	syscall
	
	# epilogo ----------
	addu	$sp, $0, $fp
	lw	  $ra, 4($sp)
	lw	  $fp, 0($sp)
	addiu   $sp, $sp, 8
	# ------------------

	jr $ra

################################################################################
.macro printStrAddr(%addr)
	_stdio_savestack

	move $a0, %addr
	li $v0, 4
	syscall

	_stdio_restorestack
.end_macro

################################################################################
.macro printStr(%str)
	.data
		str: .asciiz %str
	.text
		_stdio_savestack

		li $v0, 4
		la $a0, str
		syscall

		_stdio_restorestack
.end_macro

################################################################################
.macro printLn()
	_stdio_savestack

	la $a0, NL
	li $v0, 4
	syscall

	_stdio_restorestack
.end_macro


################################################################################
printInt:
	# $a0 = the integer to print
	
	# prologo ----------
	addiu $sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	addu  $fp, $0, $sp
	# ------------------
	
	addi $2, $0, 1  # print integer service
	syscall

	# epilogo ----------
	addu  $sp, $0, $fp
	lw	$ra, 4($sp)
	lw	$fp, 0($sp)
	addiu $sp, $sp, 8
	# ------------------

	jr $ra
		
################################################################################
.macro printInt(%int)
	_stdio_savestack

	move $a0, %int
	li $v0, 1
	syscall

	_stdio_restorestack
.end_macro


################################################################################
readStr:
	# $4 = address of input buffer
	# $5 = maximum number of characters to read
	
	# prologo ----------
	addiu $sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$fp, 0($sp)
	addu  $fp, $0, $sp
	# ------------------
	
	addi $2, $0, 8  # read string service
	syscall
	
	# epilogo ----------
	addu	$sp, $0, $fp
	lw	  $ra, 4($sp)
	lw	  $fp, 0($sp)
	addiu   $sp, $sp, 8
	# ------------------

	jr $ra

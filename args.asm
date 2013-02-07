
.data
	str_argumentc: .asciiz "Argument Counter: "
	str_argumentv: .asciiz "\nArguments:\n"
	str_nl: .asciiz "\n"
	str_item: .asciiz "+ "

.text

main:

args_dump:
# Dump dos argumentos
	move $t0, $a0
	move $t1, $a1

	la $a0, str_argumentc
	li $v0, 4
	syscall

	move $a0, $t0
	li $v0, 1
	syscall

	la $a0, str_argumentv
	li $v0, 4
	syscall

	move $t2, $t1
	li $t3, 0

args_dump__arg:
# {

	la $a0, str_item
	li $v0, 4
	syscall

	lw $a0, 0($t2)
	li $v0, 4
	syscall

	la $a0, str_nl
	li $v0, 4
	syscall

	addi $t3, $t3, 1
	addi $t2, $t2, 4
	bne $t3, $t0, args_dump__arg

# }

	li $a0, 0
	li $v0, 10
	syscall

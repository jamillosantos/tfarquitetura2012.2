.data
	str_teste: .asciiz "\n"

.text

main:
# {
	jal args_init

	jal args_dump

	li $a0, 0
	jal args_get

	lw $a0, 0($v0)
	jal file_load

	la $a0, str_teste
	li $v0, 4
	syscall

	# $t0: Posição do cabeçalho na memória!
	move $t0, $sp

	move $a0, $t0
	li $v0, 1
	syscall

	li $v0, 4
	# lw $a0, 0($t0)
	move $a0, $t0
	syscall
# }

	# Exiting!
	li $v0, 10
	syscall

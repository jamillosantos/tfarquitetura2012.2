.globl args_dump
.globl args_init
.globl args_get

.data
	# Quantidade de parâmetros!
	argumentc: .word 0
	# Array com os endereços dos parâmetros na pilha, espaço para 16
	argumentv: .word 0

	args_str_argumentc: .asciiz "Argument Counter: "
	args_str_argumentv: .asciiz "\nArguments:\n"
	args_str_nl: .asciiz "\n"
	args_str_item: .asciiz "+ "

.text

# Inicializa os dados na memória
args_init:
	# Salvando o argumentc na memória
	sw $a0, argumentc

	# Salvando o argumentv na memória
	sw $a1, argumentv

	jr $ra

# Dump dos argumentos
args_dump:
	# $t0: Argument counter
	lw $t0, argumentc
	# $t1: Argument values
	lw $t1, argumentv

	la $a0, args_str_argumentc
	li $v0, 4
	syscall

	move $a0, $t0
	li $v0, 1
	syscall

	# Se não houver argumentos vai direto ao fim
	beq $a0, $0, args_dump__return

	la $a0, args_str_argumentv
	li $v0, 4
	syscall

	move $t2, $t1
	li $t3, 0

# Imprime cada parâmetro!
args_dump__arg:
# {
	la $a0, args_str_item
	li $v0, 4
	syscall

	lw $a0, 0($t2)
	li $v0, 4
	syscall

	la $a0, args_str_nl
	li $v0, 4
	syscall

	addi $t3, $t3, 1
	addi $t2, $t2, 4
	bne $t3, $t0, args_dump__arg
# }

args_dump__return:
	jr $ra

# Retorna o valor (string) da lista do indice selecionado.
# 
# @param $a0 Índice do parâmetro na lista
# @return $v0 Retorna o endereço da string (com final \0) na memória
args_get:
# {
	# $t0: Número de argumentos
	lw $t0, argumentc

	# Se o argumento informado for maior que o número de argumentos dará erro
	bgt $a0, $t0, args_get__error
	# Se o argumento informado for menor que zero dará erro
	blt $a0, $0, args_get__error

	lw $t1, argumentv

	mul $t0, $a0, 4

	add $t1, $t1, $t0

	move $v0, $t1
	jr $ra

	args_get__error:
		li $v0, 0
		jr $ra
# }

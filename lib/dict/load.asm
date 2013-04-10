
.globl dict_load

.eqv	DICT_SIZE				930

.data
	data_dict:
		.space	DICT_SIZE
		.align 2

.text

dict_load:
	add $sp, $sp, -8
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	move $s1, $a0

	# malloc(DICT_SIZE)
	# move $s0, $v0				# Endereço de memória para guardar o
								# conteudo do arquivo

	la $s0, data_dict

	li $v0, 13					# serviço de abertura de arquivo
	move $a0, $s1				# $a0 vem do parametro
	li $a1, 0					# flag: 0 = leitura
	li $a2, 0					# modo -> ignorado pelo MARS
	syscall						# abre o arquivo ($v0=id do arquivo; -1=erro)
	move $s1, $v0				# Identificador do arquivo

	li $v0, 14					# Ler do arquivo
	move $a0, $s1				# Id do arquivo de onde o dado deverá ser lido
	move $a1, $s0				# Endereço, na memória, onde o dado deverá ser
								# carregando;
	li $a2, DICT_SIZE			# Máximo de caracteres para ler;
	syscall

	li $v0, 16					# Fechar o arquivo
	move $a0, $s1				# Id do arquivo
	syscall

	lw $s0, 4($sp)
	lw $s1, 0($sp)
	add $sp, $sp, 8

	jr $ra

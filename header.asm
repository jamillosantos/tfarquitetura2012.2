
.globl file_load

.data
	const_HEADER_LENGTH: .word 36

.text

# Carrega o header do arquivo na memória.
# @param $a0 Endereço da string
# @return $v0 Identificador do arquivo
# @return $v1 Endereço da memória onde os dados do cabeçalho foram alocados
file_load:
# {
	# $t0: Endereço de memória do nome do arquivo com final \0
	move $t0, $a0
	# $t1: Tamanho do cabeçalho do ELF
	lw $t1, const_HEADER_LENGTH

	# Abre arquivo
	li $v0, 13
	li $a1, 0
	li $a2, 0
	syscall

	# Verificando a abertura do arquivo
	blt $v0, $0, file_load_fileopen_fail

	# ID do arquivo em $t7
	move $t7, $v0

	# Caso o arquivo tenha sido aberto com sucesso
	sub $sp, $sp, $t1
	li $v0, 14
	move $a0, $t7
	move $a1, $sp
	move $a2, $t1
	syscall

	# Jogando o ID do arquivo em $v0 para que o retorno fique disponível
	move $v0, $t7

	jr $ra # Retorna

	# Caso a abertura do arquivo falhe!
	file_load_fileopen_fail:
		li $v0, -1
		jr $ra # Retorna
# }

header_dump:
	jr $ra
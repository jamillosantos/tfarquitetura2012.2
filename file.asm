
.globl file_load

.eqv	HEADER_LENGTH			52
.eqv	PROGRAMHEADER_LENGTH	32
.eqv	SECTION_LENGTH			52

.data

.text

# Carrega o header do arquivo na memória.
# @param $a0 Endereço da string
# @return $v0 Identificador do arquivo
file_load:
# {
	# $t0: Endereço de memória do nome do arquivo com final \0
	move $t0, $a0
	# $t1: Tamanho do cabeçalho do ELF
	li $t1, HEADER_LENGTH

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

file_seek:
# {
	# File seek operation.
# }

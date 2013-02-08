
.globl file_load
.globl header_dump

.data
	const_HEADER_LENGTH: .word 52
	str_label_type: .asciiz "\nType: "
	str_label_machine: .asciiz "\nMachine: "
	str_label_version: .asciiz "\nVersion: "
	str_label_entry: .asciiz "\nEntry: "
	str_label_phoff: .asciiz "\nPhoff: "
	str_label_shoff: .asciiz "\nShoff: "
	str_label_flags: .asciiz "\nFlags: "
	str_label_ehsize: .asciiz "\nEhsize: "
	str_label_phentsize: .asciiz "\nPhentsize: "
	str_label_phnum: .asciiz "\nPhnum: "
	str_label_shentsize: .asciiz "\nShentsize: "
	str_label_shnum: .asciiz "\nShnum: "
	str_label_shstrndx: .asciiz "\nShstrndx: "

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

# Imprime os dados do cabeçalho
# @param $a0 Endereço do início do cabeçalho na memória
# @return void
header_dump:
	move $t0, $a0

	li $v0, 4
	la $a0, str_label_type
	syscall

	lh $a0, 16($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_machine
	syscall

	lh $a0, 18($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_version
	syscall

	lw $a0, 20($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_entry
	syscall

	lw $a0, 24($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_phoff
	syscall

	lw $a0, 28($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_shoff
	syscall

	lw $a0, 32($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_flags
	syscall

	lw $a0, 36($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_ehsize
	syscall

	lh $a0, 40($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_phentsize
	syscall

	lh $a0, 42($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_phnum
	syscall

	lh $a0, 44($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_shentsize
	syscall

	lh $a0, 46($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_shnum
	syscall

	lh $a0, 48($t0)
	li $v0, 34
	syscall

	li $v0, 4
	la $a0, str_label_shstrndx
	syscall

	lh $a0, 50($t0)
	li $v0, 34
	syscall

	jr $ra
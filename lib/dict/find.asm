
.globl dict_find

# Largura da linha do dicionário
.eqv	DICT_ROW				16

# Máscara para os primeiros 6 bits da word
.eqv	DICT_FIRST6				0xFC000000
.eqv	DICT_FIRST6_SR			26

# Máscara para os últimos 6 bits da word
.eqv	DICT_LAST6				0x3F

.eqv	DICT_FIELD_OPCODE		0
.eqv	DICT_FIELD_FUNCTION		1
.eqv	DICT_FIELD_TYPE			2
.eqv	DICT_FIELD_SUBTYPE		3
.eqv	DICT_FIELD_ASC			4

.text

# Faz a busca no dicionário a partir da word carregada no registrador $a1.
# 
# @param $a0 Endereço do dicionário na memória.
# @param $a1 Conteúdo da WORD com a instrução.
# @return $v0 Endereço da memória com o endereço da função encontrada. Caso nada
#             seja encontrado o valor será zero.
dict_find:
# {

	# $t0: Endereço de memória da linha atual a ser analizada
	move $t0, $a0

	# $t7: Quantidade de linhas do dicionário
	li $t7, DICT_SIZE
	div $t7, $t7, DICT_ROW

	# $t1: Primeiros 6 bits da instrução $a1 que identificam o campo OPCODE
	li $at, DICT_FIRST6
	# and $t1, $a1, $at
	srl $t1, $a1, DICT_FIRST6_SR

	# printStr("\nOPCODE: ")
	# printHex($t1)
	# printStr(": ")
	# printInt($t1)

	bnez $t1, dict_find_last6dontcare
	li $at, 0x11
	beq $t1, $at, dict_find_last6dontcare

	# Se os últimos 6 bits importar
	dict_find_getlast6:
	# {
		# $t2: Últimos 6 bits da instrução $a1 que identificam o campo FUNCTION
		and $t2, $a1, DICT_LAST6

		j dict_find_find
	# }

	# Se os últimos 6 bits não importar
	dict_find_last6dontcare:
	# {
		# $t2: Zero para já que nestes casos o FUNCTION não importa!
		add $t2, $0, $0
	# }

	# Joga o valor de "não encontrado" em $v0
	li $v0, 0

	# Faz realmente a busca no dicionário
	dict_find_find:
	# {
		# printStr("\nFUNCTION: ")
		# printHex($t2)
		# printLn

		# $t6: Variável de indução
		li $t6, 0

		dict_find_find_begin:
		# {
			# Compara o campo OPCODE
			lb $t3, 0($t0)
			# printStr("\n")
			# printInt($t6)
			# printStr(") Comparando type ")
			# printHex($t3)
			# printStr(" com ")
			# printHex($t1)
			bne $t3, $t1, dict_find_find_notmatch

			# Compara o campo FUNCTION
			lb $t3, 1($t0)
			# printStr("\nComparando subtype ")
			# printHex($t3)
			# printStr(" com ")
			# printHex($t2)
			# printLn
			bne $t3, $t2, dict_find_find_notmatch

			move $v0, $t0
			jr $ra # Return
		# }

		dict_find_find_notmatch:
		# {
			addi $t0, $t0, DICT_ROW
			addi $t6, $t6, 1
			ble $t6, $t7, dict_find_find_begin
		# }

	# }

	jr $ra
# }

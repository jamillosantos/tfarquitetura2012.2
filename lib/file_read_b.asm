# label prefix: lblg_

file_read_b:
	# $a0: Endereco da estrutura de dados do arquivo
	# $v0: byte lido
	# $v1: 0 para erro, 1 para sucesso

	# prologo ----------
	addiu $sp, $sp, -8
	sw    $ra, 4($sp)
	sw    $fp, 0($sp)
	addu  $fp, $0, $sp
	# ------------------

	addiu $a1, $0, 1 # numero de bytes a ser lido
	jal file_read

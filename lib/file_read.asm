# label prefix: lblf_

file_read:

		# $a0: Endereco da estrutura de dados do arquivo
		# $a1: Numero de bytes a ser lido
		# $v0: leitura
		# $v1: 0 para erro, 1 para sucesso
		
		# prologo ----------
		addiu $sp, $sp, -8
		sw	$ra, 0($sp)
		sw	$fp, 4($sp)
		addu  $fp, $0, $sp
		# ------------------
		
		# ============================
		# espaco para variaveis locais
		# ============================
		
		addiu $sp, $sp, -28
		
		# ================
		# valores iniciais
		# ================
		
		sw  $a0,  -4($fp)   # endereco da estrutura de dados
		sw  $0,   -8($fp)   # endereco do inicio do codigo na estrutura de dados
		sw  $a1, -12($fp)   # numero de bytes a ser lido
		sw  $0,  -16($fp)   # posicao do cursor
		sw  $0,  -20($fp)   # EI_DATA -> ELFDATANONE / ELFDATA2LSB / ELFDATA2MSB
		sw  $0,  -24($fp)   # tamanho do arquivo
		sw  $0,  -28($fp)   # retorno
		
		# ===========================================
		# guardar endereco do codigo (inserir offset)
		# ===========================================
		
		lw	$t0, -4($fp)   # get base address 
		addiu $t0, $t0, 12   # adjust offset
		sw	$t0, -8($fp) 
				  
		# =========================
		# guardar posicao do cursor
		# =========================
		
		lw $t0, -4($fp)   # get base address 
		lw $t1,  0($t0)   # get cursor position information
		sw $t1, -16($fp)
		
		# ===============
		# guardar EI_DATA
		# ===============
		
		lw $t0,  -4($fp)	# get base address 
		lw $t1,   8($t0)	# get EI_DATA information
		sw $t1, -20($fp)
		
		# ==========================
		# guardar tamanho do arquivo
		# ==========================
		
		lw $t0,  -4($fp)	# get base address 
		lw $t1,   4($t0)	# get file size information
		sw $t1, -24($fp)
		
		# ====================================
		# testar se a informacao pode ser lida
		# (se nao passa do fim do arquivo)
		# ====================================
		
		lw $t0, -16($fp) # posicao do cursor
		lw $t1, -12($fp) # numero de bytes
		lw $t2, -24($fp) # tamanho do arquivo
		addu $t3, $t0, $t1 
		
		bleu $t3, $t2, lblf_1  # if $t3 > $t2
		# {
			add $v1, $0, $0 # erro
			j lblf_exit
		# }
lblf_1:		

		# ====================================
		# testar se a informacao pode ser lida
		# (se a codificacao eh valida
		# ====================================

		lw   $t0, -20($fp) 
		
		bnez $t0, lblf_2   # if $t0 == 0 (codificacao invalida -> erro)
		# {
			add $v1, $0, $0 # erro
			j lblf_exit
		# }
lblf_2: 
		
		# =======================
		# compor valor de retorno
		# =======================
		
		# EI_DATA = 1: LSB -> leitura normal
		# EI_DATA = 2: MSB -> leitura invertida
		
		lw $t0, -20($fp) # EI_DATA
		lw $t1, -16($fp) # posicao do cursor
		lw $t2,  -8($fp) # endereco do inicio do codigo
		lw $t3, -12($fp) # numero de bytes
		la $t4, -28($fp) # return value address
		
		addi $t5, $0, 1
			
		bne $t0, $t5, lblf_3   # if $t0 == 1
		# {
			addu $t5, $t1, $t2 # endereco de leitura do cursor
			
lblf_loop1:

			beq  $t3, $0, lblf_endSuccess	# teste do loop
			# {
				lb	$t6, 0($t5)
				sb	$t6, 0($t4)
				
				addiu $t4, $t4,  1
				addiu $t5, $t5,  1
				addiu $t3, $t3, -1	  # decrementar contador
			# }
			
			j lblf_loop1
		# } 

lblf_3:
		
		addi $t5, $0, 2
			
		bne $t0, $t5, lblf_endError  # if $t0 == 2
		# {
			addu  $t5, $t1, $t2 # endereco de leitura do cursor
			
			move  $t6, $t3	  # numero de bytes
			addiu $t6, $t6, -1  # numero de bytes - 1
			addu  $t4, $t4, $t6 # endereco do MSB  
			
lblf_loop2:

			beq  $t3, $0, lblf_endSuccess	# teste do loop
			# {
				lb	$t6, 0($t5)
				sb	$t6, 0($t4)
				
				addiu $t4, $t4, -1
				addiu $t5, $t5,  1
				addiu $t3, $t3, -1	  # decrementar contador
			# }
			
			j lblf_loop2
		# }
		
lblf_endSuccess:
		
		# ================================
		# encerra procedimento com sucesso
		# ================================
			
		# ================================
		# registrar nova posicao do cursor
		# ================================
		
		lw $t0, -16($fp) # posicao do cursor
		lw $t1, -12($fp) # numero de bytes
		
		addu $t2, $t1, $t0
		lw $t3, -4($fp)   # get base address 
		sw $t2,  0($t3)   # set new cursor position information
		
		# ==========================
		# seta os valores de retorno
		# ==========================
		
		lw   $v0, -28($fp)
		addi $v1, $0, 1 # sucesso
		j lblf_exit
		
lblf_endError:	   
		
		# =============================
		# encerra procedimento com erro
		# =============================
			
		addi $v1, $0, 0  # erro
		j lblf_exit
		 
lblf_exit:
		
		# epilogo ----------
		addu	$sp, $0, $fp
		lw	  $ra, 0($sp)
		lw	  $fp, 4($sp)
		addiu   $sp, $sp, 8
		# ------------------

		jr $ra

.macro fileReadB(%offset)
	add $at, $a1, %offset
	lb $v0, 0($at)
.end_macro

.macro fileReadH(%offset)
	add $at, $a1, %offset
	lb $v0, 0($at)
	sll $v0, $v0, 8
	lb $at, 1($at)
	or $v0, $v0, $at
.end_macro

.macro fileReadW(%offset)
	add $sp, $sp, -4
	sw $t0, 0($sp)

	add $at, $a1, %offset
	lb $v0, 0($at)
	sll $v0, $v0, 8
	lb $t0, 1($at)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0
	sll $v0, $v0, 8
	lb $t0, 2($at)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0
	sll $v0, $v0, 8
	lb $t0, 3($at)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0

	lw $t0, 0($sp)
	add $sp, $sp, 4
.end_macro

.macro fileReadWAddr(%addr)
	add $sp, $sp, -4
	sw $t0, 0($sp)

	lb $v0, 0(%addr)
	sll $v0, $v0, 8
	lb $t0, 1(%addr)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0
	sll $v0, $v0, 8
	lb $t0, 2(%addr)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0
	sll $v0, $v0, 8
	lb $t0, 3(%addr)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0

	lw $t0, 0($sp)
	add $sp, $sp, 4
.end_macro

.macro fileReadSW(%offset)
	add $sp, $sp, -4
	sw $t0, 0($sp)

	add $at, $a1, %offset
	lb $v0, 0($at)
	sll $v0, $v0, 8
	lb $t0, 1($at)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0
	sll $v0, $v0, 8
	lb $t0, 2($at)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0
	sll $v0, $v0, 8
	lb $t0, 3($at)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0

	lw $t0, 0($sp)
	add $sp, $sp, 4
.end_macro



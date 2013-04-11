
.eqv	ASM_MASK_RS			0x3E00000
.eqv	ASM_SRL_RS			21
.eqv	ASM_MASK_RT			0x1F0000
.eqv	ASM_SRL_RT			16
.eqv	ASM_MASK_R_RD		0xF800
.eqv	ASM_SRL_RD			11
.eqv	ASM_MASK_R_SA		0x7C0
.eqv	ASM_SRL_SA			6

.eqv	ASM_MASK_I_IMM		0xFFFF

.eqv	ASM_MASK_J_ADDR		0x3FFFFFF

.globl elf_dis

.data
	lbl_str_dis_tab:
		.asciiz "\t"
	lbl_str_dis_dollar:
		.asciiz "$"
	lbl_str_dis_space:
		.asciiz " "
	lbl_str_dis_comma:
		.asciiz ", "
	lbl_str_dis_open_bracket:
		.asciiz "("
	lbl_str_dis_close_bracket:
		.asciiz ")"
	lbl_str_dis_regs:
		.asciiz "$zero"
		.asciiz "$at\0\0"
		.asciiz "$v0\0\0"
		.asciiz "$v1\0\0"
		.asciiz "$a0\0\0"
		.asciiz "$a1\0\0"
		.asciiz "$a2\0\0"
		.asciiz "$a3\0\0"
		.asciiz "$t0\0\0"
		.asciiz "$t1\0\0"
		.asciiz "$t2\0\0"
		.asciiz "$t3\0\0"
		.asciiz "$t4\0\0"
		.asciiz "$t5\0\0"
		.asciiz "$t6\0\0"
		.asciiz "$t7\0\0"
		.asciiz "$s0\0\0"
		.asciiz "$s1\0\0"
		.asciiz "$s2\0\0"
		.asciiz "$s3\0\0"
		.asciiz "$s4\0\0"
		.asciiz "$s5\0\0"
		.asciiz "$s6\0\0"
		.asciiz "$s7\0\0"
		.asciiz "$t8\0\0"
		.asciiz "$t9\0\0"
		.asciiz "$k0\0\0"
		.asciiz "$k1\0\0"
		.asciiz "$gp\0\0"
		.asciiz "$sp\0\0"
		.asciiz "$fp\0\0"
		.asciiz "$ra\0\0"

.text

.macro printTab
	la $at, lbl_str_dis_tab
	printStrAddr($at)
.end_macro

.macro printComma
	la $at, lbl_str_dis_comma
	printStrAddr($at)
.end_macro

.macro printDollar
	la $at, lbl_str_dis_dollar
	printStrAddr($at)
.end_macro

.macro printSpace
	la $at, lbl_str_dis_space
	printStrAddr($at)
.end_macro

.macro printOpenBracket
	la $at, lbl_str_dis_open_bracket
	printStrAddr($at)
.end_macro

.macro printCloseBracket
	la $at, lbl_str_dis_close_bracket
	printStrAddr($at)
.end_macro

elf_print_reg:
# {
	addi $sp, $sp, -4
	sw $s0, 0($sp)

	la $s0, lbl_str_dis_regs
	mul $at, $a0, 6
	add $s0, $s0, $at
	printStrAddr($s0)

	lw $s0, 0($sp)
	addi $sp, $sp, 4

	jr $ra
# }

# Faz o disassembly de uma sequencia de instruções
# 
# @param $a0 Endereço da estrutura do arquivo
# @param $a1 Endereço do dicionário na memória
# @param $a2 Recebe o endereço de início do bloco
# @param $a3 Recebe o tamanho do bloco
# @return void
elf_dis:
# {
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)

	# Endereço do dicionário
	move $s0, $a1

    # printStr("# elf_dis: Endereço do dicionário: ")
    # printHex($a1)
    # printLn

	# $s1: Endereço da instrução que será incrementado
	move $s1, $a2
	move $s2, $a3
	# $s3: Variável que marca em que byte atual da verificação, usado para
	#      o fim do bloco
	li $s3, 0

	elf_dis_begin:
	# {
		# $s4: Instrução que será decodificada
		lw $s4, 0($s1)

		# printStr("\n# elf_dis: --------------\n#Analisando instrução: ")
		# printHex($s4)
		# printStr("\n")

		move $a0, $s0
		move $a1, $s4
		jal dict_find

		# Se a instrução foi encontrada
		bnez $v0, elf_dis_instruction_found

		# Se a instrução não foi encontrada
		printStr("\n\t# Instrução sem OPCODE/FUNCTION")
		# Vai à próxima instrução
		j elf_dis_inc

		elf_dis_instruction_found:
		# Imprime a operação!
		# $t4: Endereço do nome da comando
		addi $t4, $v0, DICT_FIELD_ASC
		printTab
		printStrAddr($t4)

		lb $t4, DICT_FIELD_TYPE($v0)

		beq $t4, 0, elf_dis_RType
		beq $t4, 1, elf_dis_IType
		beq $t4, 2, elf_dis_JType

		# Instrução com TYPE inválido
		printStr("\n\t# Instrução com TYPE inválido: ")
		printInt($t4)

		# Vai à próxima instrução
		j elf_dis_inc

		elf_dis_RType:
		# {
			# Carrega os campos RS, RT, RD, SA em $t0, $t1, $t2, $t3
			li $at, ASM_MASK_RS
			and $t0, $s4, $at
			srl $t0, $t0, ASM_SRL_RS

			li $at, ASM_MASK_RT
			and $t1, $s4, $at
			srl $t1, $t1, ASM_SRL_RT

			li $at, ASM_MASK_R_RD
			and $t2, $s4, $at
			srl $t2, $t2, ASM_SRL_RD

			li $at, ASM_MASK_R_SA
			and $t3, $s4, $at
			srl $t3, $t3, ASM_SRL_RD

			j elf_dis_checkSubType
		# }

		elf_dis_IType:
		# {
			# Carrega os campos RS, RT, IMM em $t0, $t1, $t2
			li $at, ASM_MASK_RS
			and $t0, $s4, $at
			srl $t0, $t0, ASM_SRL_RS

			li $at, ASM_MASK_RT
			and $t1, $s4, $at
			srl $t1, $t1, ASM_SRL_RT

			li $at, ASM_MASK_I_IMM
			and $t2, $s4, $at

			j elf_dis_checkSubType
		# }

		elf_dis_JType:
		# {
			# Carrega o campo ADDR em $t0
			li $at, ASM_MASK_J_ADDR
			and $t0, $s4, $at
		# }

		elf_dis_checkSubType:
		# Carrega o subtipo
		lb $t4, DICT_FIELD_SUBTYPE($v0)
		beq $t4, 0, elf_dis_subtype_0

		# Imprimi um <space>: " "
		printSpace

		# SWITCH com os subtipos!
		beq $t4, 1, elf_dis_subtype_1
		beq $t4, 2, elf_dis_subtype_2
		beq $t4, 3, elf_dis_subtype_3
		beq $t4, 4, elf_dis_subtype_4
		beq $t4, 5, elf_dis_subtype_5
		beq $t4, 6, elf_dis_subtype_6
		beq $t4, 7, elf_dis_subtype_7
		beq $t4, 8, elf_dis_subtype_8
		beq $t4, 9, elf_dis_subtype_9
		beq $t4, 10, elf_dis_subtype_10
		beq $t4, 11, elf_dis_subtype_11
		beq $t4, 12, elf_dis_subtype_12
		beq $t4, 13, elf_dis_subtype_13
		beq $t4, 14, elf_dis_subtype_14
		beq $t4, 15, elf_dis_subtype_15

		# Caso o SUBTYPE não seja encontrado: ERRO!
		printStr("\n\t# Instrução com SUBTYPE inválido: ")
		printInt($t4)

		elf_dis_subtype_0:
			j elf_dis_inc

		elf_dis_subtype_1:
		# {
			move $a0, $t0
			jal elf_print_reg
			# printDollar
			# printInt($t0)

			j elf_dis_inc
		# }

		elf_dis_subtype_2:
		# {
			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			j elf_dis_inc
		# }

		elf_dis_subtype_3:
		# {
			move $a0, $t0
			jal elf_print_reg
			# printDollar
			# printInt($t0)

			printComma
			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			j elf_dis_inc
		# }

		elf_dis_subtype_4:
		# {
			move $a0, $t2
			jal elf_print_reg
			# printDollar
			# printInt($t2)

			printComma
			move $a0, $t0
			jal elf_print_reg
			# printDollar
			# printInt($t0)

			j elf_dis_inc
		# }

		elf_dis_subtype_5:
		# {
			move $a0, $t2
			jal elf_print_reg
			# printDollar
			# printInt($t2)

			printComma
			move $a0, $t0
			jal elf_print_reg
			# printDollar
			# printInt($t0)

			printComma
			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			j elf_dis_inc
		# }

		elf_dis_subtype_6:
		# {
			move $a0, $t2
			jal elf_print_reg
			# printDollar
			# printInt($t2)
			printComma

			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			printComma
			move $a0, $t0
			jal elf_print_reg
			# printDollar
			# printInt($t0)

			j elf_dis_inc
		# }

		elf_dis_subtype_7:
		# {
			move $a0, $t2
			jal elf_print_reg
			# printDollar
			# printInt($t2)

			printComma
			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			printComma
			move $t4, $a0
			jal elf_print_reg
			# printDollar
			# printInt($t4)

			j elf_dis_inc
		# }

		elf_dis_subtype_8:
		# {
			move $a0, $t0
			jal elf_print_reg
			# printDollar
			# printInt($t0)

			printComma
			printHex($t2)

			j elf_dis_inc
		# }

		elf_dis_subtype_9:
		# {
			move $a0, $t0
			jal elf_print_reg
			# printDollar
			# printInt($t0)

			printComma
			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			printComma
			printHex($t2)

			j elf_dis_inc
		# }

		elf_dis_subtype_10:
		# {
			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			printComma
			move $a0, $t0
			jal elf_print_reg
			# printDollar
			# printInt($t0)

			printComma
			printInt($t2)

			j elf_dis_inc
		# }

		elf_dis_subtype_11:
		# {
			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			printComma
			printInt($t2)
			printOpenBracket
			move $a0, $t0
			jal elf_print_reg
			# printDollar
			# printInt($t0)
			printCloseBracket

			j elf_dis_inc
		# }

		elf_dis_subtype_12:
		# {
			printHex($t1)

			j elf_dis_inc
		# }

		elf_dis_subtype_13:
		# {
			move $a0, $t2
			jal elf_print_reg
			# printDollar
			# printInt($t2)

			printComma
			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			j elf_dis_inc
		# }

		elf_dis_subtype_14:
		# {
			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			printComma
			move $a0, $t2
			jal elf_print_reg
			# printDollar
			# printInt($t2)

			j elf_dis_inc
		# }

		elf_dis_subtype_15:
		# {
			move $a0, $t1
			jal elf_print_reg
			# printDollar
			# printInt($t1)

			printComma
			move $a0, $t2
			jal elf_print_reg
			# printDollar
			# printInt($t2)

			printComma
			move $a0, $t3
			jal elf_print_reg
			# printDollar
			# printInt($t3)
		# }

		elf_dis_inc:

		printStr("\t\t# ")
		printHex($s4)
		printLn

		addi $s3, $s3, 4
		addi $s1, $s1, 4

		blt $s3, $s2, elf_dis_begin
	# }

	elf_dis_end:

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24

	jr $ra
# }

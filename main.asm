# version: 1.1.0
# label prefix: lbla_

.include "./lib/heap.asm"
.include "./lib/stdio.asm"
.include "./lib/comparaStr.asm"
.include "./lib/file_load.asm"
.include "./lib/file_addr.asm"
.include "./lib/file_read.asm"
.include "./lib/file_read_b.asm"
.include "./lib/file_read_h.asm"
.include "./lib/file_read_w.asm"
.include "./lib/file_read_sw.asm"
.include "./lib/file_seek.asm"
.include "./lib/file_seek_abs.asm"

.include "./lib/dict/load.asm"
.include "./lib/dict/find.asm"

.include "./lib/inicializar.asm"

.include "./lib/elf/header.asm"
.include "./lib/elf/section_header.asm"
.include "./lib/elf/program_header.asm"
.include "./lib/elf/dis.asm"

.text
.globl main

main:
	jal inicializar
	
	# =======================
	# termina em caso de erro
	# =======================
	
	beq $v0, $0, lbla_erro
	
	# ======================================
	# termina em caso de apenas um parâmetro
	# que não seja -h ou -v
	# ======================================
	
	addi $t0, $0, 1
	beq $v0, $t0, lbla_end
	
	# =========================================================
	# salva o endereco da string com o caminho do arquivo fonte
	# =========================================================
	
	lw $s0, 0($a1)
	
	# ===========================================================
	# salva o endereco da string com o caminho do arquivo destino
	# ===========================================================
	
	lw $s1, 4($a1)
	
	# =======================
	# carrega o arquivo fonte
	# =======================
	
	move $a0, $s0
	jal file_load
	
	# =============
	# testa retorno
	# =============
	
	beq $v0, $0, lbla_erro
	
	# ======================================
	# salva o endereco da estrutura de dados
	# ======================================

	move $s0, $v0

#===============================================================================
	
.data

NL:	  # New line
	.asciiz "\n" 
	
lbla_msg1:
	.asciiz "erro\n"		 

data_inicializar_dict_filename:
    .asciiz "dictionary/dictionary"

.text

	# Guarda o início do dicionário
	# -----------------------------
    la $a0, data_inicializar_dict_filename
    jal dict_load
    # $s2: Endereço do dicionário na memória
    move $s2, $v0
    printStr("# Endereço do dicionário: ")
    printHex($s2)
    printLn

	# Guarda o início do endereço do arquivo!
	# ---------------------------------------
	move $a0, $s0
	jal file_addr
	move $s1, $v0
	printHex($s0)

    printStr("\n---------")

	# Dumping header
	printLn
	printStr("Header")
	printLn
	printStr("======")

	move $a0, $s0
	move $a1, $s1
	# jal header_dump

	printStr("\nEndereço do dic: ")
	printHex($s2)
	printStr("\n\n")

	move $a0, $s0
	move $a1, $s2
	addi $a2, $s1, 4252
	li $a3, 3080
	jal elf_dis

	j lbla_end


	# Dump da seção que guarda a stringtable das seções
	# -------------------------------------------------
#	move $a0, $s0
#	jal header_get_shstrndx

#	move $a0, $s0
#	move $a1, $v0
#	jal section_header_addr

#	move $a0, $s0
#	move $a1, $v0
#	jal sh_get_off

	# jal section_header_dump

	# Dumping Section header
	# ----------------------
main_section_header:
	# j main_program_header # Apenas desabilitando a impressão da section header

	move $a0, $s0
	move $a1, $s1

	jal header_get_shoff
	move $s2, $v0

	jal header_get_shentsize
	move $s3, $v0

	jal header_get_shnum
	move $s4, $v0

	printStr("\n\nSection headers (")
	printInt($s4)
	printStr(")\n===============")

	add $a1, $s1, $s2
	li $s7, 1
lbla_sh_loop:
# {
	printStr("\n\n")
	printInt($s7)
	printStr(" : ")
	printHex($s7)
	printStr(")")

	move $a0, $s0
	jal section_header_dump
	addi $s7, $s7, 1
	add $a1, $a1, $s3

	sgt $t0, $s7, $s4
	beqz $t0, lbla_sh_loop
# }

main_program_header:
	# Dumping program header
	# ---------------------

	move $a0, $s0
	move $a1, $s1

	jal header_get_phoff
	move $s2, $v0

	jal header_get_phentsize
	move $s3, $v0

	jal header_get_phnum
	move $s4, $v0

	# Dumping program header
	printStr("\n\nProgram headers (")
	printInt($s4)
	printStr(")\n===============")

	add $a1, $s1, $s2
	li $s7, 1
lbla_ph_loop:
# {
	printStr("\n\n")
	printInt($s7)
	printStr(" : ")
	printHex($s7)
	printStr(")")

	move $a0, $s0
	jal program_header_dump
	addi $s7, $s7, 1
	add $a1, $a1, $s3

	sgt $t0, $s7, $s4
	beqz $t0, lbla_ph_loop
# }

lbla_end:
	# a0 = return value code
	li $a0, 0
	addi $2, $0, 17	 # terminate with value service
	syscall			 # system call

lbla_erro:
	la   $a0, lbla_msg1
	jal  printStr
	addi $a0, $0, 1
	j lbla_end


.globl section_header_dump

################################################################################
# Section header consts
################################################################################

# Sections headers reserved
.eqv	SHN_UNDEF				0
.eqv	SHN_LORESERVE			0xff00
.eqv	SHN_LOPROC				0xff00
.eqv	SHN_HIPROC				0xff1f
.eqv	SHN_ABS					0xfff1
.eqv	SHN_COMMON				0xfff2
.eqv	SHN_HIRESERVE			0xffff

# Section header e_type field values (Figure 1-10, pg 16)
.eqv	SHT_NULL				0
.eqv	SHT_PROGBITS			1
.eqv	SHT_SYMTAB				2
.eqv	SHT_STRTAB				3
.eqv	SHT_RELA				4
.eqv	SHT_HASH				5
.eqv	SHT_DYNAMIC				6
.eqv	SHT_NOTE				7
.eqv	SHT_NOBITS				8
.eqv	SHT_REL					9
.eqv	SHT_SHLIB				10
.eqv	SHT_DYNSYM				11
.eqv	SHT_LOPROC				0x70000000
.eqv	SHT_HIPROC				0x7fffffff
.eqv	SHT_LOUSER				0x80000000
.eqv	SHT_HIUSER				0xffffffff

# Section header e_flags values
.eqv	SHF_WRITE				0x1
.eqv	SHF_ALLOC				0x2
.eqv	SHF_EXECINSTR			0x4				# IMPORTANT!!! Section that have machine instructions!!!!
.eqv	SHF_MASKPROC			0xf0000000

.data
	str_sht_type_first:
		.ascii	"NULL\0\0\0\0\0\0\0\0"
		.ascii	"PROGBITS\0\0\0\0"
		.ascii	"SYMTAB\0\0\0\0\0\0"
		.ascii	"STRTAB\0\0\0\0\0\0"
		.ascii	"RELA\0\0\0\0\0\0\0\0"
		.ascii	"HASH\0\0\0\0\0\0\0\0"
		.ascii	"DYNAMIC\0\0\0\0\0"
		.ascii	"NOTE\0\0\0\0\0\0\0\0"
		.ascii	"NOBITS\0\0\0\0\0\0"
		.ascii	"REL\0\0\0\0\0\0\0\0\0"
		.ascii	"SHLIB\0\0\0\0\0\0\0"
		.ascii	"DYNSYM\0\0\0\0\0\0"
		.ascii	"????\0\0\0\0\0\0\0\0"
		.ascii	"????\0\0\0\0\0\0\0\0"
		.ascii	"INIT_ARRAY\0\0"
		.ascii	"FINI_ARRAY\0\0"

.text

.macro _sh_savestack
	add $sp, $sp, -12
	sw $ra, 4($sp)
	sw $s0, 8($sp)
	sw $s1, 12($sp)
.end_macro

.macro _sh_restorestack
	lw $ra, 4($sp)
	lw $s0, 8($sp)
	lw $s1, 12($sp)
	add $sp, $sp, 12
.end_macro

################################################################################
# 
# Section header
# --------------
# 
# @param	$a0		Enderçeo do início da estrutura de dados na memória.
# @param	$a1		Endereço do cabeçalho da seção na memória.
# 
# @returns	$v0 	Retorna o valor do campo, se for inteiro. Caso seja string,
#					retornará o endereço de memória do primeiro byte dela.
# 
################################################################################


# Retorna o endereço de memória da seção $a1 passada
section_header_addr:
	_sh_savestack

	move $s0, $a0
	move $s1, $a1

	jal header_get_shentsize
	mul $s1, $v0, $s1

	jal header_get_shoff
	add $v0, $v0, $s1

	add $v0, $v0, $a0
	add $v0, $v0, 12

	_sh_restorestack
	jr $ra

################################################################################

sh_get_name:
# {
	_sh_savestack

	fileReadW(0)

	_sh_restorestack
	jr $ra
# }

sh_get_name_str:
# {
	_sh_savestack

	jal sh_get_name
	move $s0, $v0

	jal header_get_shstrndx
	move $a1, $v0	# Entrada para a próxima função ser chamada

	jal section_header_addr
	move $a1, $v0	# Mantém o endereço da seção com os nomes, entrada para a
					# próxima função a ser chamada

	jal sh_get_off
	add $v0, $v0, $s0	# Soma do índice do nome da sessão

	add $v0, $v0, $a0
	add $v0, $v0, 12

	_sh_restorestack
	jr $ra
# }

sh_get_type:
# {
	_sh_savestack

	fileReadW(4)

	_sh_restorestack
	jr $ra
# }

sh_get_type_str:
# {
	_sh_savestack

	jal sh_get_type

	and $v0, $v0, 0x0f

	mul $v0, $v0, 12
	la $t0, str_sht_type_first

	add $v0, $v0, $t0

	_sh_restorestack
	jr $ra
# }

sh_get_flags:
# {
	_sh_savestack

	fileReadW(8)

	_sh_restorestack
	jr $ra
# }

sh_get_addr:
# {elf
	_sh_savestack

	fileReadW(12)

	_sh_restorestack
	jr $ra
# }

sh_get_off:
# {
	_sh_savestack

	fileReadW(16)

	_sh_restorestack
	jr $ra
# }

sh_get_size:
# {
	_sh_savestack

	fileReadW(20)

	_sh_restorestack
	jr $ra
# }

sh_get_link:
# {
	_sh_savestack

	fileReadW(24)

	_sh_restorestack
	jr $ra
# }

sh_get_info:
# {
	_sh_savestack

	fileReadW(28)

	_sh_restorestack
	jr $ra
# }

sh_get_addralign:
# {
	_sh_savestack

	fileReadW(32)

	_sh_restorestack
	jr $ra
# }

sh_get_entsize:
# {
	_sh_savestack

	fileReadW(36)

	_sh_restorestack
	jr $ra
# }

section_header_dump:
# {
	addi $sp, $sp, -8
	sw $ra, 8($sp)
	sw $s0, 4($sp)

	# Salva parâmetro para uso posterior
	move $s0, $a1

	printStr("\nName: ")
	move $a1, $s0
	jal sh_get_name
	printHex($v0)

	printStr(" \"")
	move $a1, $s0
	jal sh_get_name_str
	printStrAddr($v0)
	printStr("\"")

	##

	printStr("\nType: ")
	move $a1, $s0
	jal sh_get_type
	printHex($v0)

	move $a1, $s0
	jal sh_get_type_str
	printStr(" (")
	printStrAddr($v0)
	printStr(")")

	##

	printStr("\nFlags: ")
	move $a1, $s0
	jal sh_get_flags
	printHex($v0)

	##

	printStr("\nAddr: ")
	move $a1, $s0
	jal sh_get_addr
	printHex($v0)

	##

	printStr("\nOff: ")
	move $a1, $s0
	jal sh_get_off
	printHex($v0)

	printStr(" (")
	printInt($v0)
	printStr(")")

	##

	printStr("\nSize: ")
	move $a1, $s0
	jal sh_get_size
	printHex($v0)

	##

	printStr("\nLink: ")
	move $a1, $s0
	jal sh_get_link
	printHex($v0)

	##

	printStr("\nInfo: ")
	move $a1, $s0
	jal sh_get_info
	printHex($v0)

	##

	printStr("\nAddr align: ")
	move $a1, $s0
	jal sh_get_addralign
	printHex($v0)

	##

	printStr("\nEnt size: ")
	move $a1, $s0
	jal sh_get_entsize
	printHex($v0)

	##

	lw $ra, 8($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8

	jr $ra
# }
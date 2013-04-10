
.include "macros.asm"

.globl header_dump

# {
#	.globl header_get_type
#	.globl header_get_machine
#	.globl header_get_version
#	.globl header_get_entry
# }


################################################################################
# ELF Header
################################################################################

# Machine
.eqv	EM_NONE					0
.eqv	EM_M32					1
.eqv	EM_SPARC				2
.eqv	EM_386					3
.eqv	EM_68K					4
.eqv	EM_88K					5
.eqv	EM_860					7
.eqv	EM_MIPS					8

# 
.eqv	EI_MAG0					0
.eqv	EI_MAG1					1
.eqv	EI_MAG2					2
.eqv	EI_MAG3					3
.eqv	EI_CLASS				4
.eqv	EI_DATA					5
.eqv	EI_VERSION				6
.eqv	EI_PAD					7
.eqv	EI_NIDENT				16

# e_ident class field
.eqv	ELFCLASSNONE			0
.eqv	ELFCLASS32				1	# 32 bits
.eqv	ELFCLASS64				2	# 64 buts

# e_ident data field
.eqv	ELFDATANONE				0
.eqv	ELFDATA2LSB				1	# Least Significant Byte (0x01020304 colocado no ordem 0x04030201)
.eqv	ELFDATA2MSB				2	# Most Significant Byte (0x01020304 colocado no ordem 0x01020304)


################################################################################
# Symbol table consts
################################################################################

# Symbol binding
.eqv	STB_LOCAL				0
.eqv	STB_GLOBAL				1
.eqv	STB_WEAK				2
.eqv	STB_LOPROC				13
.eqv	STB_HIPROC				15

# Symbol Types
.eqv	STT_NOTYPE				0
.eqv	STT_OBJECT				1
.eqv	STT_FUNC				2
.eqv	STT_SECTION				3
.eqv	STT_FILE				4
.eqv	STT_LOPROC				13
.eqv	STT_HIPROC				1

################################################################################
# Relocation
################################################################################

# Relocation types (Figure 1-22, pg. 29/1-23)
.eqv	R_386_NONE				0
.eqv	R_386_32				1
.eqv	R_386_PC32				2
.eqv	R_386_GOT32				3
.eqv	R_386_PLT32				4
.eqv	R_386_COPY				5
.eqv	R_386_GLOB_DAT			6
.eqv	R_386_JMP_SLOT			7
.eqv	R_386_RELATIVE			8
.eqv	R_386_GOTOFF			9
.eqv	R_386_GOTPC				10

################################################################################
# Data
################################################################################
.data
	str_ident_class_first:
		.ascii "None\0\0\0\0"
		.ascii "32bits\0\0"
		.ascii "64bits\0\0"

	str_ident_data_first:
		.ascii "None\0\0\0\0"
		.ascii "LSB\0\0\0\0\0"
		.ascii "MSB\0\0\0\0\0"

	str_em_FIRST:
		.ascii "None\0\0\0\0\0\0\0\0\0\0\0\0"
		.ascii "AT&T WE 32100\0\0\0"
		.ascii "SPARC\0\0\0\0\0\0\0\0\0\0\0"
		.ascii "Intel 80386\0\0\0\0\0"
		.ascii "Motorola 68000\0\0"
		.ascii "Motorola 88000\0\0"
		# Índice 6 não está presente na documentação
		.ascii "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
		.ascii "Intel 80860\0\0\0\0\0"
		.ascii "MIPS RS3000\0\0\0\0\0"

	str_type_first:
		.ascii "No file type\0\0\0\0\0\0\0\0"
		.ascii "Relocatable file\0\0\0\0"
		.ascii "Executable file\0\0\0\0\0"
		.ascii "Shared object file\0\0"
		.ascii "Core file\0\0\0\0\0\0\0\0\0\0\0"


.text

.macro _header_savestack
	add $sp, $sp, -4
	sw $ra, 4($sp)

	add $a1, $a0, 12
.end_macro

.macro _header_restorestack
	lw $ra, 4($sp)
	add $sp, $sp, 4
.end_macro

header_get_ident_mag:
# {
	_header_savestack

	move $v0, $a0

	_header_restorestack
	jr $ra
# }

header_get_ident_class:
# {
	_header_savestack

	fileReadB(4)

	_header_restorestack
	jr $ra
# }

header_get_ident_class_str:
# {
	_header_savestack

	jal header_get_ident_class

	mul $v0, $v0, 8
	la $t0, str_ident_class_first
	add $v0, $v0, $t0

	_header_restorestack
	jr $ra
# }

header_get_ident_data:
# {
	_header_savestack

	fileReadB(5)

	_header_restorestack
	jr $ra
# }

header_get_ident_data_str:
# {
	_header_savestack

	jal header_get_ident_data

	mul $v0, $v0, 8
	la $t0, str_ident_data_first
	add $v0, $v0, $t0

	_header_restorestack
	jr $ra
# }

header_get_ident_version:
# {
	_header_savestack

	fileReadB(6)

	_header_restorestack
	jr $ra
# }

header_get_type:
# {
	_header_savestack

	fileReadH(EI_NIDENT)

	_header_restorestack
	jr $ra
# }

header_get_type_str:
# {
	_header_savestack

	jal header_get_type

	mul $v0, $v0, 20
	la $t0, str_type_first
	add $v0, $v0, $t0


	_header_restorestack
	jr $ra
# }

header_get_machine:
# {
	_header_savestack

	fileReadH(18)

	_header_restorestack
	jr $ra
# }

header_get_machine_str:
# {
	_header_savestack

	jal header_get_machine

	mul $t0, $v0, 16

	la $t1, str_em_FIRST
	add $v0, $t1, $t0

	_header_restorestack
	jr $ra
# }

header_get_version:
# {
	_header_savestack

	fileReadW(20)

	_header_restorestack
	jr $ra
# }

header_get_entry:
# {
	_header_savestack

	fileReadW(24)

	_header_restorestack
	jr $ra
# }

header_get_phoff:
# {
	_header_savestack

	fileReadW(28)

	_header_restorestack
	jr $ra
# }

header_get_shoff:
# {
	_header_savestack

	fileReadW(32)

	_header_restorestack
	jr $ra
# }

header_get_flags:
# {
	_header_savestack

	fileReadW(36)

	_header_restorestack
	jr $ra
# }

header_get_ehsize:
# {
	_header_savestack

	fileReadH(40)

	_header_restorestack
	jr $ra
# }

header_get_phentsize:
# {
	_header_savestack

	fileReadH(42)

	_header_restorestack
	jr $ra
# }

header_get_phnum:
# {
	_header_savestack

	fileReadH(44)

	_header_restorestack
	jr $ra
# }

header_get_shentsize:
# {
	_header_savestack

	fileReadH(46)

	_header_restorestack
	jr $ra
# }

header_get_shnum:
# {
	_header_savestack

	fileReadH(48)

	_header_restorestack
	jr $ra
# }

header_get_shstrndx:
# {
	_header_savestack

	fileReadH(50)

	_header_restorestack
	jr $ra
# }

################################################################################
# 
# Symbol table entry
# ------------------
# 
# @param	$a0		Deverá conter o endereço de memória do início do symbol
# 					table.
# 
# @returns	$v0 	Retorna o valor do campo, se for inteiro. Caso seja string,
#					retornará o endereço de memória do primeiro byte dela.
# 
################################################################################

st_get_name:
# {
	_header_savestack

	fileReadW(0)

	_header_restorestack
# }

st_get_value:
# {
	_header_savestack

	fileReadW(4)

	_header_restorestack
	jr $ra
# }

st_get_size:
# {
	_header_savestack

	fileReadW(8)

	_header_restorestack
	jr $ra
# }

st_get_info:
# {
	_header_savestack

	fileReadB(12)

	_header_restorestack
	jr $ra
# }

st_get_other:
# {
	_header_savestack

	fileReadB(13)

	_header_restorestack
	jr $ra
# }

st_get_shndx:
# {
	_header_savestack

	fileReadH(14)

	_header_restorestack
	jr $ra
# }

################################################################################
# Relocation
################################################################################

rel_get_offset:
# {
	_header_savestack

	fileReadW(0)

	_header_restorestack
# }

rel_get_info:
# {
	_header_savestack

	fileReadW(4)

	_header_restorestack
	jr $ra
# }

rela_get_addend:
# {
	_header_savestack

	fileReadSW(8)

	_header_restorestack
	jr $ra
# }


# Imprime os dados do cabeçalho
# @param $a0 Endereço do início do cabeçalho na memória
# @return void
header_dump:
	addi $sp, $sp, -8
	sw $ra, 8($sp)
	sw $s0, 4($sp)

	# Salva parâmetro para uso posterior
	move $s0, $a0

	##

	printStr("\nELF Identification: \n - Class: ")
	move $a0, $s0
	jal header_get_ident_class

	printHex($v0)

	move $a0, $s0
	jal header_get_ident_class_str
	printStr(" (")
	printStrAddr($v0)
	printStr(")")

	#

	printStr("\n - Data encoding: ")
	move $a0, $s0
	jal header_get_ident_data

	printHex($v0)

	move $a0, $s0
	jal header_get_ident_data_str
	printStr(" (")
	printStrAddr($v0)
	printStr(")")

	#

	printStr("\n - Version: ")
	move $a0, $s0
	jal header_get_ident_version
	printInt($v0)

	##

	printStr("\nType: ")
	move $a0, $s0
	jal header_get_type
	printHex($v0)

	move $a0, $s0
	jal header_get_type_str
	printStr(" (")
	printStrAddr($v0)
	printStr(")")

	##

	printStr("\nMachine: ")
	move $a0, $s0
	jal header_get_machine
	printHex($v0)

	printStr(" (")
	move $a0, $s0
	jal header_get_machine_str
	printStrAddr($v0)
	printStr(")")

	##

	printStr("\nVersion: ")
	move $a0, $s0
	jal header_get_version
	printHex($v0)

	##

	printStr("\nEntry: ")
	move $a0, $s0
	jal header_get_entry
	printHex($v0)

	##

	printStr("\nPhoffset: ")
	move $a0, $s0
	jal header_get_phoff
	printHex($v0)
	printStr(" (")
	printInt($v0)
	printStr(")")

	##

	printStr("\nShoffset: ")
	move $a0, $s0
	jal header_get_shoff
	printHex($v0)

	##

	printStr("\nFlags: ")
	move $a0, $s0
	jal header_get_flags
	printHex($v0)

	##

	printStr("\nEhsize: ")
	move $a0, $s0
	jal header_get_ehsize
	printHex($v0)

	##

	printStr("\nPhentsize: ")
	move $a0, $s0
	jal header_get_phentsize
	printHex($v0)

	##

	printStr("\nPhnum: ")
	move $a0, $s0
	jal header_get_phnum
	printHex($v0)

	##

	printStr("\nShentsize: ")
	move $a0, $s0
	jal header_get_shentsize
	printHex($v0)

	##

	printStr("\nShnum: ")
	move $a0, $s0
	jal header_get_shnum
	printHex($v0)

	##

	printStr("\nShstrndx: ")
	move $a0, $s0
	jal header_get_shstrndx
	printHex($v0)

	lw $ra, 8($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8

	jr $ra
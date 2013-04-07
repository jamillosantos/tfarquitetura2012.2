
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

# Tamanho máximo das strings contendo as strings do nome das máquinas
.eqv	STR_EM_LENGTH			16

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
.eqv	ELFCLASSNONE			0	# Invalid
.eqv	ELFCLASS32				1	# 32 bits
.eqv	ELFCLASS64				2	# 64 buts

# e_ident data field
.eqv	ELFDATANONE				0	# Invalid
.eqv	ELFDATA2LSB				1	# Least Significant Byte (0x01020304 colocado no ordem 0x04030201)
.eqv	ELFDATA2MSB				2	# Most Significant Byte (0x01020304 colocado no ordem 0x01020304)

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

#################################################################################
# Program header
################################################################################

# Segment Types
.eqv	PT_NULL					0
.eqv	PT_LOAD					1
.eqv	PT_DYNAMIC				2
.eqv	PT_INTERP				3
.eqv	PT_NOTE					4
.eqv	PT_SHLIB				5
.eqv	PT_PHDR					6
.eqv	PT_LOPROC				0x70000000
.eqv	PT_HIPROC				0x7fffffff

################################################################################
# Data
################################################################################
.data
	str_em_FIRST:
	str_em_none:	.asciiz "None"
	.align 4
	str_em_m32:		.asciiz "AT&T WE 32100"
	.align 4
	str_em_sparc:	.asciiz "SPARC"
	.align 4
	str_em_386:		.asciiz "Intel 80386"
	.align 4
	str_em_68k:		.asciiz "Motorola 68000"
	.align 4
	str_em_88k:		.asciiz "Motorola 88000"
	.align 4
	str_em_860:		.asciiz "Intel 80860"
	.align 4
	str_em_mips:	.asciiz "MIPS RS3000"
	.align 4

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

.macro _header_savestack
	add $sp, $sp, -4
	sw $ra, 4($sp)
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

	addi $a0, $a0, 4
	jal endian_read_b

	_header_restorestack
	jr $ra
# }

header_get_ident_data:
# {
	_header_savestack

	addi $a0, $a0, 5
	jal endian_read_b

	_header_restorestack
	jr $ra
# }

header_get_ident_version:
# {
	_header_savestack

	addi $a0, $a0, 6
	jal endian_read_b

	_header_restorestack
	jr $ra
# }

header_get_type:
# {
	_header_savestack

	addi $a0, $a0, EI_NIDENT
	jal endian_read_h

	_header_restorestack
	jr $ra
# }

header_get_machine:
# {
	_header_savestack

	addi $a0, $a0, 18
	jal endian_read_h

	_header_restorestack
	jr $ra
# }

header_get_machine_str:
# {
	_header_savestack

	jal header_get_machine

	addi $v0, $v0, -1

	mul $t0, $v0, STR_EM_LENGTH

	la $t1, str_em_none
	add $v0, $t0, $t1
	addi $v0, $v0, -1

	_header_restorestack
	jr $ra
# }
header_get_version:
# {
	_header_savestack

	addi $a0, $a0, 20
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

header_get_entry:
# {
	_header_savestack

	addi $a0, $a0, 24
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

header_get_phoff:
# {
	_header_savestack

	addi $a0, $a0, 28
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

header_get_shoff:
# {
	_header_savestack

	addi $a0, $a0, 32
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

header_get_flags:
# {
	_header_savestack

	addi $a0, $a0, 36
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

header_get_ehsize:
# {
	_header_savestack

	addi $a0, $a0, 40
	jal endian_read_h

	_header_restorestack
	jr $ra
# }

header_get_phentsize:
# {
	_header_savestack

	addi $a0, $a0, 42
	jal endian_read_h

	_header_restorestack
	jr $ra
# }

header_get_phnum:
# {
	_header_savestack

	addi $a0, $a0, 44
	jal endian_read_h

	_header_restorestack
	jr $ra
# }

header_get_shentsize:
# {
	_header_savestack

	addi $a0, $a0, 46
	jal endian_read_h

	_header_restorestack
	jr $ra
# }

header_get_shnum:
# {
	_header_savestack

	addi $a0, $a0, 48
	jal endian_read_h

	_header_restorestack
	jr $ra
# }

ph_get_type:
# {
	_header_savestack

	addi $a0, $a0, 0
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

ph_get_offset:
# {
	_header_savestack

	addi $a0, $a0, 4
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

ph_get_vaddr:
# {
	_header_savestack

	addi $a0, $a0, 8
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

ph_get_paddr:
# {
	_header_savestack

	addi $a0, $a0, 12
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

ph_get_filesz:
# {
	_header_savestack

	addi $a0, $a0, 16
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

ph_get_memsz:
# {
	_header_savestack

	addi $a0, $a0, 20
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

ph_get_flags:
# {
	_header_savestack

	addi $a0, $a0, 24
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

ph_get_align:
# {
	_header_savestack

	addi $a0, $a0, 28
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

################################################################################
# 
# Section header
# --------------
# 
# @param	$a0		Endereço do cabeçalho da seção na memória.
# 
# @returns	$v0 	Retorna o valor do campo, se for inteiro. Caso seja string,
#					retornará o endereço de memória do primeiro byte dela.
# 
################################################################################

sh_get_name:
# {
	_header_savestack

	jal endian_read_w

	_header_restorestack
	jr $ra
# }

sh_get_type:
# {
	_header_savestack

	addi $a0, $a0, 4
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

sh_get_flags:
# {
	_header_savestack

	addi $a0, $a0, 8
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

sh_get_addr:
# {elf
	_header_savestack

	addi $a0, $a0, 12
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

sh_get_offset:
# {
	_header_savestack

	addi $a0, $a0, 16
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

sh_get_size:
# {
	_header_savestack

	addi $a0, $a0, 20
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

sh_get_link:
# {
	_header_savestack

	addi $a0, $a0, 24
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

sh_get_info:
# {
	_header_savestack

	addi $a0, $a0, 28
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

sh_get_addralign:
# {
	_header_savestack

	addi $a0, $a0, 32
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

sh_get_entsize:
# {
	_header_savestack

	addi $a0, $a0, 36
	jal endian_read_w

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

	jal endian_read_w

	_header_restorestack
# }

st_get_value:
# {
	_header_savestack

	addi $a0, $a0, 4
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

st_get_size:
# {
	_header_savestack

	addi $a0, $a0, 8
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

st_get_info:
# {
	_header_savestack

	addi $a0, $a0, 12
	jal endian_read_b

	_header_restorestack
	jr $ra
# }

st_get_other:
# {
	_header_savestack

	addi $a0, $a0, 13
	jal endian_read_b

	_header_restorestack
	jr $ra
# }

st_get_shndx:
# {
	_header_savestack

	addi $a0, $a0, 14
	jal endian_read_h

	_header_restorestack
	jr $ra
# }

################################################################################
# Relocation
################################################################################

rel_get_offset:
# {
	_header_savestack

	jal endian_read_w

	_header_restorestack
# }

rel_get_info:
# {
	_header_savestack

	addi $a0, $a0, 4
	jal endian_read_w

	_header_restorestack
	jr $ra
# }

rela_get_addend:
# {
	_header_savestack

	addi $a0, $a0, 8
	jal endian_read_sw

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

	print_str str_label_type

	move $a0, $s0
	jal header_get_type
	print_hex($v0)

	##

	print_str str_label_machine

	move $a0, $s0
	jal header_get_machine
	print_hex($v0)

	move $a0, $s0
	jal header_get_machine_str
	print_str_addr($v0)

	##

	print_str str_label_version

	move $a0, $s0
	jal header_get_version
	print_hex($v0)

	##

	print_str str_label_entry

	move $a0, $s0
	jal header_get_entry
	print_hex($v0)

	##

	print_str str_label_phoff

	move $a0, $s0
	jal header_get_phoff
	print_hex($v0)

	move $a0, $s0
	jal header_get_phoff
	print_int($v0)

	##

	print_str str_label_shoff

	move $a0, $s0
	jal header_get_shoff
	print_hex($v0)

	##

	print_str str_label_flags

	move $a0, $s0
	jal header_get_flags
	print_hex($v0)

	##

	print_str str_label_ehsize

	move $a0, $s0
	jal header_get_ehsize
	print_hex($v0)

	##

	print_str str_label_phentsize

	move $a0, $s0
	jal header_get_phentsize
	print_hex($v0)

	##

	print_str str_label_phnum

	move $a0, $s0
	jal header_get_phnum
	print_hex($v0)

	##

	print_str str_label_shentsize

	move $a0, $s0
	jal header_get_shentsize
	print_hex($v0)

	##

	print_str str_label_shnum

	move $a0, $s0
	jal header_get_shnum
	print_hex($v0)

	##

	print_str str_label_shstrndx

	move $a0, $s0
	jal endian_read_h
	print_hex($v0)

	lw $ra, 8($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8

	jr $ra
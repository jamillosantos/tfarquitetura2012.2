
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


.macro _ph_savestack
	add $sp, $sp, -4
	sw $ra, 4($sp)
.end_macro

.macro _ph_restorestack
	lw $ra, 4($sp)
	add $sp, $sp, 4
.end_macro

.data

lbl_PT_NULL:
	.ascii "NULL\0\0\0\0"
	.ascii "LOAD\0\0\0\0"
	.ascii "DYNAMIC\0"
	.ascii "INTERP\0\0"
	.ascii "NOTE\0\0\0\0"
	.ascii "SHLIB\0\0\0"
	.ascii "PHDR\0\0\0\0"

.text

program_header_dump:
# {
	addi $sp, $sp, -8
	sw $ra, 8($sp)
	sw $s0, 4($sp)

	# Salva parâmetro para uso posterior
	move $s0, $a0

	##

	printStr("\nType: ")
	move $a0, $s0
	jal ph_get_type
	printHex($v0)
	printStr(" (")
	printInt($v0)
	printStr(": ")

	la $t0, lbl_PT_NULL
	mul $t1, $v0, 8
	add $t0, $t0, $t1
	printStrAddr($t0)
	printStr(")")

	printLn

	##

	printStr("Offset: ")
	move $a0, $s0
	jal ph_get_offset
	printHex($v0)
	printStr(" (")
	printInt($v0)
	printStr(")")
	printLn

	##

	printStr("VAddr: ")
	move $a0, $s0
	jal ph_get_vaddr
	printHex($v0)
	printLn

	##

	printStr("PAddr: ")
	move $a0, $s0
	jal ph_get_paddr
	printHex($v0)
	printLn

	##

	printStr("Filesz: ")
	move $a0, $s0
	jal ph_get_filesz
	printHex($v0)
	printLn

	##

	printStr("Memsz: ")
	move $a0, $s0
	jal ph_get_memsz
	printHex($v0)
	printLn

	##

	printStr("Flags: ")
	move $a0, $s0
	jal ph_get_flags
	printHex($v0)
	printLn

	##

	printStr("Align: ")
	move $a0, $s0
	jal ph_get_align
	printHex($v0)
	printLn

	##

	lw $ra, 8($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8

	jr $ra
# }

ph_get_type:
# {
	_ph_savestack

	fileReadW(0)

	_ph_restorestack
	jr $ra
# }

ph_get_offset:
# {
	_ph_savestack

	fileReadW(4)

	_ph_restorestack
	jr $ra
# }

ph_get_vaddr:
# {
	_ph_savestack

	fileReadW(8)

	_ph_restorestack
	jr $ra
# }

ph_get_paddr:
# {
	_ph_savestack

	fileReadW(12)

	_ph_restorestack
	jr $ra
# }

ph_get_filesz:
# {
	_ph_savestack

	fileReadW(16)

	_ph_restorestack
	jr $ra
# }

ph_get_memsz:
# {
	_ph_savestack

	fileReadW(20)

	_ph_restorestack
	jr $ra
# }

# Não encontrado mais informações sobre este campo na fonte de dados
ph_get_flags:
# {
	_ph_savestack

	fileReadW(24)

	_ph_restorestack
	jr $ra
# }

ph_get_align:
# {
	_ph_savestack

	fileReadW(28)

	_ph_restorestack
	jr $ra
# }

	.section .mdebug.abi32
	.previous
	.file	"prog1.bc"
	.text
	.globl	main
	.align	2
	.type	main,@function
	.set	nomips16                # @main
	.ent	main
main:
	.cfi_startproc
	.frame	$sp,32,$ra
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# BB#0:                                 # %entry
	addiu	$sp, $sp, -32
$tmp1:
	.cfi_def_cfa_offset 32
	sw	$zero, 28($sp)
	sw	$4, 24($sp)
	sw	$5, 16($sp)
	addiu	$1, $zero, 10
	sw	$1, 8($sp)
	addiu	$1, $zero, 20
	sw	$1, 4($sp)
	lw	$1, 8($sp)
	addiu	$2, $1, 20
	sw	$2, 12($sp)
	jr	$ra
	addiu	$sp, $sp, 32
	.set	at
	.set	macro
	.set	reorder
	.end	main
$tmp2:
	.size	main, ($tmp2)-main
	.cfi_endproc



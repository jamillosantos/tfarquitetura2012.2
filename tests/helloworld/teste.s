	.section .mdebug.abi32
	.previous
	.set mips32
	.file	"teste.c"
	.text
	.globl	main
	.align	2
	.type	main,@function
	.set	nomips16
	.ent	main
main:
	.frame	$fp,56,$ra
	.mask 	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp, $sp, -56
	sw	$ra, 52($sp)
	sw	$fp, 48($sp)
	addu	$fp, $sp, $zero
	sw	$zero, 44($fp)
	sw	$4, 40($fp)
	sw	$5, 36($fp)
	lui	$2, %hi($.str)
	addiu	$2, $2, %lo($.str)
	sw	$4, 32($fp)
	addu	$4, $zero, $2
	sw	$5, 28($fp)
	jal	printf
	nop
	lw	$4, 28($fp)
	lw	$5, 32($fp)
	addiu	$3, $zero, 0
	sw	$2, 24($fp)
	addu	$2, $zero, $3
	sw	$5, 20($fp)
	sw	$4, 16($fp)
	addu	$sp, $fp, $zero
	lw	$fp, 48($sp)
	lw	$ra, 52($sp)
	addiu	$sp, $sp, 56
	jr	$ra
	nop
	.set	macro
	.set	reorder
	.end	main
$tmp3:
	.size	main, ($tmp3)-main

	.type	$.str,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
$.str:
	.asciz	 "Hello world.\n"
	.size	$.str, 14



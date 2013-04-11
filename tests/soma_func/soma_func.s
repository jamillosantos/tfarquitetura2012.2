	.section .mdebug.abi32
	.previous
	.file	"prog2.bc"
	.text
	.globl	soma
	.align	2
	.type	soma,@function
	.set	nomips16                # @soma
	.ent	soma
soma:
	.cfi_startproc
	.frame	$sp,8,$ra
	.mask 	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# BB#0:                                 # %entry
	addiu	$sp, $sp, -8
$tmp1:
	.cfi_def_cfa_offset 8
	sw	$4, 4($sp)
	sw	$5, 0($sp)
	lw	$1, 4($sp)
	addu	$2, $1, $5
	jr	$ra
	addiu	$sp, $sp, 8
	.set	at
	.set	macro
	.set	reorder
	.end	soma
$tmp2:
	.size	soma, ($tmp2)-soma
	.cfi_endproc

	.globl	main
	.align	2
	.type	main,@function
	.set	nomips16                # @main
	.ent	main
main:
	.cfi_startproc
	.frame	$sp,48,$ra
	.mask 	0x80000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	.set	noat
# BB#0:                                 # %entry
	lui	$2, %hi(_gp_disp)
	addiu	$2, $2, %lo(_gp_disp)
	addiu	$sp, $sp, -48
$tmp5:
	.cfi_def_cfa_offset 48
	sw	$ra, 44($sp)            # 4-byte Folded Spill
$tmp6:
	.cfi_offset 31, -4
	addu	$gp, $2, $25
	sw	$zero, 40($sp)
	sw	$4, 36($sp)
	sw	$5, 32($sp)
	addiu	$1, $zero, 10
	sw	$1, 24($sp)
	addiu	$1, $zero, 20
	sw	$1, 20($sp)
	lw	$4, 24($sp)
	lw	$25, %call16(soma)($gp)
	jalr	$25
	addiu	$5, $zero, 20
	sw	$2, 28($sp)
	addiu	$2, $zero, 0
	lw	$ra, 44($sp)            # 4-byte Folded Reload
	jr	$ra
	addiu	$sp, $sp, 48
	.set	at
	.set	macro
	.set	reorder
	.end	main
$tmp7:
	.size	main, ($tmp7)-main
	.cfi_endproc



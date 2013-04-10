
#.globl file_addr

file_addr:
# {
	lw $t0, 0($a0)					# CURSOR
	add $v0, $a0, $t0
	add $v0, $v0, 12

	jr $ra
# }

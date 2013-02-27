
.include "macros.asm"

.globl endian_read_b
.globl endian_read_h
.globl endian_read_w

.data

.text

endian_read_b:
	lb $v0, 0($a0)
	jr $ra	

endian_read_h:
	lb $v0, 0($a0)
	sll $v0, $v0, 8
	lb $t0, 1($a0)
	or $v0, $v0, $t0

	jr $ra

endian_read_w:
	lb $v0, 0($a0)
	sll $v0, $v0, 8
	lb $t0, 1($a0)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0
	sll $v0, $v0, 8
	lb $t0, 2($a0)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0
	sll $v0, $v0, 8
	lb $t0, 3($a0)
	and $t0, $t0, 0xff
	or $v0, $v0, $t0

	jr $ra

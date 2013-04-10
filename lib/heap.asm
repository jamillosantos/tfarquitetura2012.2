
.macro malloc(%size)
	li $a0, %size
	li $v0, 9
	syscall
.end_macro

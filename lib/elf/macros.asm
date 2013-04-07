
.macro println
	print_str(nl)
.end_macro

.macro print_int(%int)
	move $a0, %int
	li $v0, 1
	syscall
.end_macro

.macro print_hex(%hex)
	move $a0, %hex
	li $v0, 34
	syscall
.end_macro

.macro print_str(%str)
	la $a0, %str
	li $v0, 4
	syscall
.end_macro

.macro print_str_addr(%addr)
	move $a0, %addr
	li $v0, 4
	syscall
.end_macro

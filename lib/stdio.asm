# version: 1.1.0
# label prefix: b#_

.globl printStr
.globl printInt
.globl readStr

.text

################################################################################
printStr:
        # a0 = address of null-terminated string to print
        
        # prologo ----------
        addiu   $sp, $sp, -8
        sw      $ra, 4($sp)
        sw      $fp, 0($sp)
        addu    $fp, $0, $sp
        # ------------------
        
        addi $2, $0, 4  # print string service
        syscall
        
        # epilogo ----------
        addu    $sp, $0, $fp
        lw      $ra, 4($sp)
        lw      $fp, 0($sp)
        addiu   $sp, $sp, 8
        # ------------------

        jr $ra

################################################################################
printInt:
        # $a0 = the integer to print
        
        # prologo ----------
        addiu $sp, $sp, -8
        sw    $ra, 4($sp)
        sw    $fp, 0($sp)
        addu  $fp, $0, $sp
        # ------------------
        
        addi $2, $0, 1  # print integer service
        syscall

        # epilogo ----------
        addu  $sp, $0, $fp
        lw    $ra, 4($sp)
        lw    $fp, 0($sp)
        addiu $sp, $sp, 8
        # ------------------

        jr $ra
        
################################################################################
readStr:
        # $4 = address of input buffer
        # $5 = maximum number of characters to read
        
        # prologo ----------
        addiu $sp, $sp, -8
        sw    $ra, 4($sp)
        sw    $fp, 0($sp)
        addu  $fp, $0, $sp
        # ------------------
        
        addi $2, $0, 8  # read string service
        syscall
        
        # epilogo ----------
        addu    $sp, $0, $fp
        lw      $ra, 4($sp)
        lw      $fp, 0($sp)
        addiu   $sp, $sp, 8
        # ------------------

        jr $ra

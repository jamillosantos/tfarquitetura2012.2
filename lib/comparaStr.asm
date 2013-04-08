# label prefix: d#_

.globl comparaStr

.text

comparaStr:
        # $ao = endereco da string1
        # $a1 = endereco da string2 
        # $v0 = 0: iguais, 1: diferentes

        # prologo ----------
        addiu   $sp, $sp, -8
        sw      $ra, 4($sp)
        sw      $fp, 0($sp)
        addu    $fp, $0, $sp
        # ------------------
        
        add $t1, $0, $a0
        add $t2, $0, $a1

d0_loop:
        lb      $t3, 0($t1)     # carrega um byte de cada string
        lb      $t4, 0($t2)
        
        bnez    $t3, d0_lbl     # if(testafim(str1))
        # {
            bnez $t4, d0_strDiferentes  # if(testafim(str2))
            # {
                j   d0_strIguais
            # } 
        # }

d0_lbl:        
        bnez    $t4, d1_lbl     # if(testafim(str2))
        # {
            j   d0_strDiferentes
        # }

d1_lbl:        
        beq     $t3, $t4, d0_proxLetra
        # {
            j   d0_strDiferentes
        # }

d0_proxLetra:        
        addi    $t1, $t1, 1 # t1 aponta para o proximo byte
        addi    $t2, $t2, 1 # t2 aponta para o proximo byte
        j       d0_loop

d0_strDiferentes:
        addi $v0, $0, 1
        j d0_sair
        
d0_strIguais:
        addi $v0, $0, 0

d0_sair:
        # epilogo ----------
        addu    $sp, $0, $fp
        lw      $ra, 4($sp)
        lw      $fp, 0($sp)
        addiu   $sp, $sp, 8
        # ------------------
        
        jr $ra

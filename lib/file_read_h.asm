# label prefix: lblh_

file_read_h:

        # $a0: Endereco da estrutura de dados do arquivo
        # $v0: half word lida
        # $v1: 0 para erro, 1 para sucesso
        
        # prologo ----------
        addiu $sp, $sp, -8
        sw    $ra, 4($sp)
        sw    $fp, 0($sp)
        addu  $fp, $0, $sp
        # ------------------
        
        addiu $a1, $0, 2 # numero de bytes a ser lido
        jal file_read
        
        # epilogo ----------
        addu    $sp, $0, $fp
        lw      $ra, 4($sp)
        lw      $fp, 0($sp)
        addiu   $sp, $sp, 8
        # ------------------

        jr $ra  


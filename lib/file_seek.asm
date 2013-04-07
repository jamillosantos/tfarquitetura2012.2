# label prefix: lblk_

file_seek:

        # $a0: endereco da estrutura de dados do arquivo
        # $a1: deslocamento relativo para o cursor
        # $v0: 0 para erro, 1 para sucesso
        
        # prologo ----------
        addiu $sp, $sp, -8
        sw    $ra, 4($sp)
        sw    $fp, 0($sp)
        addu  $fp, $0, $sp
        # ------------------

        # ============================
        # espaco para variaveis locais
        # ============================
        
        addiu $sp, $sp, -28
        
        # ================
        # valores iniciais
        # ================
        
        sw  $a0,  -4($fp)   # endereco da estrutura de dados
        sw  $a1,  -8($fp)   # deslocamento relativo do cursor
        sw  $0,  -12($fp)   # posicao atual do cursor
        sw  $0,  -16($fp)   # tamanho do arquivo
        sw  $0,  -20($fp)   # posicao nova para o cursor
        sw  $0,  -24($fp)   # posicao minima para o cursor
        sw  $0,  -28($fp)   # posicao maxima para o cursor

        # ===============================
        # guardar posicao atual do cursor
        # ===============================
        
        lw $t0,  -4($fp)
        lw $t1,   0($t0) 
        sw $t1, -12($fp)
        
        # ==========================
        # guardar tamanho do arquivo
        # ==========================
        
        lw $t0,  -4($fp)    # get base address 
        lw $t1,   4($t0)    # get file size information
        sw $t1, -16($fp)
        
        # ================================
        # calcula a nova posicao do cursor
        # ================================
        
        lw   $t0,  -8($fp)   # deslocamento relativo do cursor
        lw   $t1, -12($fp)   # posicao atual do cursor
        addu $t2, $t0, $t1
        sw   $t2, -20($fp) 
        
        # ======================================
        # calcula a posicao maxima para o cursor
        # ======================================
        
        # posicao maxima valida eh aquela aonde se
        # permite, pelo menos, uma leitura valida de 
        # um byte, isto eh, a posicao do ultimo byte.
                                    
        lw    $t0, -16($fp)     # get file size information
        addiu $t0, $t0, -1      # last byte index
        sw    $t0, -28($fp)
        
        # ===============================================
        # testa se a nova posicao esta dentro dos limites
        # ===============================================
        
        lw $t0, -20($fp)    # new cursor position
        lw $t1, -24($fp)    # min cursor position
        lw $t2, -28($fp)    # max cursor position
        
        blt  $t0, $t1, lblk_endError # min position
        bgtu $t0, $t2, lblk_endError # max position
        j lblk_endSuccess
                
        
lblk_endError:
        
        # =============================
        # encerra procedimento com erro
        # =============================
        
        move $v0, $0
        j lblk_exit
        
lblk_endSuccess:
        
        # ================================
        # encerra procedimento com sucesso
        # ================================

        # ==============================
        # salva a nova posicao do cursor
        # ==============================
        
        lw $t0, -20($fp)    # new cursor position
        lw $t1,  -4($fp)    # get base address 
        sw $t0,   0($t1)    # set new cursor position information
        
        li $v0, 1
        j lblk_exit
        
lblk_exit:
        
        # epilogo ----------
        addu    $sp, $0, $fp
        lw      $ra, 4($sp)
        lw      $fp, 0($sp)
        addiu   $sp, $sp, 8
        # ------------------

        jr $ra

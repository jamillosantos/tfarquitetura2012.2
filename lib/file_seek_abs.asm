# label prefix: lbll_

file_seek_abs:

        # $a0: endereco da estrutura de dados do arquivo
        # $a1: deslocamento absoluto para o cursor
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
        
        addiu $sp, $sp, -24
        
        # ================
        # valores iniciais
        # ================
        
        sw  $a0,  -4($fp)   # endereco da estrutura de dados
        sw  $a1,  -8($fp)   # nova posicao do cursor
        sw  $0,  -12($fp)   # posicao atual do cursor
        sw  $0,  -16($fp)   # tamanho do arquivo
        sw  $0,  -20($fp)   # posicao minima para o cursor
        sw  $0,  -24($fp)   # posicao maxima para o cursor

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
       
        # ======================================
        # calcula a posicao maxima para o cursor
        # ======================================
        
        # posicao maxima valida eh aquela aonde se
        # permite, pelo menos, uma leitura valida de 
        # um byte, isto eh, a posicao do ultimo byte.
                                    
        lw    $t0, -16($fp)     # get file size information
        addiu $t0, $t0, -1      # last byte index
        sw    $t0, -24($fp)
        
        # ===============================================
        # testa se a nova posicao esta dentro dos limites
        # ===============================================
        
        lw $t0,  -8($fp)    # new cursor position
        lw $t1, -20($fp)    # min cursor position
        lw $t2, -24($fp)    # max cursor position
        
        blt  $t0, $t1, lbll_endError # min position
        bgtu $t0, $t2, lbll_endError # max position
        j lbll_endSuccess
                
        
lbll_endError:
        
        # =============================
        # encerra procedimento com erro
        # =============================
        
        move $v0, $0
        j lbll_exit
        
lbll_endSuccess:
        
        # ================================
        # encerra procedimento com sucesso
        # ================================

        # ==============================
        # salva a nova posicao do cursor
        # ==============================
        
        lw $t0,  -8($fp)    # new cursor position
        lw $t1,  -4($fp)    # get base address 
        sw $t0,   0($t1)    # set new cursor position information
        
        li $v0, 1
        j lbll_exit
        
lbll_exit:
        
        # epilogo ----------
        addu    $sp, $0, $fp
        lw      $ra, 4($sp)
        lw      $fp, 0($sp)
        addiu   $sp, $sp, 8
        # ------------------

        jr $ra

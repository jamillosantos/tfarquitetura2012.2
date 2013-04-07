# label prefix: lble_

        .data 
        
        .align 2
lble_err0:
        .asciiz "erro: caminho do arquivo fonte invalido.\n" 
        
        .align 2
lble_err1:
        .asciiz "erro: processo cancelado pelo usuario.\n" 

lble_buffer0: 
        .space 32

        .align 2
lble_msg0:
        .asciiz "tamanho do arquivo a ser carregado (bytes): "
        
        .align 2
lble_msg1:
        .asciiz "\nconfirma (Sim ou Nao)? "

        .align 2
lble_char0:
        .asciiz "s"        
        
        .text
        
file_load:
        # $a0: Endereço da string com o caminho do arquivo;
        # $v0: Zero para erro. Endereço de memória da estrutura alocado.
        
        # prologo ----------
        addiu $sp, $sp, -8
        sw    $ra, 4($sp)
        sw    $fp, 0($sp)
        addu  $fp, $0, $sp
        # ------------------
        
        addiu $sp, $sp, -20   # espaco para variaveis locais
        
        # ================
        # valores iniciais
        # ================
        
        sw  $a0, -4($fp)    # endereco do arquivo fonte   
        sw  $0,  -8($fp)    # cursor
        sw  $0,  -12($fp)   # tamanho do arquivo
        sw  $0,  -16($fp)   # LSB, MSB
        sw  $0,  -20($fp)   # endereco da estrutura de dados
        
        # ====================
        # abre o arquivo fonte
        # ====================
        
        addi $v0, $0, 13    # serviço de abertura de arquivo
        addi $a1, $0, 0     # flag: 0 = leitura
        addi $6, $0, 0      # modo -> ignorado pelo MARS
        syscall             # abre o arquivo ($v0=id do arquivo; -1=erro)
        
        #=====================
        # testa identificador
        #=====================
        
        addi $t0, $0, -1
        bne  $v0, $t0, lble_1
        # {
            la $a0, lble_err0
            jal printStr
            add $a0, $0, $0 # (erro)
            j lble_exit
        # }
lble_1:
        
        # ============================
        # calcula o tamanho do arquivo
        # ============================
        
        move $t0, $v0    # $t0 = id do arquivo
        add  $t1, $0, $0 # $t1 = tamanho do arquivo
        
lble_loop1:
        # {
            addi $v0, $0, 14        # codigo de servico de leitura de arquivos
            move $a0, $t0           # $a0 -> identificador de arquivo valido
            la   $a1, lble_buffer0  # $a1 -> endereco do buffer
            addi $a2, $0, 32        # numero maximo de bytes a ser lido
            syscall
            
            beq $v0, $0, lble_lend1
            # {
                add $t1, $t1, $v0
            # } 
        # }
        j lble_loop1
        
lble_lend1:
        
        # ==========================
        # salva o tamanho do arquivo
        # ==========================
        
        sw   $t1, -12($fp)   # tamanho do arquivo fonte
        
        # ===============
        # fecha o arquivo
        # ===============
        
        move $a0, $t0      # id do arquivo
        addi $v0, $0, 16   # codigo de servico para fechamento de arquivos
        syscall
        
        # ================================
        # pede confirmacao de carregamento
        # ================================
        
        la   $a0, lble_msg0
        jal  printStr
        lw   $a0, -12($fp)
        jal  printInt
        la   $a0, lble_msg1
        jal  printStr
        la   $a0, lble_buffer0
        addi $a1, $0, 4
        jal  readStr
        
        addi $t0, $0, 115 # ascii s
        la   $a0, lble_buffer0
        lb   $t1, 0($a0)
                           
        beq $t0, $t1, lble_2
        # {
            # ==================
            # confirmacao negada
            # ==================
            
            la   $a0, lble_err1
            jal  printStr
            
            add $v0, $0, $0 # (erro) 
            add $a0, $0, $t0
            j lble_exit
        # }
lble_2:
        # ==================
        # confirmacao cedida
        # ==================
        
        # ==============================================        
        # testa se o tamanho do arquivo eh multiplo de 4
        # ==============================================
        
        addi $t2, $0, 4
        div $t1, $t2
        
        mfhi $t1
        
        beq $t1, $0, lble_3
        # {
            # ====================
            # nao eh multiplo de 4
            # ====================
        
            # calcula o complemento de 4
            sub $t2, $t2, $t1
            
            # tamanho do arquivo corrigido para multiplo de 4
            add $t2, $t2, $t1 
        # }

lble_3:        
        
        #  Estrutura de dados do arquivo
        # .word: CURSOR;                (4 bytes)
        # .word: Tamanho do arquivo;    (4 bytes)
        # .word: LSB, MSB;              (4 bytes)
        # .space: codigo do arquivo. (tamanho corrigido para multiplo de 4)
        
        # ============================================
        # calcula o tamanho da memoria a ser reservada
        # ============================================
        
        addi $t3, $t2, 12 # tamanho do arquivo + 12 bytes (4+4+4) 
        
        # =======================================
        # aloca a quantidade calculada de memoria
        # =======================================
        
        move $a0, $t3     # $a0 contains the number of bytes you need.
                          # This must be a multiple of four.
        li $v0, 9         # code 9 == allocate memory
        syscall           # call the service.
                          # $v0 <-- the address of the first byte
                          # of the dynamically allocated block
        
        # ====================================
        # salva o endereco do bloco de memoria
        # ====================================
        
        sw  $v0,  -20($fp)
        
        # ================================
        # construcao da estrutura de dados
        # ================================
        
        # {        
              
            # =====================================
            # preenchimento com os dados do arquivo
            # =====================================

            # ==============
            # abre o arquivo
            # ==============
            
            lw   $a0, -4($fp)   # endereco do arquivo fonte  
            addi $v0, $0, 13    # serviço de abertura de arquivo
            addi $a1, $0, 0     # flag: 0 = leitura
            addi $a2, $0, 0     # modo -> ignorado pelo MARS
            syscall             # abre o arquivo ($v0=id do arquivo; -1=erro)
            
            # ===================
            # valores importantes
            # ===================
            
            move $t0, $v0      # -> id do arquivo
            li   $t1, 12       # -> cursor de gravacao - offset inicial de 12 bytes
            lw   $t2, -20($fp) # -> endereco base da estrutura de dados
            
lble_loop2:
            # {
                
                # ========================
                # leitura do arquivo fonte
                # ========================
                
                addi $v0, $0, 14   # codigo de servico de leitura de arquivos
                move $a0, $t0      # $a0 -> identificador de arquivo valido
                addu $a1, $t1, $t2 # $a1 -> endereco do buffer
                addi $a2, $0, 4    # numero maximo de bytes a ser lido
                syscall
                
                # ====================
                # testa fim do arquivo
                # ====================
                
                beq $v0, $0, lble_lend2
                # {
                
                    # ===============================
                    # incrementa o cursor de gravacao
                    # ===============================
                    
                    addi $t1, $t1, 4
                # } 
            # }
            j lble_loop2
        
lble_lend2:
            
            # ===============
            # fecha o arquivo
            # ===============
            
            move $a0, $t0    # id do arquivo
            addi $v0, $0, 16 # codigo de serviço para fechamento de arquivos
            syscall
        
            # ============================================
            # posicao inicial do cursor (inicio dos dados)
            # ============================================
            
            lw $t0, -20($fp) # -> endereco base da estrutura de dados
            sw $0,    0($t0) # -> representa o inicio dos dados do arquivo
                             #    obs.: no processo de leitura o cursor sera 
                             #          somado com 12 - offset do codigo
            
            # ==================
            # tamanho do arquivo
            # ==================
            
            lw $t0, -20($fp) # -> endereco base da estrutura de dados
            lw $t1, -12($fp) # -> tamanho do arquivo
            sw $t1,   4($t0)  
            
            # ========
            # LSB, MSB
            # ========
            
            lw $t0, -20($fp) # -> endereco base da estrutura de dados
            lb $t1, 17($t0)  # -> offset do EI_DATA mais o offset do codigo
                             # 5 + 12 = 17
            sw $t1, 8($t0)
        # }
        
        # ===========================
        # retorna o endereco do bloco
        # ===========================
        
        lw $v0, -20($fp)
        
lble_exit:
        
        # epilogo ----------
        addu    $sp, $0, $fp
        lw      $ra, 4($sp)
        lw      $fp, 0($sp)
        addiu   $sp, $sp, 8
        # ------------------

        jr $ra   

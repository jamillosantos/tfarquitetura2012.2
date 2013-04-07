# version: 1.1.0
# label prefix: c#_

        .data 
        
max_param:
        .word 2
        .align 2
c0_str: 
        .asciiz "-v"
        .align 2
c1_str: 
        .asciiz "-h"
        .align 2
c0_err:
        .asciiz "erro: quantidade invalida de parametros.\n" 
        .align 2
c1_err:
        .asciiz "erro: parametro(s) invalido(s).\n"
        .align 2
c2_err:
        .asciiz "erro: nome de arquivo fonte invalido.\n"
        .align 2
c3_err:
        .asciiz "erro: nome de arquivo destino invalido.\n"     
        .align 2
c0_msg:
        .ascii  "###################################################\n"
                "# INSTITUTO FEDERAL DO RIO GRANDE DO NORTE - IFRN #\n"
                "# DIATINF                                         #\n"
                "# ARQUITETURA DE COMPUTADORES                     #\n"
                "#                                                 #\n"
                "# PROJETO:                                        #\n"
                "#   Interpretador de codigos ELF                  #\n"
                "#                                                 #\n"
                "# ORIENTADOR:                                     #\n"
                "#   Prof. Eduado Bráulio                          #\n"
                "#                                                 #\n"
                "# COMPONENTES:                                    #\n"
                "#   Gercino Alves Nogueira Junior                 #\n"
                "#   Ivan Diniz                                    #\n"
                "#   Jamillo Santos                                #\n"
                "#   Joab Mendes                                   #\n"                
                "#                                                 #\n"
                "###################################################\n\0" 
        .align 2
c1_msg:
        .ascii  "########################################################\n"
                "# FUNCIONAMENTO:                                       #\n"
                "#   o programa recebe parametros via linha de comando  #\n"
                "#       > quantidade de parametros:                    #\n"
                "#           > um ou dois                               #\n"
                "#       > significado dos paramentros:                 #\n"
                "#           > um parametro:                            #\n"
                "#               > -v                                   #\n"
                "#                   > imprime informacoes sobre este   #\n"
                "#                     trabalho                         #\n"
                "#               > -h                                   #\n"
                "#                   > imprime esta ajuda.              #\n"
                "#           > dois parametros:                         #\n"
                "#               > p1: nome do arquivo fonte            #\n"
                "#               > p2: nome do arquivo destino          #\n"
                "#                                                      #\n"
                "#  e inicia a interpretacao/traducao do codigo fonte.  #\n"
                "#                                                      #\n"
                "########################################################\n\0"
                
        .text
        
inicializar:
        # $a0 = argc: quantidade de parametros
        # $a1 = argv: array de ponteiros para os parametros
        # $v0 = 0: erro 
        #       1: -v ou -h
        #       2: arquivo de entrada e arquivo de saida
        
        # prologo ----------
        addiu   $sp, $sp, -8
        sw      $ra, 4($sp)
        sw      $fp, 0($sp)
        addu    $fp, $0, $sp
        # ------------------
        
        addiu $sp, $sp, -16   # espaco para variaveis locais
        
        bne $a0, $0, c0_endif   # if(argc == 0)
        # {
            la $a0, c0_err
            jal printStr
            add $v0, $0, $0 # (erro)
            j c_end
        # }
        
c0_endif:
        lw      $t0, max_param
        slt     $t1, $t0, $a0
        beq     $t1, $0, c1_endif   # if(argc > max_param)
        # {
            la $a0, c0_err
            jal printStr
            add $v0, $0, $0 # (erro)
            j c_end
        # } 

c1_endif:
        addi    $t0, $0, 1
        bne     $a0, $t0, c2_endif   # if(argc == 1)
        # {
            lw  $t0, 0($a1)
            sw  $t0, -4($fp)
            
            lw  $a0, -4($fp)
            la  $a1, c0_str 
            jal comparaStr
            
            bne $v0, $0, c3_endif  # if (p1 == "-v")
            # {
                la $a0, c0_msg
                jal printStr
                addi $v0, $0, 1 # (um parametro) 
                j c_end
            # }

c3_endif:
            lw  $a0, -4($fp)
            la  $a1, c1_str 
            jal comparaStr
            
            bne $v0, $0, c4_endif  # if (p1 == "-h")
            # {
                la $a0, c1_msg
                jal printStr
                addi $v0, $0, 1 # (um parametro) 
                j c_end
            # }

c4_endif:
            la $a0, c1_err
            jal printStr
            add $v0, $0, $0 # (erro)
            j c_end
            
        # } 

c2_endif:

        # tentar carregar arquivo fonte...
        addi $v0, $0, 2 # (sao dois parametros!)
        
c_end:
        # epilogo ----------
        addu    $sp, $0, $fp
        lw      $ra, 4($sp)
        lw      $fp, 0($sp)
        addiu   $sp, $sp, 8
        # ------------------
        
        jr $ra

# version: 1.1.0
# label prefix: lbla_

.include "./lib/stdio.asm"
.include "./lib/comparaStr.asm"
.include "./lib/file_load.asm"
.include "./lib/file_read.asm"
.include "./lib/file_read_b.asm"
.include "./lib/file_read_h.asm"
.include "./lib/file_read_w.asm"
.include "./lib/file_read_sw.asm"
.include "./lib/file_seek.asm"
.include "./lib/file_seek_abs.asm"
.include "inicializar.asm"
        
        .text
        .globl main
main:                   
        jal inicializar
        
        # =======================
        # termina em caso de erro
        # =======================
        
        beq $v0, $0, lbla_erro
        
        # ======================================
        # termina em caso de apenas um parâmetro
        # que não seja -h ou -v
        # ======================================
        
        addi $t0, $0, 1
        beq $v0, $t0, lbla_end
        
        # =========================================================
        # salva o endereco da string com o caminho do arquivo fonte
        # =========================================================
        
        lw $s0, 0($a1)
        
        # ===========================================================
        # salva o endereco da string com o caminho do arquivo destino
        # ===========================================================
        
        lw $s1, 4($a1)
        
        # =======================
        # carrega o arquivo fonte
        # =======================
        
        move $a0, $s0
        jal file_load
        
        # =============
        # testa retorno
        # =============
        
        beq $v0, $0, lbla_erro
        
        # ======================================
        # salva o endereco da estrutura de dados
        # ======================================
        
        move $s0, $v0
        
#===============================================================================
        
        # ==============
        # PROGRAMA TESTE
        # ==============
        
        .data

        .align 2
lbla_msg0:
        .asciiz "\n" 
        
        .align 2
lbla_msg1:
        .asciiz "erro\n"         

        .text
        
        # -------------------------------------------------------------
        # imprime o quatro primeiros bytes do codigo 
        # (ascii[del] = 127)
        # (ascii[E] = 69)
        # (ascii[L] = 76)
        # (ascii[F] = 70)

        addi $s1, $0, 4 
        
lbla_loop1:

        beq $s1, $0, lbla_lend1
        # {
            move $a0, $s0
            jal  file_read_b
            
            beq  $v1, $0, lbla_erro
            
            move $a0, $v0
            jal  printInt
            la   $a0, lbla_msg0
            jal  printStr
        # }
        addi $s1, $s1, -1
        j lbla_loop1
        
lbla_lend1:
        
        # -------------------------------------------------------------
        # imprime o primeiro byte do codigo (uso do file_seek_abs) 
        # (ascii[del] = 127)
                
        move $a0, $s0
        li   $a1, 0
        jal  file_seek_abs
        beq  $v0, $0, lbla_erro
        
        move $a0, $s0
        jal  file_read_b
        beq  $v1, $0, lbla_erro
        
        move $a0, $v0
        jal  printInt
        la   $a0, lbla_msg0
        jal  printStr
        
        # -------------------------------------------------------------
        # imprime o primeiro byte do codigo (uso do file_seek) 
        # (ascii[del] = 127)
                
        move $a0, $s0
        li   $a1, -1
        jal  file_seek
        beq  $v0, $0, lbla_erro
        
        move $a0, $s0
        jal  file_read_b
        beq  $v1, $0, lbla_erro
        
        move $a0, $v0
        jal  printInt
        la   $a0, lbla_msg0
        jal  printStr
        
        # ===================
        # encerra com sucesso
        # ===================
        
        add $a0, $0, $0
        j lbla_end
        
lbla_end:
        # a0 = return value code
        addi $2, $0, 17     # terminate with value service
        syscall             # system call

lbla_erro:
        la   $a0, lbla_msg1
        jal  printStr
        addi $a0, $0, 1
        j lbla_end

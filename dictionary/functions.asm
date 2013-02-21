.data
	dictionary: .asciiz "/home/joabe/projetoAC/dictionary/dictionary\0"
	msg: .asciiz "Open." 
.text

dict_load: 
	addi $2, $0, 13
	la $4, dictionary
	addi $5, $0, 0		# Flag 0 para leitura			
	syscall
	
	#Verificar abertura
	addi $8, $0, -1			# $8 -> -1
	bne  $2, $8, dict_find 		#if($8 != $2[leitura]){dict_find}
		addi $2, $0, 1		 
		addi $4, $0, -1		
		syscall
		j end			

dict_find:
	la $4, msg		# Imprime mensagem solicitando a chave
	add $2, $0, 4
	syscall
end:
	addi $2, $0, 10		
	syscall

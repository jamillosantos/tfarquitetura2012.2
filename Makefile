
MARS = java -jar ../../Mars4_3.jar nc
# Options
# nc:
#	Disabilita a impressão do cabeçalho do MARS via linha de comando
# p:
# 	Modo projeto.

main:
	$(MARS) p main.asm pa tests/helloworld/a.out
	# $(MARS) ascii 0x10010000-0x100100fc 0x1008ff00-0x100900cc p main.asm pa tests/helloworld/a.out

args:
	$(MARS) args.asm pa parametro1 parametro2 blablabla 

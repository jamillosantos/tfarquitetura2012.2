
MARS = java -jar ../../Mars_4_2.jar nc
# Options
# nc:
#	Disabilita a impressão do cabeçalho do MARS via linha de comando
# p:
# 	Modo projeto.

main:
	$(MARS) p main.asm pa tests/helloworld/a.out

args:
	$(MARS) args.asm pa parametro1 parametro2 blablabla 



MARS = java -jar ../../Mars4_3.jar sm nc me ae255
# Options
#   sm    = Start execution at statement having global label 'main' if defined;
#
#   nc    = Copyright notice will not be displayed. Useful if redirecting or 
#           piping program output;
#
#   me    = Display MARS messages to standard err instead of standard out. 
#           Allows you to separate MARS messages from MIPS program output using 
#           redirection;
#
#   ae255 = Terminate MARS with integer exit code n if assembly error occurs;
#
#   pa    = Program Arguments - all remaining space-separated items are argument 
#           values provided to the MIPS program via $a0 (argc - argument count) 
#           and $a1 (argv - address of array containing pointers to 
#           null-terminated argument strings). The count is also at the top of 
#           the runtime stack ($sp), followed by the array.This option and its 
#           arguments must be the last items in the command!


main:
	$(MARS) p main.asm pa tests/helloworld/a.out arquivodestino

dump:
	$(MARS) ascii 0x100108c0-0x10010acc 0x1008ff00-0x100900cc p main.asm pa tests/helloworld/a.out arquivodestino

args:
	$(MARS) args.asm pa parametro1 parametro2 blablabla 

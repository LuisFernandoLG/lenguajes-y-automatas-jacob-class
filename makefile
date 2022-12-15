	clear
	rm file.data
	rm file.bss
	rm file.text
	
	rm ./lex.yy.c
	rm ./archivo1.txt
	rm ./archivo2.txt
	rm ./lex.yy.c
	rm ./y.tab.c
	rm ./y.tab.h
	rm ./sintactico.exe

	bison -yd sintactico.y
	flex lexico.l
	gcc y.tab.c lex.yy.c -o sintactico
	./sintactico < codigo.txt

	
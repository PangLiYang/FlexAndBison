output: calc.tab.c lex.yy.c
	g++ calc.tab.c lex.yy.c -o calc
	rm *.c *.h

calc.tab.c: calc.y
	bison -d calc.y

lex.yy.c: calc.l
	flex calc.l

clean:
	rm *.o *.c *.h calc
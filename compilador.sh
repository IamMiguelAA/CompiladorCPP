flex lexico.l
bison -d parser.y
g++ parser.tab.c lex.yy.c  -ll
./a.out
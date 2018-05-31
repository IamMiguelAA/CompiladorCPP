flex lexico.l
bison -d parser.y
g++ parser.tab.c lex.yy.c -lfl
./a.out
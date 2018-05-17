%{
#include <iostream>
#include <string>
#include <algorithm>
#include <map>
using namespace std;
#include "parser.tab.h"
%}
%%

[ \n\t\r]+	;
","		return *yytext;
"exit"		{yylval.nombre=new string(yytext); return EXIT;}
"int"+[a-zA-Z  ]+[(] {yylval.nombre=new string(yytext); return FUNC;}
"return"	{yylval.nombre = new string (yytext); return RETURN;}
"#define"	{yylval.nombre = new string (yytext); return DEFINE;}
"int"		{yylval.nombre = new string (yytext); return INT;}
"if"		{yylval.nombre= new string (yytext); return IF;}
"else"		{yylval.nombre= new string (yytext); return ELSE;}
"AND"		{yylval.nombre= new string (yytext); return AND;}
"OR"		{yylval.nombre=new string(yytext); return OR;}
"NOT"		{yylval.nombre=new string(yytext); return NOT;}
"float"		{return FLOAT;}
"printf"	{yylval.nombre=new string(yytext); return PRINT;}
"scanf"		{yylval.nombre=new string(yytext); return SCAN;}
[0-9]+ 		{yylval.valor = atoi(yytext); return NUM;}
[a-zA-Z]+[a-zA-Z0-9]*	{yylval.nombre = new string (yytext); return ID;}
[+*-/();=] 	return *yytext;
[\"]+[a-zA-Z0-9 =+*%  \- \t \r]+	{yylval.nombre=new string(yytext); return cadena;}
"\""		{yylval.nombre=new string(yytext); return COMI;}
"=="		{yylval.nombre= new string (yytext); return Log;}
"<="		{yylval.nombre= new string (yytext); return Log;}
">="		{yylval.nombre= new string (yytext); return Log;}
"!="		{yylval.nombre= new string (yytext); return Log;}
"{"		return *yytext;
"}"		return *yytext;
"["		return *yytext;
"]"		return *yytext;
"&"		return *yytext;
. 		{cerr << "Error léxico, caracter (" << yytext << ") desconocido\n";}

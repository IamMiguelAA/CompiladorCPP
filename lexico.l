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
"printf"+[(]	{yylval.nombre=new string(yytext); return PRINT;}
"scanf"+[(]	{yylval.nombre=new string(yytext); return SCAN;}
"if"+[(]		{yylval.nombre= new string (yytext); return IF;}
"else"		{yylval.nombre= new string (yytext); return ELSE;}
"while"+[(]	{yylval.nombre= new string (yytext); return WHILE;}
[a-zA-Z]+[a-zA-Z]*+[(]	{yylval.nombre=new string(yytext); return CALL;}
"return"	{yylval.nombre = new string (yytext); return RETURN;}
"#define"	{yylval.nombre = new string (yytext); return DEFINE;}
"int"		{yylval.nombre = new string (yytext); return INT;}
"void"		{yylval.nombre = new string (yytext); return INT;}
"&&"		{yylval.nombre= new string (yytext); return AND;}
"||"		{yylval.nombre=new string(yytext); return OR;}
"float"		{return FLOAT;}
[0-9]+ 		{yylval.valor = atoi(yytext); return NUM;}
[a-zA-Z]+[a-zA-Z0-9]*	{yylval.nombre = new string (yytext); return ID;}
[+*-/();=] 	return *yytext;
[\"]+[a-zA-Z0-9 =+*%  \- \t \r \:]*+['\\'+"n"]*+[a-zA-Z0-9 =+*%  \- \t \r \:]*+[\"]	{yylval.nombre=new string(yytext); return cadena;}
"=="		{yylval.nombre= new string (yytext); return Log;}
"<="		{yylval.nombre= new string (yytext); return Log;}
">="		{yylval.nombre= new string (yytext); return Log;}
"!="		{yylval.nombre= new string (yytext); return Log;}
">"		{yylval.nombre= new string (yytext); return Log;}
"<"		{yylval.nombre= new string (yytext); return Log;}
"!"		{yylval.nombre=new string(yytext); return NOT;}
"{"		return *yytext;
"}"		return *yytext;
"["		return *yytext;
"]"		return *yytext;
"&"		return *yytext;
. 		{cerr << "Error léxico, caracter (" << yytext << ") desconocido\n";}
<<EOF>> return FEOFF;

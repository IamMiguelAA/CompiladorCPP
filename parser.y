%{
#include <iostream>
#include <iterator>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include "arbol.cpp"
#include <algorithm>
#include <map>

using namespace std;
int yyerror(const char* msj);
int yylex(void);
fstream fichero;
NodoSuma suma;
NodoResta resta;
NodoMul multi;
NodoDiv divi;
NodoPrintf print;
NodoScanf scan;
NodoFunc funciones;
int DecOrExp=0;
int contadorstrings=0;
int contadorscanf=0;
int contadorliberaespacio=0;
int contadorlocales=0;
int enfuncion=0;
int retu=0;
int contadorparametros=0;
map<string,int> parametros;
map<string,int> locales;
map<string,int> globales;
map<string,int> variables;
//String for the printf function.
string cadforprintf="";

struct varint{
varint(string *n,int v=0){
var=n;
nu=v;
}
varint& operator = (varint& a){
this->var=a.var;
this->nu=a.nu;
}
varint& modificar(int a){
this->nu=a;
}
string * var;
int nu;
};

int si=1;
int sino=0;

vector<varint> variablesenteras;
vector<string> auxscanf;
vector<int> IDS;

varint& buscar(string *n){
int it=0;
bool encontrado=false;
vector<varint>::iterator iterador;
iterador=variablesenteras.begin();
while(iterador!=variablesenteras.end() && encontrado!=true){
	if(*(variablesenteras[it].var)==*(n)){
	encontrado=true;
	}else{
	iterador++;
	it++;
	}
}
if(encontrado==true){
return variablesenteras[it];
}
}

string imprimir(string s){

string devolver;
int longitud=0;
int j=0;
s.erase(0,1);

for(int i=0;i<s.length();i++){

if(s[i]=='%'){
j=i+1;
if(s[j]=='d'){
int a=IDS.back();
IDS.pop_back();
devolver+=to_string(a);
longitud+=to_string(a).length();
i=j;
}else{
longitud++;
devolver.resize(longitud,s[i]);
}
}else{
longitud++;
devolver.resize(longitud,s[i]);
}
}

return devolver;

}

int buscarenmap(string cad,map<string,int> entrada){
std::map<string,int>::iterator it=entrada.find(cad);
if(it!=entrada.end()){
return entrada[cad];
}else{return -1;}

}


%}

%error-verbose

%union {
int valor;
string * nombre;
}


%token <nombre> ID <valor> NUM <valor2>NUM2
%token <nombre>INT FLOAT DOUBLE AND OR NOT Log DEFINE  PRINT RETURN SCAN EXIT FUNC
%token <nombre> cadena COMI
%type <valor> comp exp term fact compa compara comparacion dibuj espe
%type <nombre> Declaracion PRINTF SCANF
%nonassoc IF
%nonassoc ELSE
//%type <nombre> ifst elsest
%start ent

%%
ent: 
	|ent EXIT {YYABORT;}
	|ent Declaracion ';' {DecOrExp=0;}
	|ent exp ';'
	|ent PRINTF ';'
	|ent FUNC param ')' '{'{string cadena=*$2; string aux=cadena.substr(0,cadena.find("(")); cadena=aux.substr(aux.find(" "));cadena.erase(std::remove(cadena.begin(),cadena.end(),' '),cadena.end()); 			funciones.escribeini(fichero,cadena); enfuncion=1; contadorparametros=0;	
	} ent RETURN {retu=1;} exp ';' {funciones.escriberet(fichero,$10); retu=0;} '}' {funciones.escribefin(fichero); enfuncion=0;}
	|ent SCANF ';' {std::reverse(auxscanf.begin(),auxscanf.end()); for(int i=0;i<contadorscanf;i++){/*varint a=buscar(auxscanf[i]);*/ string std=auxscanf[i]; int b; cin>>b; variables[std]=b; /*varint prue=buscar(auxscanf[i]); cout<<prue.nu<<endl;*/ }} 
	|ent IFs 
	|ent DEFINE ID NUM {if(si==1 || sino==1){/*variablesenteras.push_back(varint($3,$4));*/ variables[*$3]=$4;}}
	
;
param:
	|param ',' INT ID {parametros[*$4]=contadorparametros; contadorparametros++;}
	|INT ID {parametros[*$2]=contadorparametros; contadorparametros++;}
;

IFs: IF '(' compa ')'{if(si==0){si=0;sino=0;}else if($3==1){si=1; sino=0;}else{si=0;sino=0;}} '{' ent '}' Elsef
;
Elsef:  
	|{if(si==0 && sino==0){si=0; sino=1;}else{si=0; sino=0;}} ELSE '{' ent '}' {si=0; sino=0;} 

;

Declaracion:  INT ID  Declespe  { if(si==1 || sino==1){/*variablesenteras.push_back(varint($2));*/ variables[*$1]=0;}}
		|ID '=' {DecOrExp=1;} exp {if(si==1 || sino==1){/*buscar($1).nu=$4;*/ variables[*$1]=$4; if(enfuncion==1){auto id=new NodoId(*$1); id->nuevaasign(fichero,contadorlocales); locales[*$1]=contadorlocales;fichero<<endl; contadorlocales++;}}}
		|INT ID '=' {DecOrExp=1;} exp {if(si==1 || sino==1){/*variablesenteras.push_back(varint($2,$5));*/ variables[*$2]=$5; if(enfuncion==1){auto id=new NodoId(*$1); id->nuevaasign(fichero,contadorlocales); locales[*$1]=contadorlocales;fichero<<endl; contadorlocales++;}}}
		|INT ID '[' NUM ']' 

;
Declespe: 
	|',' ID Declespe { if(si==1 || sino==1){/*variablesenteras.push_back(varint($2));*/ variables[*$2]=0;}}
	|ID { if(si==1 || sino==1){/*variablesenteras.push_back(varint($1));}*/ variables[*$1]=0;}}
;
PRINTF: PRINT '('cadena COMI ',' dibuj ')' {string s=*$3; string devolver=imprimir(s); cout<<devolver<<endl; contadorliberaespacio++; print.escribe(fichero,contadorstrings,contadorliberaespacio, cadforprintf); cadforprintf=""; contadorstrings=1+contadorstrings;contadorliberaespacio=0;}
	|PRINT '('cadena COMI ')' {string s=*$3; string devolver=imprimir(s); cout<<devolver<<endl; contadorliberaespacio++; print.escribe(fichero,contadorstrings,contadorliberaespacio, ""); contadorliberaespacio=0; contadorstrings=1+contadorstrings;}
;
dibuj: 	{$$=0;}
	| dibuj ',' ID{/*varint a=buscar($3);*/ int a=variables[*$3]; IDS.push_back(a); $$=1; print.insertar(cadforprintf,*$3); contadorliberaespacio++;}
	| ID {/*varint a=buscar($1);*/ int a=variables[*$1]; IDS.push_back(a); $$=1; print.insertar(cadforprintf,*$1); contadorliberaespacio++;}
;
SCANF: SCAN '(' cadena COMI ',' espe ')' {string s=*$3; string devolver=imprimir(s); cout<<"Introduzca los valores:"<<endl; contadorliberaespacio++; scan.escribe(fichero,contadorstrings,contadorliberaespacio);contadorliberaespacio=0; contadorstrings=1+contadorstrings;}
	|SCAN '(' cadena COMI ')'{string s=*$3; string devolver=imprimir(s); cout<<"Introduzca los valores:"<<endl; contadorliberaespacio++; scan.escribe(fichero,contadorstrings,contadorliberaespacio); contadorliberaespacio=0; contadorstrings=1+contadorstrings;}
;
espe:	{$$=0;}
	| '&' ID ',' espe {/*varint a=buscar($2);*/int a=variables[*$2]; IDS.push_back(a); $$=1; scan.insertar(fichero,*$2); auxscanf.push_back(*$2); contadorscanf=contadorscanf+1; contadorliberaespacio++;}
	| '&' ID {/*varint a=buscar($2);*/ int a=variables[*$2]; IDS.push_back(a); $$=1; scan.insertar(fichero,*$2); auxscanf.push_back(*$2); contadorscanf=contadorscanf+1; contadorliberaespacio++;}

;


comp: ID Log ID {/*varint a=buscar($1);	varint b=buscar($3);*/ int a=variables[*$1]; int b=variables[*$3]; if(*$2=="=="){if(a==b){$$=1;}else{$$=0;}}else if(*$2=="<="){if(a<=b){$$=1;}else{$$=0;}}else if(*$2==">="){if(a>=b){$$=1;}else{$$=0;}}else if(*$2=="!="){if(a!=b){$$=1;}else{$$=0;}}}

	|ID Log NUM {/*varint a=buscar($1);*/int a=variables[*$1]; if(*$2=="=="){if(a==$3){$$=1;}else{$$=0;}}else if(*$2=="<="){if(a<=$3){$$=1;}else{$$=0;}}else if(*$2==">="){if(a>=$3){$$=1;}else{$$=0;}}else if(*$2=="!="){if(a!=$3){$$=1;}else{$$=0;}}}

	|NUM Log ID {/*varint a=buscar($3);*/ int a=variables[*$3]; if(*$2=="=="){if(a==$1){$$=1;}else{$$=0;}}else if(*$2=="<="){if($1<=a){$$=1;}else{$$=0;}}else if(*$2==">="){if($1>=a){$$=1;}else{$$=0;}}else if(*$2=="!="){if(a!=$1){$$=1;}else{$$=0;}}}

	|NUM Log NUM {if(*$2=="=="){if($1==$3){$$=1;}else{$$=0;}}else if(*$2=="<="){if($1<=$3){$$=1;}else{$$=0;}}else if(*$2==">="){if($1>=$3){$$=1;}else{$$=0;}}else if(*$2=="!="){if($1!=$3){$$=1;}else{$$=0;}}}
	
;

compa: compa OR compara {if($1==0 && $3==0){$$=0;}else{$$=1;}}
	|compara {$$=$1;}
;
compara: compara AND comparacion {if($1==1 && $3==1){$$=1;}else{$$=0;}}
	|comparacion {$$=$1;}
;
comparacion: NOT comparacion {if($2==1){$$=0;}else{$$=1;}}
		|comp {$$=$1;}
		|'(' compa ')' {$$=$2;}
;



exp: exp{suma.escribepush(fichero); fichero<<endl; } '+' term {$$=$1+$4;  suma=*(new NodoSuma($1,$4)); suma.escribe(fichero); fichero<<endl;}
	|exp{resta.escribepush(fichero); fichero<<endl; } '-' term {$$=$1-$4; resta=*(new NodoResta($1,$4)); resta.escribe(fichero); fichero<<endl;}
	|term	{$$=$1;}
;

term: term {multi.escribepush(fichero); fichero<<endl; } '*' fact {$$=$1*$4; multi=*(new NodoMul($1,$4)); multi.escribe(fichero); fichero<<endl;}
	|term {divi.escribepush(fichero); fichero<<endl; } '/' fact {$$=$1/$4;  divi=*(new NodoDiv($1,$4)); divi.escribe(fichero); fichero<<endl;}
	|fact {$$=$1;}
;
fact: NUM {$$=$1; if(enfuncion==1 && retu!=1){auto num=new NodoNum($1); num->escribe(fichero); fichero<<endl;}}
	|'-' NUM {$$=-$2; if(enfuncion==1 && retu!=1){auto num=new NodoNum(-$2); num->escribe(fichero); fichero<<endl;}}
	|'(' exp ')' {$$=$2;}
	|ID {/*varint a=buscar($1); $$=a.nu;*/ $$=variables[*$1]; if(enfuncion==1){if(buscarenmap(*$1,locales)!=-1){int aux=buscarenmap(*$1,locales);auto id=new NodoId(*$1); id->escribe(fichero,1,aux); fichero<<endl;}else if(buscarenmap(*$1,parametros)!=-1){int aux=buscarenmap(*$1,parametros);auto id=new NodoId(*$1); id->escribe(fichero,2,aux); fichero<<endl;}}
}
;

%%

int main() {
 //cout << "Teclee muchas expresiones terminadas en puntoycoma\n";
 fichero.open("a.s",std::fstream::out);
 yyparse();
 fichero.close();
 cout << "Final del programa\n";
 return EXIT_SUCCESS;
} // fin de main()

int yyerror(const char* msj) {
 cerr << msj << endl;
 return 1;
} // fin de yyerror()

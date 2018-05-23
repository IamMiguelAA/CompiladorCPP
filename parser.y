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
	Node nodo;
	NodoSuma suma;
	NodoResta resta;
	NodoMul multi;
	NodoDiv divi;
	NodoPrintf print;
	NodoScanf scan;
	NodoFunc funciones;
	NodoCall call;
	NodoComp comparaciones;
	NodoIF	ifs;
	NodoELSE elses;
	NodoWhile nwhile;

	//Contadores
	int DecOrExp=0;
	int contadorstrings=0;
	int contadorscanf=0;
	int contadorliberaespacio=0;
	int contadorlocales=0;
	int enfuncion=0;
	int retu=0;
	int contadorparametros=0;
	int contadorllamadas;
	int enllamada=0;
	int reservaespacio=0;
	int contadorifs=0;
	int contadorelse=0;
	int contadorfinal=0;
	int contadorwhiles=0;
	int enwhile=0;
	int contadoraux=0;
	int encomplejo=0;
	int selectedlog=0;
	
	vector<int> FinalesJump;
	vector<int> FINALES;
	vector<int> ELSES;
	vector<int> whiles;

	//Maps
	map<string,int> parametros;
	map<string,int> locales;
	map<string,int> globales;
	map<string,int> variables;



	//String for the printf function.
	string cadforprintf="";
	//String for the scanf function.
	string cadforscanf="";
	//String for the scanf function.
	string mainstring="";
	string mainstringGlobal="";
	//String for all the strings declared
	string stringtotales="";
	//String for global variables declaration and space reserve
	string globdeclara="";
	string globreserva="";

	string llamada="";


	//Main Struct
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
%token <nombre>INT FLOAT DOUBLE AND OR NOT Log DEFINE  PRINT RETURN SCAN EXIT FUNC CALL WHILE
%token <nombre> cadena COMI
%type <valor> exp term fact dibuj espe
%type <nombre> comp compa compara comparacion
%type <nombre> Declaracion PRINTF SCANF
%nonassoc IF
%nonassoc ELSE
%start ent

%%
ent: 
	|ent EXIT {nodo.globalesfile(fichero,globreserva); nodo.globalesfile(fichero,globdeclara); nodo.stringfile(fichero,stringtotales);nodo.finalWrite(fichero,mainstringGlobal);YYABORT;}
	|ent Declaracion ';' {DecOrExp=0;}
	|ent exp ';' {}
	|ent PRINTF ';' {}
	|ent FUNC param ')' '{'{ enfuncion=1; contadorparametros=0;} ent '}' {string cadena=*$2; string aux=cadena.substr(0,cadena.find("(")); cadena=aux.substr(aux.find(" "));cadena.erase(std::remove(cadena.begin(),cadena.end(),' '),cadena.end()); 	funciones.reservaespacio(mainstring,contadorlocales);		funciones.escribeini(mainstring,cadena); funciones.escribefin(mainstring); funciones.ReverseFile(mainstringGlobal,mainstring); enfuncion=0; contadorlocales=0; locales.clear();parametros.clear(); mainstring="";}
	|ent SCANF ';' {std::reverse(auxscanf.begin(),auxscanf.end()); for(int i=0;i<contadorscanf;i++){ string std=auxscanf[i]; int b; cin>>b; variables[std]=b;}} 
	|ent IFs {}
	|ent Whiles {}
	|ent DEFINE ID NUM {variables[*$3]=$4;}
	|ent RETURN exp ';' {/*funciones.escriberet(mainstring,$3);*/ retu=0;}
	
;


ent2: {}
	| ent Declaracion ';' {DecOrExp=0;}
	| ent exp ';' {}
	| ent PRINTF ';' {}
	| ent SCANF ';' {std::reverse(auxscanf.begin(),auxscanf.end()); for(int i=0;i<contadorscanf;i++){ string std=auxscanf[i]; int b; cin>>b; variables[std]=b;}} 
	| ent IFs {}
	| ent Whiles {}
	| ent RETURN exp ';' {/*funciones.escriberet(mainstring,$3);*/ retu=0;}
	
;

ent3: Declaracion ';' {DecOrExp=0;}
	| exp ';' {}
	| PRINTF ';' {}
	| SCANF ';' {std::reverse(auxscanf.begin(),auxscanf.end()); for(int i=0;i<contadorscanf;i++){ string std=auxscanf[i]; int b; cin>>b; variables[std]=b;}} 
	| Whiles {}
	| RETURN exp ';' {/*funciones.escriberet(mainstring,$2);*/ retu=0;}
;

param:
	|param ',' INT ID {parametros[*$4]=contadorparametros; contadorparametros++;}
	|INT ID {parametros[*$2]=contadorparametros; contadorparametros++;}
;

Whiles: WHILE {enwhile=1; whiles.push_back(contadorwhiles); nwhile.escribeini(mainstring,whiles.back()); contadorwhiles++; } compa {{if(encomplejo==0){nwhile.compara(mainstring,selectedlog,contadorfinal);}}} ')' '{'{FINALES.push_back(contadorfinal); contadorfinal++; } ent '}' {nwhile.escribefin(mainstring,whiles.back(),FINALES.back()); whiles.pop_back(); FINALES.pop_back(); enwhile=0;}

;

IFs:  IF compa ')'{ if(encomplejo==0){ comparaciones.compara(mainstring,selectedlog,contadorelse);}  ifs.escribe(mainstring,contadorifs); ELSES.push_back(contadorelse); FINALES.push_back(contadorfinal); FinalesJump.push_back(contadorfinal); contadorifs++; contadorelse++;contadorfinal++;} ent3 {ifs.escribefin(mainstring,FinalesJump.back()); FinalesJump.pop_back();  } Elsef {}
	| IF compa ')' '{' {  if(encomplejo==0){ comparaciones.compara(mainstring,selectedlog,contadorelse);}  ifs.escribe(mainstring,contadorifs); ELSES.push_back(contadorelse); FINALES.push_back(contadorfinal); FinalesJump.push_back(contadorfinal); contadorifs++; contadorelse++;contadorfinal++;} ent2 '}' {ifs.escribefin(mainstring,FinalesJump.back()); FinalesJump.pop_back(); } Elsef {}
;

Elsef:  {elses.escribeconti(mainstring,FINALES.back()); ELSES.pop_back(); FINALES.pop_back();}
	| ELSE {elses.escribe(mainstring,ELSES.back()); ELSES.pop_back(); } ent3 {elses.escribeconti(mainstring,FINALES.back()); FINALES.pop_back(); } 
	| ELSE '{'{elses.escribe(mainstring,ELSES.back()); ELSES.pop_back(); } ent2 '}' {elses.escribeconti(mainstring,FINALES.back()); FINALES.pop_back(); }
;

Declaracion:  INT ID  Declespe  {variables[*$1]=0; if(enfuncion==1){ contadorlocales++;}else if(enfuncion==0){nodo.reservaglobales(globreserva,*$2);}}
		|ID '=' {DecOrExp=1;} exp {variables[*$1]=$4; if(enfuncion==1){if(locales.find(*$1)!=locales.end()){auto id=new NodoId(*$1); id->nuevaasign(mainstring,contadorlocales,1); locales[*$1]=contadorlocales;fichero<<endl; contadorlocales++;}else if(globales.find(*$1)!=globales.end()){globales[*$1]=$4; auto id=new NodoId(*$1); id->global(mainstring,*$1); fichero<<endl;}}else if(enfuncion==0){globales[*$1]=$4; nodo.reservaglobales(globreserva,*$1); nodo.declaraglobales(globdeclara,*$1,$4);}}
		|INT ID '=' {DecOrExp=1;} exp {variables[*$2]=$5; if(enfuncion==1){auto id=new NodoId(*$1); id->nuevaasign(mainstring,contadorlocales,1); locales[*$2]=contadorlocales;fichero<<endl; contadorlocales++;}else if(enfuncion==0){globales[*$2]=$5; nodo.reservaglobales(globreserva,*$2); nodo.declaraglobales(globdeclara,*$2,$5);}}
		|INT ID '[' NUM ']' 

;
Declespe: 
	|',' ID Declespe {variables[*$2]=0; if(enfuncion==1){ contadorlocales++;}else if(enfuncion==0){nodo.reservaglobales(globreserva,*$2);}}
	|ID { variables[*$1]=0; if(enfuncion==1){ contadorlocales++;}else if(enfuncion==0){nodo.reservaglobales(globreserva,*$1);}}
;
PRINTF: PRINT  cadena  ','{enllamada=1;} dibuj ')' {string s=*$2;  contadorliberaespacio++;  nodo.strings(stringtotales,contadorstrings,s); print.escribe(mainstring,contadorstrings,contadorliberaespacio, cadforprintf);  cadforprintf=""; contadorstrings=1+contadorstrings;contadorliberaespacio=0; enllamada=0;}
	|PRINT   cadena  ')' {string s=*$2;  contadorliberaespacio++; nodo.strings(stringtotales,contadorstrings,s); print.escribe(mainstring,contadorstrings,contadorliberaespacio, ""); contadorliberaespacio=0; contadorstrings=1+contadorstrings;}
;
dibuj: 	{$$=0;}
	| dibuj ',' exp{/*int a=variables[*$3]; IDS.push_back(a); $$=1; print.insertar(cadforprintf,*$3);*/ contadorliberaespacio++;}
	| exp {/*int a=variables[*$1]; IDS.push_back(a); $$=1; print.insertar(cadforprintf,*$1);*/  contadorliberaespacio++;}
;
SCANF: SCAN  cadena  ',' espe ')' {string s=*$2; string devolver=imprimir(s); contadorliberaespacio++; nodo.strings(stringtotales,contadorstrings,s); scan.escribe(mainstring,contadorstrings,contadorliberaespacio, cadforscanf);contadorliberaespacio=0; contadorstrings=1+contadorstrings; cadforscanf="";}
	|SCAN  cadena  ')'{string s=*$2; string devolver=imprimir(s); contadorliberaespacio++; nodo.strings(stringtotales,contadorstrings,s); scan.escribe(mainstring,contadorstrings,contadorliberaespacio, ""); contadorliberaespacio=0; contadorstrings=1+contadorstrings; cadforscanf="";}
;
espe:	{$$=0;}
	| espe ',' '&' ID {int a=variables[*$4]; IDS.push_back(a); $$=1; if(locales.find(*$4)!=locales.end()){int aux=buscarenmap(*$4,locales);scan.insertar(cadforscanf,*$4,aux,1);}else if(globales.find(*$4)!=globales.end()){scan.insertar(cadforscanf,*$4,0,2);} auxscanf.push_back(*$4); contadorscanf=contadorscanf+1; contadorliberaespacio++;}
	| '&' ID {int a=variables[*$2]; IDS.push_back(a); $$=1; if(locales.find(*$2)!=locales.end()){int aux=buscarenmap(*$2,locales);scan.insertar(cadforscanf,*$2,aux,1);}else if(globales.find(*$2)!=globales.end()){scan.insertar(cadforscanf,*$2,0,2);} auxscanf.push_back(*$2); contadorscanf=contadorscanf+1; contadorliberaespacio++;}

;


comp: exp Log { comparaciones.insertar(mainstring);} exp {$$=$2; comparaciones.escribe(mainstring);}
	
;

compa: compa { encomplejo=1;   if(*$1=="=="){comparaciones.especial(mainstring,contadoraux,1);}else if(*$1=="<="){comparaciones.especial(mainstring,contadoraux,2);}else if(*$1==">="){comparaciones.especial(mainstring,contadoraux,3);}else if(*$1=="!="){comparaciones.especial(mainstring,contadoraux,4);}else if(*$1=="<"){comparaciones.especial(mainstring,contadoraux,5);}else if(*$1==">"){comparaciones.especial(mainstring,contadoraux,6);} if(enwhile==1){comparaciones.especialWhile(mainstring,contadorwhiles,1); comparaciones.escribeAUX(mainstring,contadoraux);}else{comparaciones.especialWhile(mainstring,contadorifs,2); comparaciones.escribeAUX(mainstring,contadoraux);} contadoraux++;} OR compara {if(*$4=="=="){if(enwhile==1){nwhile.compara(mainstring,1,contadorfinal);}else{comparaciones.compara(mainstring,1,contadorelse);}}else if(*$4=="<="){if(enwhile==1){nwhile.compara(mainstring,2,contadorfinal);}else{comparaciones.compara(mainstring,2,contadorelse);}}else if(*$4==">="){if(enwhile==1){nwhile.compara(mainstring,3,contadorfinal);}else{comparaciones.compara(mainstring,3,contadorelse);}}else if(*$4=="!="){if(enwhile==1){nwhile.compara(mainstring,4,contadorfinal);}else{comparaciones.compara(mainstring,4,contadorelse);}}else if(*$4=="<"){if(enwhile==1){nwhile.compara(mainstring,5,contadorfinal);}else{comparaciones.compara(mainstring,5,contadorelse);}}else if(*$4==">"){if(enwhile==1){nwhile.compara(mainstring,6,contadorfinal);}else{comparaciones.compara(mainstring,6,contadorelse);}}}
	|compara {$$=$1;}
;
compara: compara{encomplejo=1;    if(*$1=="=="){if(enwhile==1){nwhile.compara(mainstring,1,contadorfinal);}else{comparaciones.compara(mainstring,1,contadorelse);}}else if(*$1=="<="){if(enwhile==1){nwhile.compara(mainstring,2,contadorfinal);}else{comparaciones.compara(mainstring,2,contadorelse);}}else if(*$1==">="){if(enwhile==1){nwhile.compara(mainstring,3,contadorfinal);}else{comparaciones.compara(mainstring,3,contadorelse);}}else if(*$1=="!="){if(enwhile==1){nwhile.compara(mainstring,4,contadorfinal);}else{comparaciones.compara(mainstring,4,contadorelse);}}else if(*$1=="<"){if(enwhile==1){nwhile.compara(mainstring,5,contadorfinal);}else{comparaciones.compara(mainstring,5,contadorelse);}}else if(*$1==">"){if(enwhile==1){nwhile.compara(mainstring,6,contadorfinal);}else{comparaciones.compara(mainstring,6,contadorelse);}}} AND comparacion { if(*$4=="=="){if(enwhile==1){nwhile.compara(mainstring,1,contadorfinal);}else{comparaciones.compara(mainstring,1,contadorelse);}}else if(*$4=="<="){if(enwhile==1){nwhile.compara(mainstring,2,contadorfinal);}else{comparaciones.compara(mainstring,2,contadorelse);}}else if(*$4==">="){if(enwhile==1){nwhile.compara(mainstring,3,contadorfinal);}else{comparaciones.compara(mainstring,3,contadorelse);}}else if(*$4=="!="){if(enwhile==1){nwhile.compara(mainstring,4,contadorfinal);}else{comparaciones.compara(mainstring,4,contadorelse);}}else if(*$4=="<"){if(enwhile==1){nwhile.compara(mainstring,5,contadorfinal);}else{comparaciones.compara(mainstring,5,contadorelse);}}else if(*$4==">"){if(enwhile==1){nwhile.compara(mainstring,6,contadorfinal);}else{comparaciones.compara(mainstring,6,contadorelse);}}}
	|comparacion {$$=$1;}
;
comparacion: NOT {encomplejo=1;} comparacion {$$=$3;}
		|comp {$$=$1; if(*$1=="=="){selectedlog=1;}else if(*$1=="<="){selectedlog=2;}else if(*$1==">="){selectedlog=3;}else if(*$1=="!="){selectedlog=4;}else if(*$1=="<"){selectedlog=5;}else if(*$1==">"){selectedlog=6;}}
		|'(' compa ')' {}
;



exp: exp{if(enllamada==1){}else{suma.escribepush(mainstring);}fichero<<endl; } '+' term {$$=$1+$4;  suma=*(new NodoSuma($1,$4)); suma.escribe(mainstring); if(enllamada==1){call.insertarnum(mainstring,$1);} fichero<<endl;}
	|exp{if(enllamada==1){}else{suma.escribepush(mainstring);}fichero<<endl; } '-' term {$$=$1-$4; resta=*(new NodoResta($1,$4)); resta.escribe(mainstring);if(enllamada==1){call.insertarnum(mainstring,$1);} fichero<<endl;}
	|term	{$$=$1; if(enllamada==1){call.insertarnum(mainstring,$1);}}
;

term: term {multi.escribepush(mainstring); fichero<<endl; } '*' fact {$$=$1*$4; multi=*(new NodoMul($1,$4)); multi.escribe(mainstring);   fichero<<endl;}
	|term {divi.escribepush(mainstring); fichero<<endl; } '/' fact {$$=$1/$4;  divi=*(new NodoDiv($1,$4)); divi.escribe(mainstring);  fichero<<endl;}
	|fact {$$=$1;}
;
fact: NUM {$$=$1; /*if(enllamada==1){call.insertarnum(mainstring,$1);}else */if (enfuncion==1 && retu!=1 ){auto num=new NodoNum($1); num->escribe(mainstring); fichero<<endl;}}
	|'-' NUM {$$=-$2; /*if(enllamada==1){call.insertarnum(mainstring,-$2);} else*/ if (enfuncion==1 && retu!=1 ){auto num=new NodoNum(-$2); num->escribe(mainstring); fichero<<endl;}}
	|'(' exp ')' {$$=$2;}
	|ID {/*varint a=buscar($1); $$=a.nu;*/ $$=variables[*$1];/*if(enllamada==1){if(locales.find(*$1)!=locales.end()){int aux=buscarenmap(*$1,locales); call.insertar(mainstring,aux,1,"");}else if(parametros.find(*$1)!=parametros.end()){int aux=buscarenmap(*$1,parametros); call.insertar(mainstring,aux,2,"");}else if(globales.find(*$1)!=globales.end()){int aux=buscarenmap(*$1,globales);auto id=new NodoId(*$1); call.insertar(mainstring,aux,3,*$1);}
}else*/ if(enfuncion==1){if(locales.find(*$1)!=locales.end()){int aux=buscarenmap(*$1,locales);auto id=new NodoId(*$1); id->escribe(mainstring,1,aux); fichero<<endl;}else if(parametros.find(*$1)!=parametros.end()){int aux=buscarenmap(*$1,parametros);auto id=new NodoId(*$1); id->escribe(mainstring,2,aux); fichero<<endl;}else if(globales.find(*$1)!=globales.end()){int aux=buscarenmap(*$1,globales);auto id=new NodoId(*$1); id->escribe(mainstring,3,aux);}}
}
	|CALL{enllamada=1;} especialcall ')' {string cadena=*$1; string aux=cadena.substr(0,cadena.find("(")); aux.erase(std::remove(aux.begin(),aux.end(),' '),aux.end()); enllamada=0; call.escribellamada(mainstring,llamada,aux,contadorllamadas);	contadorllamadas=0; llamada="";}
;
especialcall:
		|especialcall ',' exp { contadorllamadas++;}
		|exp { contadorllamadas++;}
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

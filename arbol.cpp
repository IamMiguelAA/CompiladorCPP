#include <string>
#include <cstring>
#include <iostream>
#include <typeinfo>
#include "arbol.h"
using namespace Tree;
using namespace std;



Tree::NodoId::NodoId(string str){
	name=str;
}

Tree::NodoNum::NodoNum(int num){
value=num;
}

Tree::NodoSuma::NodoSuma(int x,int y){
	var1=x;
	var2=y;
}

Tree::NodoResta::NodoResta(int x, int y){
	var1=x;
	var2=y;
}

Tree::NodoMul::NodoMul(int x, int y){
	var1=x;
	var2=y;
}

Tree::NodoDiv::NodoDiv(int x,int y){
	var1=x;
	var2=y;
}


//Write in a file

void Tree::Node::finalWrite(std::fstream &file, std::string mainstring){
	file<<mainstring<<endl;
}

void Tree::Node::stringfile(std::fstream &file, std::string mainstring){
	file<<mainstring<<endl;
}
void Tree::Node::strings(std::string &strings,int contador,std::string mainstring){
	strings+=".LC"+to_string(contador)+"\n"+"		.string"+mainstring+"\n";
}
void Tree::Node::reservaglobales(std::string &globales,string texto){
	globales+=".comm	"+texto+",4,4\n";
}
void Tree::Node::declaraglobales(std::string &glob,string texto,int valor){
	glob+=texto+":\n"+"		.long	"+to_string(valor)+"\n";
}
void Tree::Node::globalesfile(std::fstream &file,string texto){
	file<<texto<<endl;
}

void Tree::NodoId::escribe(string &mainstring,int cont,int contador=0){
	switch(cont){
		case 1:
			int valor;
			valor=4+4*contador;
			mainstring=mainstring+"movl  -"+to_string(valor)+"(%ebp),%eax\n";
			break;
		case 2:
			int entero;
			entero=8+4*contador;
			mainstring=mainstring+"movl "+to_string(entero)+"(%ebp),%eax\n";
			break;
		case 3:
			mainstring=mainstring+"movl "+name+", %eax\n";
			break;
	}
}

void::Tree::NodoId::nuevaasign(string &mainstring,int contador,int cont){
	switch(cont){
		case 1:
			int valor;
			valor=4+4*contador;
			mainstring=mainstring+"movl %eax, -"+to_string(valor)+"(%ebp)\n";
			break;

	}
	
}
void::Tree::NodoId::global(string &mainstring,string texto){
	mainstring+="movl	%eax,	"+texto;
}

void Tree::NodoNum::escribe(string &mainstring){
	string str1="$"+to_string(value);
	mainstring+="movl "+str1+", %eax\n";
}

void Tree::NodoSuma::escribepush(string &mainstring){
	mainstring+="pushl %eax\n";
}

void Tree::NodoResta::escribepush(string &mainstring){
	mainstring+="pushl %eax\n";
}

void Tree::NodoMul::escribepush(string &mainstring){
	mainstring+="pushl %eax\n";
}

void Tree::NodoDiv::escribepush(string &mainstring){
	mainstring+="pushl %eax\n";
}

void Tree::NodoSuma::escribe(string &mainstring){
	mainstring+="movl %eax, %ebx\npopl %eax\naddl %ebx, %eax\n";
}

void Tree::NodoResta::escribe(string &mainstring){
	mainstring+="movl %eax, %ebx\npopl %eax\nsubl %ebx, %eax\n";
}

void Tree::NodoMul::escribe(string &mainstring){
	mainstring+="movl %eax, %ebx\npopl %eax\nimull %ebx, %eax\n";
}

void Tree::NodoDiv::escribe(string &mainstring){
	mainstring+="movl %eax, %ebx\npopl %eax\ncdq\ndivl %ebx\n";
}

void Tree::NodoPrintf::insertar(string &cadforprintf,string cadena){
	cadforprintf="pushl  "+cadena+"\n"+cadforprintf;
}

void Tree::NodoPrintf::escribe(string &mainstring,int cont,int contador, string cadforprintf){
	mainstring=mainstring+"\n"+cadforprintf+"pushl $.LC"+to_string(cont)+"\n"+"call printf"+"\n"+"addl $"+to_string(4*contador)+", %esp"+"\n";
}

void Tree::NodoScanf::insertar(string &cadforprintf,string cadena,int contador,int cont){
	switch(cont){
		case 1:
			cadforprintf="leal	-"+to_string(4+4*contador)+"(%ebp),	%eax\n"+"pushl	%eax\n"+cadforprintf;
			break;
		case 2:
			cadforprintf="pushl  $"+cadena+"\n"+cadforprintf;
			break;
}
}

void Tree::NodoScanf::escribe(string &mainstring,int cont,int contador, string cadforprintf){
	mainstring+="\n"+cadforprintf+"pushl $.LC"+to_string(cont)+"\n"+"call scanf"+"\n"+"addl $"+to_string(4*contador)+", %esp"+"\n";
}

void Tree::NodoFunc::escribeini(string &mainstring,string nombre){
	mainstring=".text\n.globl "+nombre+"\n.type "+nombre+", @function\n"+nombre+":\n"+"pushl %ebp\nmovl %esp, %ebp\n\n"+mainstring;
	
}
void Tree::NodoFunc::reservaespacio(string &mainstring,int contador){
	mainstring="subl	$"+to_string(4*contador)+",	%esp\n"+mainstring;
}
void Tree::NodoFunc::escribefin(string &mainstring){
	mainstring+="movl %ebp, %esp\npopl %ebp\nret\n\n";
}
void Tree::NodoFunc::ReverseFile(string &mainGlobal,string mainstring){
	mainGlobal+=mainstring+"\n";
}
void Tree::NodoFunc::escriberet(string &mainstring,int a){
	mainstring+="movl $"+to_string(a)+", %eax\n";
}
void Tree::NodoFunc::escriberet(string &mainstring,string a){
	mainstring+="movl "+a+"\n"+", %eax\n";
}

void Tree::NodoCall::insertar(string &mainstring,int contador,int cont,string aux){
	switch(cont){
		case 1:
			int valor;
			valor=4+4*contador;
			mainstring+="pushl  -"+to_string(valor)+"(%ebp)\n";
			break;
		case 2:
			int entero;
			entero=8+4*contador;
			mainstring+="pushl   "+to_string(entero)+"(%ebp)\n";
			break;
		case 3:
			mainstring+="pushl	 "+aux+"\n";
	}
}
void Tree::NodoCall::insertarnum(string &mainstring,int value){
	mainstring+="pushl %eax\n";
}
void Tree::NodoCall::escribellamada(string &mainstring,string callstring,string func,int contador){
	mainstring+=callstring+"\ncall "+func+"\naddl  $"+to_string(4*contador)+",	%esp\n";
}

void Tree::NodoComp::insertar(string &mainstring){
	mainstring+="pushl	%eax\n";
}

void Tree::NodoComp::escribe(string &mainstring){
	mainstring+="movl	%eax,	%ebx\npopl	%eax\ncmpl	%eax,	%ebx\n";
}
void Tree::NodoComp::compara(string &mainstring,int cont,int contador){
	switch(cont){
		case 1:
			mainstring+="jne  ELSE"+to_string(contador)+"\n";
			break;
		case 2:
			mainstring+="jg  ELSE"+to_string(contador)+"\n";
			break;
		case 3:
			mainstring+="jl  ELSE"+to_string(contador)+"\n";
			break;
		case 4:
			mainstring+="je  ELSE"+to_string(contador)+"\n";
			break;
		case 5:
			mainstring+="jge  ELSE"+to_string(contador)+"\n";
			break;
		case 6:
			mainstring+="jle  ELSE"+to_string(contador)+"\n";
			break;

	}
}
void Tree::NodoComp::especial(string &mainstring,int contador,int cont){
	switch(cont){
		case 1:
			mainstring+="jne  AUX"+to_string(contador)+"\n";
			break;
		case 2:
			mainstring+="jg  AUX"+to_string(contador)+"\n";
			break;
		case 3:
			mainstring+="jl  AUX"+to_string(contador)+"\n";
			break;
		case 4:
			mainstring+="je  AUX"+to_string(contador)+"\n";
			break;
		case 5:
			mainstring+="jge  AUX"+to_string(contador)+"\n";
			break;
		case 6:
			mainstring+="jle  AUX"+to_string(contador)+"\n";
			break;

	}
}
void Tree::NodoComp::especialWhile(string &mainstring,int contador,int cont){
	switch(cont){
		case 1:
			mainstring+="jmp	While"+to_string(contador)+"\n";
			break;
		case 2:
			mainstring+="jmp	IF"+to_string(contador)+"\n";
			break;
	}
}
void Tree::NodoComp::escribeAUX(string &mainstring,int contador){
	mainstring+="AUX"+to_string(contador)+":\n";
}
void Tree::NodoIF::escribe(string &mainstring,int contador){
	mainstring+="IF"+to_string(contador)+":\n";
}
void Tree::NodoIF::escribefin(string &mainstring,int contador){
	mainstring+="jmp	FINAL"+to_string(contador)+"\n";
}
void Tree::NodoELSE::escribe(string &mainstring,int contador){
	mainstring+="ELSE"+to_string(contador)+":\n";
}
void Tree::NodoELSE::escribeconti(string &mainstring,int contador){
	mainstring+="FINAL"+to_string(contador)+":\n";
}
void Tree::NodoWhile::escribeini(string &mainstring,int contador){
	mainstring+="While"+to_string(contador)+":\n";
}
void Tree::NodoWhile::escribefin(string &mainstring,int contador,int contador2){
	mainstring+="jmp	While"+to_string(contador)+"\nFINAL"+to_string(contador2)+":\n";
}
void Tree::NodoWhile::compara(string &mainstring,int cont,int contador){
	switch(cont){
		case 1:
			mainstring+="jne  FINAL"+to_string(contador)+"\n";
			break;
		case 2:
			mainstring+="jg  FINAL"+to_string(contador)+"\n";
			break;
		case 3:
			mainstring+="jl  FINAL"+to_string(contador)+"\n";
			break;
		case 4:
			mainstring+="je  FINAL"+to_string(contador)+"\n";
			break;
		case 5:
			mainstring+="jge  FINAL"+to_string(contador)+"\n";
			break;
		case 6:
			mainstring+="jle  FINAL"+to_string(contador)+"\n";
			break;

	}
}


//Checkeo de tipos

	int Tree::Tipos::check_literal(string asignando){
		int resultado;
		//if(asignando.compare(to_string(atoi(asignando.c_str())))!=0)
		resultado=atoi(asignando.c_str());
		return resultado;
	}

	bool Tree::Tipos::check_tipos_func(std::string elemento, std::string asignando){
		if(elemento.compare(asignando)!=0){
			cout<<"Intentando asignar a un "<<elemento<<" una funcion "<<asignando<<"."<<endl; 
			exit(0);
		}
		return 0;
	}
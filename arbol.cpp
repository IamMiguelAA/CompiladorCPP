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

void Tree::Node::stringfile(std::fstream &file, int numstring, std::string mainstring){
	file<<".LC"<<numstring<<endl;
	file<<".string "<<mainstring<<"\""<<endl<<endl;
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

void::Tree::NodoId::nuevaasign(string &mainstring,int contador){
	int valor;
	valor=4+4*contador;
	mainstring=mainstring+"movl %eax, -"+to_string(valor)+"(%ebp)\n";
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

void Tree::NodoScanf::insertar(string &cadforprintf,string cadena){
	cadforprintf="pushl  "+cadena+"\n"+cadforprintf;
}

void Tree::NodoScanf::escribe(string &mainstring,int cont,int contador, string cadforprintf){
	mainstring+="\n"+cadforprintf+"pushl $.LC"+to_string(cont)+"\n"+"call scanf"+"\n"+"addl $"+to_string(4*contador)+", %esp"+"\n";
}

void Tree::NodoFunc::escribeini(string &mainstring,string nombre){
	mainstring+=".text\n.globl "+nombre+"\n.type "+nombre+", @function\n"+nombre+":\n";
	mainstring+="pushl %ebp\nmovl %esp, %ebp\n\n";
}

void Tree::NodoFunc::escribefin(string &mainstring){
	mainstring+="movl %ebp, %esp\npopl %ebp\nret\n\n";
}

void Tree::NodoFunc::escriberet(string &mainstring,int a){
	mainstring+="movl $"+to_string(a)+", %eax\n";
}
void Tree::NodoFunc::escriberet(string &mainstring,string a){
	mainstring+="movl "+a+"\n"+", %eax\n";
}

void Tree::NodoCall::insertar(string &mainstring,int contador,int cont){
	switch(cont){
		case 1:
			int valor;
			valor=4+4*contador;
			mainstring="pushl  -"+to_string(valor)+"(%ebp)\n"+mainstring;
			break;
		case 2:
			int entero;
			entero=8+4*contador;
			mainstring="pushl   "+to_string(entero)+"(%ebp)\n"+mainstring;
			break;
	}
}
void Tree::NodoCall::insertarnum(string &mainstring,int value){
	mainstring="pushl	$"+to_string(value)+"\n"+mainstring;
}
void Tree::NodoCall::escribellamada(string &mainstring,string callstring,string func,int contador){
	mainstring+=callstring+"\ncall "+func+"\naddl  $"+to_string(4*contador)+",	%esp\n";
}
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
	file<<".string \""<<mainstring<<"\""<<endl<<endl;
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
	cout<<"hola1"<<endl;
	cout<<cadforprintf<<endl;
}

void Tree::NodoPrintf::escribe(string &mainstring,int cont,int contador, string cadforprintf){
	mainstring=mainstring+"\n"+cadforprintf+"pushl $.LC"+to_string(cont)+"\n"+"call printf"+"\n"+"addl $"+to_string(4*contador)+", %esp"+"\n";
	cout<<"hola2"<<endl;
	cout<<mainstring<<endl;
}

void Tree::NodoScanf::insertar(string &cadforprintf,string cadena){
	cadforprintf="pushl  "+cadena+"\n"+cadforprintf;
}

void Tree::NodoScanf::escribe(string &mainstring,int cont,int contador, string cadforprintf){
	mainstring+="\n"+cadforprintf+"pushl $.LC"+to_string(cont)+"\n"+"call scanf"+"\n"+"addl $"+to_string(4*contador)+", %esp"+"\n";
}

void Tree::NodoFunc::escribeini(fstream &file,string nombre){
	file<<nombre<<":"<<endl;
	file<<"pushl %ebp\n"<<"movl %esp, %ebp\n"<<endl;

}

void Tree::NodoFunc::escribefin(fstream &file){
	file<<"\nmovl %ebp, %esp"<<"\npopl %ebp\nret\n"<<endl;
}

void Tree::NodoFunc::escriberet(fstream &file,int a){
	file<<"movl	$"<<a<<",	%eax"<<endl;
}
void Tree::NodoFunc::escriberet(fstream &file,string a){
	file<<"movl	"<<a<<",	%eax"<<endl;
}
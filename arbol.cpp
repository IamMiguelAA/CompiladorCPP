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
void Tree::NodoId::escribe(fstream &file,int cont,int contador=0){
	switch(cont){
		case 1:
			int valor;
			valor=4+4*contador;
			file<<"movl  -"<<valor<<"(%ebp),	%eax"<<endl;
		case 2:
			int entero;
			entero=8+4*contador;
			file<<"movl "<<entero<<"(%ebp),		%eax"<<endl;
			break;
		case 3:
			file<<"movl "<<name<<", %eax"<<endl;
			break;


}
}

void Tree::NodoNum::escribe(fstream &file){
	string str1="$"+to_string(value);
	file<<"movl "<<str1<<", %eax"<<endl;
}
void Tree::NodoSuma::escribepush(fstream &file){
	file<<"pushl %eax"<<endl;
}
void Tree::NodoResta::escribepush(fstream &file){
	file<<"pushl %eax"<<endl;
}
void Tree::NodoMul::escribepush(fstream &file){
	file<<"pushl %eax"<<endl;
}
void Tree::NodoDiv::escribepush(fstream &file){
	file<<"pushl %eax"<<endl;
}
void Tree::NodoSuma::escribe(fstream &file){
file<<"movl %eax, %ebx"<<endl;
file<<"popl %eax"<<endl;
file<<"addl %ebx, %eax"<<endl;
}

void Tree::NodoResta::escribe(fstream &file){
file<<"movl %eax, %ebx"<<endl;
file<<"popl %eax"<<endl;
file<<"subl %ebx, %eax"<<endl;
}

void Tree::NodoMul::escribe(fstream &file){
file<<"movl %eax, %ebx"<<endl;
file<<"popl %eax"<<endl;
file<<"imull %ebx, %eax"<<endl;
}

void Tree::NodoDiv::escribe(fstream &file){
file<<"movl %eax, %ebx"<<endl;
file<<"popl %eax"<<endl;
file<<"cdq"<<endl;
file<<"divl %ebx"<<endl;
}

void Tree::NodoPrintf::insertar(fstream &file,string cadena){
	file<<"pushl  "<<cadena<<endl;
}

void Tree::NodoPrintf::escribe(fstream &file,int cont,int contador){
	file<<"pushl $s"<<cont<<endl;
	file<<"call printf"<<endl;
	file<<"addl $"<<4*contador<<",	%esp"<<endl;
	file<<endl;
}

void Tree::NodoScanf::insertar(fstream &file,string cadena){
	file<<"pushl  $"<<cadena<<endl;
}

void Tree::NodoScanf::escribe(fstream &file,int cont,int contador){
	file<<"pushl $s"<<cont<<endl;
	file<<"call scanf"<<endl;
	file<<"addl $"<<4*contador<<",	%esp"<<endl;
	file<<endl;
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
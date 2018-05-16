#ifndef ARBOL_H
#define ARBOL_H
#include <iostream>
#include <fstream>
#include <string>
namespace Tree {
class Node{
public:
Node(void){}
virtual void escribe(int level, bool old, bool ne){}
};
class InternalNode: public Node{
char label;
Node *pn1;
Node *pn2;
public:
InternalNode(int, Node*, Node*);
void escribe(int level, bool old, bool ne);
};
class UniqueNode : public Node{
char label;
Node* pn1;
public:
UniqueNode(int, Node*);
void escribe(int level, bool old, bool ne);
};
class NodoId: public Node{
std::string name;
public:
NodoId(std::string);
void escribe(std::fstream &,int,int);
};
class NodoNum: public Node{
int value;
public:
NodoNum(int);
void escribe(std::fstream &);
};
class NodoSuma: public Node{
int var1=0,var2=0;
public:
NodoSuma(){}
NodoSuma(int ,int );
NodoSuma& operator= (const NodoSuma& X){var1=X.var1; var2=X.var2; return *this;}
void escribepush(std::fstream &);
void escribe(std::fstream &);
};
class NodoResta: public Node{
int var1,var2;
public:
NodoResta(){}
NodoResta(int,int);
NodoResta& operator= (const NodoResta& X){var1=X.var1; var2=X.var2; return *this;}
void escribepush(std::fstream &);
void escribe(std::fstream &);
};
class NodoMul: public Node{
int var1,var2;
public:
NodoMul(){}
NodoMul(int,int);
NodoMul& operator= (const NodoMul& X){var1=X.var1; var2=X.var2; return *this;}
void escribepush(std::fstream &);
void escribe(std::fstream &);
};
class NodoDiv: public Node{
int var1,var2;
public:
NodoDiv(){}
NodoDiv(int,int);
NodoDiv& operator= (const NodoDiv& X){var1=X.var1; var2=X.var2; return *this;}
void escribepush(std::fstream &);
void escribe(std::fstream &);
};
class NodoPrintf: public Node{
std::string cadena;
public:
NodoPrintf(){}
void insertar(std::fstream &,std::string);
void escribe(std::fstream &,int ,int );


};
class NodoScanf: public Node{
std::string cadena;
public:
NodoScanf(){}
void insertar(std::fstream &,std::string);
void escribe(std::fstream &,int , int );


};
class NodoFunc: public Node{

public:
NodoFunc(){}
void escribeini(std::fstream &,std::string );
void escribefin(std::fstream &);
void escriberet(std::fstream &,std::string);
void escriberet(std::fstream &,int);

};

const int Max = 80;
char* esp
(int level, bool old, bool ne);
} //end namespace “Tree”

namespace Errors{
struct TokenError{
std::string message;
int ActToken;
std::string lexema;
TokenError(std::string msg, int ta, std::string lex);
};
struct NoCuadra{
int LookedForToken;
int ActToken;
std::string lexema;
NoCuadra(int t, int ta, std::string lex);
};
} // End of namespace “Errors”

#endif

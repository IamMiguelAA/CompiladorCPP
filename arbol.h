#ifndef ARBOL_H
#define ARBOL_H
#include <iostream>
#include <fstream>
#include <string>

namespace Tree {

	class Node{
		public:
			Node(void){}
			void finalWrite(std::fstream &file, std::string mainstring);
			void stringfile(std::fstream &file,  std::string mainstring);
			void strings(std::string &,int,std::string);
			void reservaglobales(std::string &,std::string);
			void declaraglobales(std::string &,std::string,int);
			void globalesfile(std::fstream &,std::string);

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
			void nuevaasign(std::string &,int,int);
			void escribe(std::string &,int,int);
	};


	class NodoNum: public Node{
		int value;
		public:
			NodoNum(int);
			void escribe(std::string &);
	};


	class NodoSuma: public Node{
		int var1=0,var2=0;
		public:
			NodoSuma(){}
			NodoSuma(int ,int );
			NodoSuma& operator= (const NodoSuma& X){var1=X.var1; var2=X.var2; return *this;}
			void escribepush(std::string &);
			void escribe(std::string &);
	};


	class NodoResta: public Node{
		int var1,var2;
		public:
			NodoResta(){}
			NodoResta(int,int);
			NodoResta& operator= (const NodoResta& X){var1=X.var1; var2=X.var2; return *this;}
			void escribepush(std::string &);
			void escribe(std::string &);
	};


	class NodoMul: public Node{
		int var1,var2;
		public:
			NodoMul(){}
			NodoMul(int,int);
			NodoMul& operator= (const NodoMul& X){var1=X.var1; var2=X.var2; return *this;}
			void escribepush(std::string &);
			void escribe(std::string &);
	};


	class NodoDiv: public Node{
		int var1,var2;
		public:
			NodoDiv(){}
			NodoDiv(int,int);
			NodoDiv& operator= (const NodoDiv& X){var1=X.var1; var2=X.var2; return *this;}
			void escribepush(std::string &);
			void escribe(std::string &);
	};
	

	class NodoPrintf: public Node{
		std::string cadena;
		public:
			NodoPrintf(){}
			void insertar(std::string &,std::string);
			void escribe(std::string &,int ,int, std::string );
	};


	class NodoScanf: public Node{
		std::string cadena;
		public:
			NodoScanf(){}
			void insertar(std::string &,std::string,int ,int);
			void escribe(std::string &,int ,int, std::string );
	};


	class NodoFunc: public Node{
		public:
			NodoFunc(){}
			void escribeini(std::string &,std::string );
			void escribefin(std::string &);
			void escriberet(std::string &,std::string);
			void escriberet(std::string &,int);
			void reservaespacio(std::string &,int);
			void ReverseFile(std::string &,std::string );
	};

	
	class NodoCall: public Node{
	public:
		NodoCall(){}
		void escribellamada(std::string &,std::string,std::string,int);
		void insertar(std::string &,int, int,std::string);
		void insertarnum(std::string &,int);
	};

	const int Max = 80;
	char* esp (int level, bool old, bool ne);
}

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
}

#endif

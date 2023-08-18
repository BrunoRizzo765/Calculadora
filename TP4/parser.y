%{

#include <stdio.h>

#include "scanner.h"



void yyerror(char const *s);

%}



%define parse.error verbose



%defines "parser.h"

%output "parser.c"

%start programa



%union{

	double numero;

	char *cadena;

}



%token <cadena> ID VAR CTE FUNC

%token NL ERRORIDENTIFICADOR ERRORNUMERO SALIR ERROR

%token <numero> NUM

%token MASIGUAL "+="

%token MENOSIGUAL "-="

%token PORIGUAL "*="

%token DIVIDIRIGUAL "/="



%right '=' MASIGUAL MENOSIGUAL PORIGUAL DIVIDIRIGUAL

%left '+' '-'

%left '*' '/'

%precedence NEG

%right '^'



%%



programa:

		| programa linea

		;



linea: NL

		| expresion NL						{printf("EXPRESION\n");}

		| asignacion NL

		| SALIR NL 							{printf("SALIR\n");}

		| error NL							{printf("ERROR\n");}

		| ERRORIDENTIFICADOR NL				{printf("ERRORIDENTIFICADOR\n");}

		| ERRORNUMERO NL					{printf("ERRORNUMERO\n");}

		| ERROR NL							{printf("ERROR\n");}

		;



asignacion: VAR ID							{printf("Define ID como variable\n");}

		| VAR ID '=' expresion				{printf("Define ID como variable con valor inicial\n");}	

		| CTE ID '=' expresion				{printf("Define ID como constante\n");}

		| ID '=' expresion					{printf("ASIGNACION\n");}

		| ID MASIGUAL expresion				{printf("Asignación con suma\n");}

		| ID MENOSIGUAL expresion			{printf("Asignación con resta\n");}

		| ID PORIGUAL expresion				{printf("Asignación con multiplicacion\n");}

		| ID DIVIDIRIGUAL expresion			{printf("Asignación con division\n");}

		;



expresion: NUM								{printf("NUMERO\n");}

		| ID								{printf("ID\n");}

		| expresion '+' expresion			{printf("SUMA\n");}

		| expresion '-' expresion			{printf("RESTA\n");}

		| expresion '*' expresion			{printf("MULTIPLICACION\n");}

		| expresion '/' expresion			{printf("DIVISION\n");}

		| expresion '^' expresion			{printf("POTENCIACION\n");}

		| '-' expresion %prec NEG			{printf("NEGATIVO\n");}

		| FUNC '(' expresion ')'			{printf("FUNCION\n");}

		| '(' expresion ')'					{printf("ENTRE PARENTESIS\n");}

		;



%%



void yyerror (char const *s)

{

  fprintf (stderr, "%s\n", s);

}



int yywrap(){

	return 1;

}














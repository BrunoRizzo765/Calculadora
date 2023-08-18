%{

  #include <stdio.h>

  #include <stdlib.h>

  #include <math.h>

  #include "scanner.h"

  #include "calc.h"

  

  int yylex (void);

  void yyerror (char const *);

  

  symrec* aux;

  

  int tipoDeIdentificador(symrec* aux){

	if (aux) {

		return (aux->type);

	}

	return NO_DECLARADO;

  }

  

%}



%defines "parser.h"

%output "parser.c"



%define parse.error verbose



%union {

  double numero;

  char*  cadena;

}



%token <numero>  NUMERO      

%token <cadena> IDENTIFICADOR

%type <numero> expresion

%type <numero> asignacion



%token SALIR

%token VAR

%token CTE

%token MASIGUAL

%token MENOSIGUAL

%token PORIGUAL

%token DIVIDIRIGUAL



%right '=' MASIGUAL MENOSIGUAL PORIGUAL DIVIDIRIGUAL

%left '+' '-'

%left '*' '/'

%precedence NEG

%right '^'



%%



calculadora:

  %empty

| calculadora lineaCalculadora

;



lineaCalculadora:

  '\n'

| expresion '\n'   {printf("%f\n\n", $1);}

| asignacion '\n' 

| error '\n'

| SALIR '\n'	   {printf("Salir\n");exit(0);}

;



asignacion:

  VAR IDENTIFICADOR			{ aux=getsym($<cadena>2); if (aux) {printf("Error, %s ya esta declarada\n\n", $2);YYERROR;} else {printf("%s:0\n\n", $2); aux=putsym(strdup($2),TIPO_VAR); $$=(aux->value.var) ;} }	

| VAR IDENTIFICADOR '=' expresion	{ aux=getsym($<cadena>2); if (aux) {printf("Error, %s ya esta declarada\n\n", $2);YYERROR;} else {printf("%s:%f \n\n",$2,$4);

					aux=putsym(strdup($2),TIPO_VAR); $$=(aux->value.var)=$4 ;} }

| CTE IDENTIFICADOR            {aux=getsym($<cadena>2); switch(tipoDeIdentificador(aux)) {

		case TIPO_FUN: printf("Error: unexpected FUN, expexting ID\n\n");YYERROR;

		default: printf("Error: La inicializacion de una constante es obligatoria \n\n");YYERROR;

		} }

| CTE IDENTIFICADOR '=' expresion	{ aux=getsym($<cadena>2); if (aux) {printf("Error, %s ya esta declarada\n\n", $2);YYERROR;} else {printf("%s:%f \n\n",$2,$4); aux=putsym(strdup($2),TIPO_CTE); $$=(aux->value.cte)=$4 ;} }

;





expresion:   

  NUMERO				{ $$ = $1;						  }

| IDENTIFICADOR   			{ aux=getsym($<cadena>1); if (aux) {$$=(aux->value.var);} else {printf("Error: ID %s no esta declarado\n\n", $1); YYERROR;} }

| IDENTIFICADOR MASIGUAL expresion	{aux=getsym($<cadena>1); switch(tipoDeIdentificador(aux)) {

		case TIPO_VAR: $$ = aux->value.var += $3; break;

		case TIPO_FUN: printf("Error: ID que intenta modificar es una funcion\n\n");YYERROR;

		case TIPO_CTE: printf("Error: ID que intenta modificar es de tipo constante\n\n");YYERROR;

		default: printf("ERROR: ID no esta declarado\n\n");YYERROR;

		} }

| IDENTIFICADOR MENOSIGUAL expresion	{aux=getsym($<cadena>1); switch(tipoDeIdentificador(aux)) {

		case TIPO_CTE: printf("Error: ID que intenta modificar es de tipo constante\n\n");YYERROR;

		case TIPO_VAR: $$ = aux->value.var -= $3;break;

		case TIPO_FUN: printf("Error: ID que intenta modificar es una funcion\n\n");YYERROR;

		default: printf("ERROR: ID no esta declarado\n\n");YYERROR;

		} }

| IDENTIFICADOR PORIGUAL expresion	{aux=getsym($<cadena>1); switch(tipoDeIdentificador(aux)) {

		case TIPO_CTE: printf("Error: ID que intenta modificar es de tipo constante\n\n");YYERROR;

		case TIPO_VAR: $$ = aux->value.var *= $3;break;

		case TIPO_FUN: printf("Error: ID que intenta modificar es una funcion\n\n");YYERROR;

		default: printf("ERROR: ID no esta declarado\n\n");YYERROR;

		} }

| IDENTIFICADOR DIVIDIRIGUAL expresion	{aux=getsym($<cadena>1); switch(tipoDeIdentificador(aux)) {

		case TIPO_CTE: printf("Error: ID que intenta modificar es de tipo constante\n\n");YYERROR;

		case TIPO_VAR: $$ = aux->value.var /= $3;break;

		case TIPO_FUN: printf("Error: ID que intenta modificar es una funcion\n\n");YYERROR;

		default: printf("ERROR: ID no esta declarado\n\n");YYERROR;

		} }

| IDENTIFICADOR '=' expresion		{aux=getsym($<cadena>1); switch(tipoDeIdentificador(aux)) {

		case TIPO_CTE: printf("Error: ID que intenta modificar es de tipo constante\n\n");YYERROR;

		case TIPO_VAR: $$ = aux->value.var = $3;break;

		case TIPO_FUN: printf("Error: ID que intenta modificar es una funcion\n\n");YYERROR;

		default: printf("ERROR: ID no esta declarado\n\n");YYERROR;

		} }

| expresion '+' expresion        	{ $$ = $1 + $3;						  }

| expresion '-' expresion        	{ $$ = $1 - $3;						  }

| expresion '*' expresion       	{ $$ = $1 * $3;						  }

| expresion '/' expresion       	{ $$ = $1 / $3;						  }

| '-' expresion  %prec NEG		{ $$ = -$2;						  }

| expresion '^' expresion        	{ $$ = pow ($1, $3);   			              	  }

| IDENTIFICADOR '(' expresion ')'	{ aux=getsym($<cadena>1); if (aux) { $$ = (*(aux->value.funptr))($3); } else { printf("La funcion %s no esta definida.\n\n",$1);YYERROR;}}

| '(' expresion ')'       		{ $$ = $2;						  }

;



%%



symrec *sym_table;




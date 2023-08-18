#include <stdio.h>

#include "parser.h"

#include "scanner.h"

#include "tokens.h"



char *tokens[] = {"","IDENTIFICADOR","NUMERO","PALABRA RESERVADA","SIGNO PUNTUACION","NL","ESPACIO","ERROR","SALIR","OPERADOR","CONSTANTE","NUMERO INVALIDO","IDENTIFICADOR INVALIDO"};



int main(void){

    enum token t;

    while ((t = yylex()) != FDT)

    	switch(t)

    	{

    		case NL: 

    			printf("Token: Nueva Linea\n");

    			break;

    		default:

				printf("Token: %s\t\t\tValor: %s\n", tokens[t], yytext);

				break;

    	}

	yyparse();

	return yylex();

}








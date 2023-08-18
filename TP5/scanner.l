%{

    #include <stdio.h>

    #include <string.h>

    #include <math.h>

    #include "parser.h" 

    

    void yyerror (char const *);

%}



%option noyywrap

%option yylineno

%option noinput

%option nounput

%option header-file="scanner.h"

%option outfile="scanner.c"



digito [0-9]

digitoSinCero [1-9]

letra [a-zA-Z]

identificador {letra}({digito}|{letra})*

signo -

cadenaDigitos {digito}+

numero 0|{constanteDecimalEntera}|{constanteDecimalPuntoFlotante}

operador [+*/-^]

caracterPuntuacion [).(]

funcion sin|cos|tan|asin|acos|atan|sqrt|log

invalido   [0-9.a-zA-Z]

caracterInvalido [@#;.:]

constanteFraccional {cadenaDigitos}?\.{cadenaDigitos}|{cadenaDigitos}\.

parteExponencial e{signo}?{cadenaDigitos}|E{signo}?{cadenaDigitos}

constanteDecimalEntera {digitoSinCero}({digito})*

constanteDecimalPuntoFlotante {constanteFraccional}{parteExponencial}?|{cadenaDigitos}{parteExponencial}

%%



{numero} 					 				{yylval.numero = atof(yytext);return NUMERO;}

{digitoSinCero}({digito}|{letra})*        					{yyerror("Error léxico: ENTERO inválido\n\n");}

{constanteFraccional}({invalido}|{caracterInvalido})+{parteExponencial}? 	{yyerror("Error léxico: REAL inválido\n\n");}

salir									return SALIR;

var									return VAR;

cte									return CTE;

"\n"									return '\n';

\+=									return MASIGUAL;

-=									return MENOSIGUAL;

\*=									return PORIGUAL;

\/=									return DIVIDIRIGUAL;

"="									return yytext[0];

"+"									return yytext[0];

"-"									return yytext[0];

"*"									return yytext[0];

"/"									return yytext[0];

"^"									return yytext[0];

"("									return yytext[0];

")"									return yytext[0];

{identificador}					 			{yylval.cadena=strdup(yytext);return IDENTIFICADOR;}

{letra}({digito}|{letra}|{caracterInvalido})+			        {yyerror("Error léxico: identificador invalido\n\n");}

{caracterInvalido}*							{yyerror("Error léxico: cadena desconocida\n\n");}

[ ]									;



%%


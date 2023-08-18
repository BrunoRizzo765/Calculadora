%{

	#include <stdio.h>

	#include "parser.h"

%}



%option outfile ="scanner.c" 

%option header-file = "scanner.h"



digito [0-9]

nocero [1-9]

entero {nocero}{digito}*

letra [a-zA-Z]

identificador {letra}({letra}|{digito})*

exponencial [eE][-]?{digito}+

asignacion (\*=|\+=|-=|[/]=|=)

operador (\+|-|\*|\/|\^)

especial ("@"|"#"|"!"|"?"|"'"|";"|"°")

%%



\n													{return NL;}

salir													{return SALIR;}

e|pi													{return NUM;}

sin|cos|log|sqrt|asin|acos|tan|atan									{return FUNC;}

var													{return VAR;}

cte 													{return CTE;}

{asignacion}												{return yytext[0];}

-|[)(]													{return yytext[0];}

{operador}												{return yytext[0];}

{entero}{letra}+{entero}*										{return ERRORIDENTIFICADOR;}

[-]?{entero}\.{entero}{exponencial}?									{return NUM;}

[-]?{entero}{exponencial}?										{return NUM;}

{especial}+												{return ERROR;}

{entero}{letra}*\.											{return ERRORNUMERO;}

(({entero}|{letra})+\.)+({entero}|{letra})*								{return ERRORNUMERO;}

{identificador}												{return ID;}

({especial}|{letra}|[-]?{entero}[\.]?{entero}?{exponencial}?)+						{return ERROR;}

([-]?{entero}\.{entero}{exponencial}?){operador}{operador}([-]?{entero}\.{entero}{exponencial}?)	{return ERROR;}






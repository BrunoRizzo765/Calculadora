%{

	#include <stdio.h>

	#include "tokens.h"

%}



%option outfile ="scanner.c" 

%option header-file = "scanner.h"



digito [0-9]

nocero [1-9]

entero {nocero}{digito}*

letra [a-zA-z]

identificador {letra}({letra}|{digito})*

exponencial [eE][-]?{entero}

asignacion (\*=|\+=|-=|[/]=|=)

operador (\+|-|\*|\/|\^)

especial ("@"|"#"|"!"|"?"|"'"|";"|"°")

%%



\n																	{return NL;}

\t																	{return ESPACIO;}

salir																{return SALIR;}

e|pi																{return IDENTIFICADOR;}

sin|cos|log|sqrt|asin|acos|tan|atan									{return IDENTIFICADOR;}

var|cte																{return PALABRA_RESERVADA;}

{asignacion}														{return OPERADOR;}

-|[)(]																{return SIGNO;}

{operador}															{return OPERADOR;}

{entero}{letra}+{entero}*											{return ERRORIDENTIFICADOR;}

[-]?{entero}\.{entero}{exponencial}?								{return NUMERO;}

[-]?{entero}{exponencial}?											{return NUMERO;}

{especial}+															{return ERROR;}

{entero}{letra}*\.													{return ERRORNUMERO;}

(({entero}|{letra})+\.)+({entero}|{letra})*							{return ERRORNUMERO;}

{identificador}														{return IDENTIFICADOR;}

({especial}|{letra}|[-]?{entero}[\.]?{entero}?{exponencial}?)+		{return ERROR;}
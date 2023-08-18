#include "calc.h"

#include "parser.h"

#include "scanner.h"

#include <stdio.h>

#include <stdlib.h>

#include <string.h>

#include <math.h>





/*

	Grupo 4:

		SIMON MIRLENI,

		MATIAS GOLDFARB,

		BRUNO RIZZO,

		TOMAS SERATTI



*/





void yyerror(const char *s){

	printf("%s\n\n", s);

	return;

}





struct init

{

  char const *fname;

  double (*fun) (double);

};





struct init const funs[] =

{

  { "tan", tan },

  { "atan", atan },

  { "cos",  cos  },

  { "acos", acos },

  { "exp",  exp  },

  { "log",   log  },

  { "sin",  sin  },

  { "asin", asin },

  { "sqrt", sqrt },

  { 0, 0 },

};





static void init_table(){

  int i;

  for (i = 0; funs[i].fname != 0; i++)

    {

      symrec *ptr = putsym (funs[i].fname, TIPO_FUN);

      ptr->value.funptr = funs[i].fun;

    }

}



int main (int argc, char const* argv[])



{

  symrec *aux = putsym("e", TIPO_CTE);

  aux->value.cte = 2.718281828;

  aux = putsym("pi", TIPO_CTE);

  aux->value.cte = 3.141592654;

  init_table();

  return yyparse();

}




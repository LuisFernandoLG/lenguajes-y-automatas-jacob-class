%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

%}

letra		[a-zA-Z]
digito		[0-9]
numEntero	{digito}+
id		{letra}({letra}|{digito})*
string \"([^\\\"]|\\.)*\"

%%
"int"     return VAR_INT;
"string"  return VAR_STRING;
">"       return MAYOR_QUE;
"<"       return MENOR_QUE;
"{"       return LLAVE_INICIAL;
"}"       return LLAVE_FINAL;
"=="      return OP_IGUAL_A;
"!="      return OP_DIFERENTE_DE;
"repeat"  return REPEAT;
"if"      return IF;
"else"    return ELSE;
"print"   return PRINT;
{id}		   { strcpy(yylval.cadena, yytext); return ID;}
{string}  { strcpy(yylval.cadena, yytext); return STRING;}
{numEntero}	{ strcpy(yylval.cadena, yytext); return NUM;}
"="		    return OP_IGUAL;
"+"		    return OP_SUMA;
"-"       return OP_RES;
"*"       return OP_MUL;
"/"       return OP_DIV;
"("       return PAR_1;
")"       return PAR_2;
\n		    return SL;
" "		;
\t		;
.		  ;

%%

int yywrap() {}

%{
#include <stdio.h>
#include <string.h>
extern int yylex();
void yyerror(const char* s);
%}

%union{
	char cadena[600];

}


%token  SL IF MAYOR_QUE MENOR_QUE LLAVE_INICIAL LLAVE_FINAL OP_DIFERENTE_DE OP_IGUAL_A PRINT COMILLA_SIMPLE REPEAT VAR_INT VAR_STRING ELSE
%start instrucciones
%token<cadena> SL STRING ID NUM  PAR_1 PAR_2 OP_IGUAL OP_SUMA OP_MUL OP_DIV OP_RES
%type<cadena> expresion termino comparation conditional cycle print else_instruction declaration instrucciones instruccion instrucciones_adentro



%%
instrucciones	: instrucciones instruccion  { 

														printf("%s\n", $2);

								FILE *fp;
								fp = fopen("file.text", "a");
								fprintf(fp, "%s\n", $2);
								fclose(fp);				
								strcpy($$, "");
														
														}	
							| instruccion { 
							printf("%s\n", $1);


							FILE *fp;
								fp = fopen("file.text", "a");
								fprintf(fp, "global main\nsection .text \nmain:\n\n%s\n", $1);
								fclose(fp);				
								strcpy($$, "");
								
								fp = fopen("file.bss", "a");
								fprintf(fp, "section .bss\n\n%s\n", "");
								fclose(fp);				
								
								
								fp = fopen("file.data", "a");
								fprintf(fp, "%%include print.inc\nsection .data\n\n", "");
								fclose(fp);
								
								fp = fopen("salir.txt", "a");
							fprintf(fp, "salir: \nmov rax,60\nmov rdi,0\nsyscall", "");
								fclose(fp);


								
								
								}

instrucciones_adentro: instrucciones_adentro instruccion  { 
													char prefix[900] = "";
													snprintf( prefix, sizeof(prefix), "\n %s \n %s \n", $1, $2);
													strcpy($$, prefix);
									// strcpy($$, $1);
														}	
							| instruccion { 
									strcpy($$, $1);
								}

instruccion : 
							| declaration SL { strcpy($$, $1);} 
							| declaration { strcpy($$, $1);} 
							| conditional { strcpy($$, $1);}
							| cycle SL { strcpy($$, $1);}
							| print SL { strcpy($$, $1);}
						
cycle : REPEAT PAR_1 termino PAR_2 SL LLAVE_INICIAL SL instrucciones_adentro LLAVE_FINAL { 
				char prefix[900] = "";
			snprintf( prefix, sizeof(prefix), "%%rep %s \n \t %s \n%%endrep", $3, $8);
				strcpy($$, prefix);
			  }
			;


conditional : 
				|
				IF PAR_1 comparation PAR_2 LLAVE_INICIAL SL instrucciones_adentro LLAVE_FINAL { 
				char prefix[300] = "";
				snprintf( prefix, sizeof(prefix), "%%if %s \n %s", $3, $7);
				strcpy($$, prefix);
			  }

			  | SL else_instruction { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%s \n%%endif", $2);
				strcpy($$, prefix);
			  };

declaration : VAR_INT ID OP_IGUAL expresion { 
				char prefix[900] = "";
	snprintf( prefix, sizeof(prefix), "%%assign %s %s", $3, $4);
				strcpy($$, prefix);
			  }
						| VAR_STRING ID OP_IGUAL STRING	{ 
							
				strcpy($$, "");

				char prefix2[100] = "";
				snprintf( prefix2, sizeof(prefix2), "%s db %s \nlen_%s equ $-%s\n",$2, $4, $2, $2);
				FILE *fp;
				fp = fopen("file.data", "a");
				fprintf(fp, "%s\n", prefix2);
				fclose(fp);	
			  
			  }
						;
							
print : PRINT PAR_1 STRING PAR_2 { 
				

				//add prefix variable to file

				char prefix2[100] = "";
				// get random id letters
				int id = rand() % 100000;

				

				snprintf( prefix2, sizeof(prefix2), "var_%d db %s \nlen_%d equ $-var_%d \n\n",id,$3, id, id);
				

				FILE *fp;
				fp = fopen("file.data", "a");
				fprintf(fp, "%s\n",  prefix2);
				fclose(fp);		

				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "imprimir var_%d, len_%d", id, id);
				strcpy($$, prefix);		

			  }
			| PRINT PAR_1 ID PAR_2 { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "imprimir %s, len_%s", $3, $3);
				strcpy($$, prefix);
			}
				;

comparation : termino MAYOR_QUE termino { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%s %s %s", $1, ">", $3);
				strcpy($$, prefix);
			  }
						| termino MENOR_QUE termino { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%s %s %s", $1, "<", $3);
				strcpy($$, prefix);
			  }
						| termino OP_DIFERENTE_DE termino { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%s %s %s", $1, "!=", $3);
				strcpy($$, prefix);
			  }
						| termino OP_IGUAL_A termino { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%s %s %s", $1, "==", $3);
				strcpy($$, prefix);
			  }
						;



else_instruction : ELSE SL LLAVE_INICIAL SL instrucciones_adentro LLAVE_FINAL { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%%else \n %s", $5);
				strcpy($$, prefix);
			  }
			;



expresion	: 
			 PAR_1 expresion PAR_2	{ 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%s %s %s", $1, $2, $3);
			  }
			| expresion OP_SUMA expresion { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%s %s %s", $1, "+", $3);
				strcpy($$, prefix);
			  }
			| expresion OP_RES expresion { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%s %s %s", $1, "-", $3);
				strcpy($$, prefix);
			  }
			| expresion OP_MUL expresion { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%s %s %s", $1, "*", $3);
				strcpy($$, prefix);
			  }
			| expresion OP_DIV expresion { 
				char prefix[900] = "";
				snprintf( prefix, sizeof(prefix), "%s %s %s", $1, "/", $3);
				strcpy($$, prefix);
			  }
		  | termino
		;
termino		: NUM 
		;
%%

int main() {

	yyparse();
	return 0;
}

void yyerror(const char* s) {
	printf("%s\n",s);
}
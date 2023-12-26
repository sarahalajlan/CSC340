%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE* fp;
extern FILE* yyin; 
int yylex();
void yyerror(const char *s);
extern void tokenToStr(int token);
extern int yylineno;
extern int yycolumn;
extern char* yytext;
int errors =0;
#define SRC_LOC SrcLoc(yylineno, yycolumn)



%}
		
%union {
  int num;
  char *id;
  int yylval;
  struct s {
  char *id;
  int num;
  } expType;
}



%start prog
%token OR ASSIGN FUNNY IN LET WHILE DO IF THEN ELSE REF NOT TYPE ARROW MINUS CALL PROJECT
%token <id> ID 
%token <num> NUM  


//%token <<EOF>> END 
%nonassoc LET IN  
%left ';'
%nonassoc THEN IF DO WHILE 
%nonassoc ELSE
%right ARROW 
%left ASSIGN 
%left ':' 
%left '&' OR 
%nonassoc NOT 
%left '=' '<' 
%left '+' '-' 
%left '*' 
%left PROJECT '(' REF '!' MINUS CALL
%%

 /* Fill in grammar rules */

 /* tp */ 
tp : ID 
	| format_tp_list 
	| tp ARROW tp 
	| tp REF 
	| '('tp')'
	; 

format_tp_list : '<''>' 
		| '<' tp_list '>' 
		; 
tp_list : tp_list ',' tp 
	| tp 
	; 


 /* exp */ 
exp : '(' exp ')' 
	| ID 
	| NUM 
	| exp ';'exp 
	| MINUS exp 
	| NOT exp 
	| '!' exp 
	| '#' NUM exp %prec PROJECT 
	| exp '+' exp 
	| exp '-' exp 
	| exp '*' exp 
	| exp '&' exp 
	| exp OR exp 
	| exp '=' exp 
	| exp '<' exp 
	| exp ASSIGN exp  
	| format_exp_list 
	| exp '(' exp ')' %prec CALL 
	| exp ':' tp 
	| IF exp THEN exp ELSE exp 
	| IF exp THEN exp 
	| WHILE exp DO exp 
	| LET ID '=' exp IN exp 
	| REF exp 	
	; 	
 
format_exp_list : '<''>' 
		| '<' exp_list '>' 
		;  
exp_list : exp_list ',' exp 
	 | exp 
	; 

 /* fun declaration */ 
funnydecl : FUNNY ID '('ID  ':' tp')'':' tp '=' exp 
	;  
  
 /* program */ 
prog : prog funnydecl 
		| funnydecl 
		|error
		; 



%%
void yyerror(const char *s) {
	errors++;
	fflush(stderr);    
	fprintf(stderr, "%d:%d: %s: %s ((ERRORR= %d))\n", yylineno, yycolumn, s, yytext,errors);
	
}




void tokenToStr(int token) {
    if (token == 1) {  // Replace 17 with the appropriate number for ID
        fprintf(stderr, "t.funny:%d:%d: ID: %s\n", yylineno, yycolumn, yylval.id);
    } else // Replace 2 with the appropriate number for NUM
        fprintf(stderr, "t.funny:%d:%d: %s\n", yylineno, yycolumn, yytext);
   
}

int main(int argc, char *argv[]){
	
        fp = fopen (argv[1],"r");
       
	
	if(!fp)
	{
		printf("Can't open file \n");
		return -1;
	}
	
	yyin = fp;
	do {
		
			yyparse();
			
		}  
	while (!feof(yyin));
	
	
	if(errors==0)
		printf("Program Parsed Successfully!((ERRORR= %d)) \n",errors);
	else
		printf("Parsing Failed! \n");
	

	fclose(fp);
	
}


%{
#include <stdio.h>
#include <math.h>
void yyerror(const char *);
extern int yylex(void);
extern int yylineno;
extern FILE *yyin;

%}

%error-verbose
%token SELECT FROM WHERE END AND IN OR SQLNULL BETWEEN STRING COLUMN NUM NOT
%token EQUALS LESS_OR_EQUALS MORE_OR_EQUALS MORE_OR_EQUAL NOT_EQUAL LESS_THAN MORE_THAN
/* SELECTABLE */
/* ROW */
%left '+'  '-'
%left '*'  '/'
%%
prog 			:
				| prog selection
				;	
selection		: SELECT selectable FROM TABLE END	{ ; }
				| SELECT selectable FROM TABLE WHERE condition END 	{ ; }
				| error END				{ yyerrok; }
				;
selectable		: selectable ',' selectable
				| DISTINCT selectable { ; }
				| ALL		{ ; }
				| COLUMN  	{ ; }
				| COLUMN COLNAME { ; }
				;
condition		: condition AND condition { ; }
				| condition OR condition { ; }
				| COLUMN EQUALS COLUMN { ; }
				| COLUMN EQUALS STRING { ; }
				| COLUMN LESS_THAN COLUMN { ; }
				| COLUMN MORE_THAN COLUMN { ; }
				| COLUMN LESS_OR_EQUALS COLUMN { ; }
				| COLUMN MORE_OR_EQUALS COLUMN { ; }
				| COLUMN '<''>' COLUMN { ; }
				| COLUMN NOT BETWEEN NUM AND NUM { ; }
				| COLUMN BETWEEN NUM AND NUM { ; }
				| COLUMN IN '(' list ')' { ; }
				| COLUMN NOT IN '(' list ')' { ; }
				| COLUMN LIKE STRING { ; }
				| COLUMN NOT LIKE STRING { ; }
				| COLUMN IS SQLNULL { ; }
				| COLUMN IS NOT SQLNULL { ; }
				| condition { ; }
				;
list 			: list ',' list
				| listitem
listitem        : NUM       { ; }
                | STRING    { ; }
				;
		
%%

int main(int argc, char **argv) {
	if (argc < 2) {
		return -1;
	}
	yyin = fopen(argv[1]); //yyin file for flex input
	if (yyin) {
			yyparse();	
	} else {
		printf("cannot open %s\n", argv[1]);
	}
	return 0;
}

void yyerror(const char *s) {
	printf("ERR: %s at %d\n", s, yylineo);
}

int yywrap(void) {
	return 1;
}

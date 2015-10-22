%{
#include <stdio.h>
#include <math.h>
void yyerror(const char *);
extern int yylex(void);
extern int yylineno;
extern FILE *yyin;

%}

%error-verbose
%token COMMENT SELECT ITEM DISTINCT COLNAME FROM WHERE END AND AS IN IS OR BETWEEN LIKE NOT EQUALS LESS_OR_EQUALS MORE_OR_EQUALS NOT_EQUAL LESS_THAN MORE_THAN ALL STRING NUM SQLNULL
/* SELECTABLE */
/* ROW */
%left '+'  '-'
%left '*'  '/'
%left ','
%%
prog 			:
				| prog selection
				;	
selection		: SELECT selectablelist FROM ITEM END                   { puts("SELECT selectable FROM ITEM END"); }
				| SELECT selectablelist FROM ITEM WHERE condition END 	{ ; }
				| error END                         				{ yyerrok; }
                | COMMENT                                           { /*printf("comment\n");*/ }
                ;
selectablelist  : selectablelist ',' selectablelist { ; }
                | selectable                    { ; }
                ;
selectable      : DISTINCT selectable           { ; }
                | selectable AS COLNAME         { ; } /* TODO: AS implementation ?    { ; }*/
                | selectable AS COLNAME ',' aslist  { ; }
				| '*'		                    { ; }
				| ITEM  	                    { ; }
				| ITEM COLNAME                  { ; }
                | mathexpr                      { ; }
                | mathexpr COLNAME              { ; }
				;
aslist          : COLNAME COLNAME               { ; }
                | aslist ',' aslist             { ; }
/*tablelist       : tablelistitem ',' tablelistitem { ; }
                | tablelistitem                 { ; }*/ 
                ;
tablelistitem   : ITEM ITEM                     { ; }
                | ITEM                          { ; }
                ;
mathexpr        : '(' mathexpr ')'              { ; }
                | mathexpr '+' mathexpr         { ; }
                | mathexpr '-' mathexpr         { ; }
                | mathexpr '*' mathexpr         { ; }
                | mathexpr '/' mathexpr         { ; }
                | NUM                           { ; }
                | ITEM                          { ; }
                ;
condition		: condition AND condition       { ; }
				| condition OR condition        { ; }
				| ITEM EQUALS ITEM              { ; }
				| ITEM EQUALS STRING            { ; }
				| ITEM LESS_THAN ITEM           { ; }
				| ITEM MORE_THAN ITEM           { ; }
				| ITEM LESS_OR_EQUALS ITEM      { ; }
				| ITEM MORE_OR_EQUALS ITEM      { ; }
				| ITEM NOT_EQUAL ITEM           { ; }
				| ITEM NOT BETWEEN NUM AND NUM  { ; }
				| ITEM BETWEEN NUM AND NUM      { ; }
				| ITEM IN '(' list ')'          { ; }
				| ITEM NOT IN '(' list ')'      { ; }
				| ITEM LIKE STRING              { ; }
				| ITEM NOT LIKE STRING          { ; }
				| ITEM IS SQLNULL               { ; }
				| ITEM IS NOT SQLNULL           { ; }
                | ITEM
				;
list 			: list ',' list                 { ; }
				| listitem                      { ; }
                ;
listitem        : NUM                           { ; }
                | STRING                        { ; }
				;
		
%%

int main(int argc, char **argv) {
	if (argc < 2) {
		return -1;
	}
	yyin = fopen(argv[1], "r"); //yyin file for flex input
	if (yyin) {
        yyparse();	
	} else {
        printf("cannot open %s\n", argv[1]);
	}
	return 0;
}

void yyerror(const char *s) {
	printf("ERR: %s at %d\n", s, yylineno);
}

int yywrap(void) {
	return 1;
}

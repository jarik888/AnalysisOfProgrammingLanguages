%{
#include <stdio.h>
#include <math.h>
void yyerror(const char *);
extern int yylex(void);
extern int yylineno;
extern FILE *yyin;


// https://docs.oracle.com/cd/E17952_01/refman-5.0-en/select.html : tbl_name [[AS] alias] [index_hint]

%}

%error-verbose
%token COMMENT SELECT ITEM DISTINCT COLNAME FROM WHERE END AND AS IN IS OR BETWEEN LIKE NOT EQUALS LESS_OR_EQUALS MORE_OR_EQUALS NOT_EQUAL LESS_THAN MORE_THAN CONCAT STRING NUM SQLNULL
/* SELECTABLE */
/* ROW */
%left '+'  '-'
%left '*'  '/'
%left ','
%%
prog            :
                | prog selection 
                ;   
selection       : SELECT selector_list FROM ITEM END                                { ; }
                | SELECT DISTINCT selector_list FROM ITEM END                       { ; }
                | SELECT selector_list FROM ITEM WHERE condition_list END           { ; }
                | SELECT DISTINCT selector_list FROM ITEM WHERE condition_list END  { ; }
                | error END                                                         { yyerrok; }
                | COMMENT                                                           { ; }
                ;

selector_list   : selector ',' selector_list            { ; }
                | selector                              { ; }
                ;
selector        : selector alias                        { ; }
                | selector AS alias                     { ; }
                | '*'                                   { ; }
                | sel_concat                            { ; }
                /*| ITEM                                  { ; } // item is contained in sel_concat place */
                | sel_math_exp                          { ; }
                ;

alias           : COLNAME                               { ; }
                | ITEM                                  { ; }
                ;

sel_concat      : sel_concat_item CONCAT sel_concat     { ; }
                | sel_concat_item                       { ; }
                ;
sel_concat_item : ITEM                                  { ; }
                | STRING                                { ; }
                ;

/*sel_math_exp    : sel_math_exp sel_math_exp { ; }
                | '(' { ; }
                | ')' { ; }
                | '+' { ; }
                | '-' { ; }
                | '*' { ; }
                | '/' { ; }
                | NUM { ; }
                | ITEM { ; }
                ;*/
sel_math_exp    : '(' sel_math_op ')'                   { ; }
                | sel_math_op '+' sel_math_op           { ; }
                | sel_math_op '-' sel_math_op           { ; }
                | sel_math_op '*' sel_math_op           { ; }
                | sel_math_op '/' sel_math_op           { ; }
                ;
sel_math_op     : sel_math_exp { ; }
                | NUM { ; }
                | ITEM { ; }
                ;
                /*
sel_math_op   : '(' sel_math_exp ')'                  { ; }
                | sel_math_exp '+' sel_math_exp         { ; }
                | sel_math_exp '-' sel_math_exp         { ; }
                | sel_math_exp '*' sel_math_exp         { ; }
                | sel_math_exp '/' sel_math_exp         { ; }
                | NUM                           { ; }
                | ITEM                          { ; } /*
                                                      ITEM causes reduce conflicts.
                                                      One solution is to use sel_math_exp and sel_math_op.
                                                      Second solution is to define operand. */
                ;
condition_list  : condition AND condition_list              { ; }
                | condition OR condition_list               { ; }
                | condition { ; }
                ;
condition       : ITEM EQUALS ITEM                          { ; }
                | ITEM EQUALS STRING                        { ; }
                | ITEM LESS_THAN cmp_op           { ; }
                | ITEM MORE_THAN cmp_op           { ; }
                | ITEM LESS_OR_EQUALS cmp_op      { ; }
                | ITEM MORE_OR_EQUALS cmp_op      { ; }
                | ITEM NOT_EQUAL cmp_op           { ; }
                | ITEM NOT BETWEEN NUM AND NUM  { ; }
                | ITEM BETWEEN NUM AND NUM      { ; }
                | ITEM IN '(' list ')'          { ; }
                | ITEM NOT IN '(' list ')'      { ; }
                | ITEM LIKE STRING              { ; }
                | ITEM NOT LIKE STRING          { ; }
                | ITEM IS SQLNULL               { ; }
                | ITEM IS NOT SQLNULL           { ; }
                | ITEM                          { ; }
                ;
cmp_op          : ITEM { ; }
                | STRING { ; }
                | NUM    { ; }
                ;
list            : listitem ',' list             { ; }
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

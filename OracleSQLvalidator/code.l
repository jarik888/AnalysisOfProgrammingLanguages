%top{
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "bison.tab.h"
}

%option case-insensitive 
%option yylineno

%x SINGLE_QUOTES
%x DOUBLE_QUOTES

%%
"--"+.+"\n"     { return COMMENT; }
\n              { ; }

"SELECT"        { return SELECT; }
"DISTINCT"      { return DISTINCT; }
"FROM"          { return FROM; }
"WHERE"         { return WHERE; }
"AS"            { return AS; }
";"             { return END; }

"AND"           { return AND; }
"IN"            { return IN; }
"IS"            { return IS; }
"OR"            { return OR; }
"BETWEEN"       { return BETWEEN; }
"LIKE"          { return LIKE; }
"NOT"           { return NOT; }

"=="            { return EQUALS; }
"<="            { return LESS_OR_EQUALS; }
">="            { return MORE_OR_EQUALS; }
"<>"            { return NOT_EQUAL; }
"<"             { return LESS_THAN; }
">"             { return MORE_THAN; }
[\,\(\)\+\-\*]  { return COLUMN; /*yytext[0];*/ }

"NULL"          { return SQLNULL; }
[0-9]+          { return NUM; printf("<NUM>%s</NUM>", yytext); }
([a-zA-Z]+[0-9]|[a-zA-Z]+)    { return ITEM; }

\"              { BEGIN(DOUBLE_QUOTES); /*printf("<D_STRING>");*/}
\'              { BEGIN(SINGLE_QUOTES); /*printf("<S_STRING>");*/}



<DOUBLE_QUOTES>\" { BEGIN(INITIAL); return COLNAME; printf("</D_STRING>"); }
<DOUBLE_QUOTES>. {/*printf("%s", yytext)*/; }

<SINGLE_QUOTES>\' { BEGIN(INITIAL); return STRING; printf("</S_STRING>"); }
<SINGLE_QUOTES>. {/*printf("%s", yytext)*/; }


%%

/*
FILE *yyin;

int yywrap(void){
	return 1;
}

int main (int argc, char **argv){
    if(argc < 2)
        return -1;
    yyin = fopen(argv[1], "r");
    if(yyin)
        yyparse();
        //yylex();
    return 0;
}
*/




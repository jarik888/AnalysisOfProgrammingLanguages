%top{
//#include "code.tab.h"
#include <stdlib.h>
#include <stdio.h>
}

%option case-insensitive 
%option yylineno

%x SINGLE_QUOTES
%x DOUBLE_QUOTES

%%
"--"+.+"\n"         { ; }
("SELECT"|"FROM"|"WHERE"|"NOT"|"OR"|"AND"|"BETWEEN"|"IS"|"IN"|"DISTINCT"|"LIKE"|"NULL") { printf("<%s>", yytext); }
\"                  { BEGIN(DOUBLE_QUOTES); printf("<D_STRING>");}
\'                  { BEGIN(SINGLE_QUOTES); printf("<S_STRING>");}
[ \t]        { printf("[.]"); }
[^a-zA-Z0-9 \t]    { ; }

<DOUBLE_QUOTES>\" { BEGIN(INITIAL); printf("</D_STRING>"); }
<DOUBLE_QUOTES>. {printf("%s", yytext); }

<SINGLE_QUOTES>\' { BEGIN(INITIAL); printf("</S_STRING>"); }
<SINGLE_QUOTES>. {printf("%s", yytext); }


%%

int yywrap(void){
	return 1;
}

int main (int argc, char **argv){
    if(argc < 2)
        return -1;
    yyin = fopen(argv[1], "r");
    if(yyin)
        //yyparse();
        yylex();
    return 0;
}





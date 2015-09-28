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
"SELECT"        { return SELECT; }
"COLUMN"        { return COLUMN; }
"FROM"          { return FROM; }
"WHERE"         { return WHERE; }
"END"           { return END; }

"AND"           { return AND; }
"IN"            { return IN; }
"OR"            { return OR; }
"BETWEEN"       { return BETWEEN; }

"NOT"           { return NOT; }
"=="            { return EQUALS; }
"<="            { return LESS_OR_EQUALS; }
">="            { return MORE_OR_EQUALS; }
"<>"            { return NOT_EQUAL; }
"<"             { return LESS; }
">"             { return MORE; }

"STRING"        { return STRING; }
"NUM"           { return NUM; }
"SQLNULL"       { return SQLNULL; }

\"              { BEGIN(DOUBLE_QUOTES); printf("<D_STRING>");}
\'              { BEGIN(SINGLE_QUOTES); printf("<S_STRING>");}
[ \t]           { printf("[.]"); }
[^a-zA-Z0-9 \t]    { ; }

<DOUBLE_QUOTES>\" { BEGIN(INITIAL); return COLUMN; printf("</D_STRING>"); }
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





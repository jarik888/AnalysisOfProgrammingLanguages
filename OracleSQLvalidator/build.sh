echo "bison:" &&
bison -Wconflicts-sr -d -rall bison.y &&

echo "flex:" &&
flex code.l &&

echo "gcc:" &&
gcc lex.yy.c bison.tab.c -o code -Wall -lm

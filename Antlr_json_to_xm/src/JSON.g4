grammar JSON;
json    : list;
list    : '[' object (',' object)* ']' | '[]';
object  : '{' pair (',' pair)* '}' | '{}';
pair    : key=TEXT ':' value=TEXT;

TEXT    : '"' ~[\n\r\:]+ '"';
WS      : [ \t\n\r]+ -> skip;

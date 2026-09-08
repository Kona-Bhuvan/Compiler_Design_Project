%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

%%

"BcsMain"       { return BcsMain; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"int"           { return INT; }
"bool"          { return BOOL; }
"if"            { return IF; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"="             { return ASSIGN; }
"+"             { return PLUS; }
"*"             { return MULT; }
"=="            { return EQ; }
"!="            { return NEQ; }
"<="            { return LE; }
">="            { return GE; }
"<"             { return LT; }
">"             { return GT; }
";"             { return SEMI; }

[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]* { yylval.str = strdup(yytext); return IDENTIFIER; }

[ \t\n\r]+      { /* Ignore whitespace */ }
.               { return -1; }

%%
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./tac.h"

void yyerror(const char* s);
int yylex(void);

typedef struct {
	char name[32];
	int value;
} Symbol;

Symbol symbol_table[100];
int symbol_count = 0;

void set_variable(const char* name, int value) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].value = value;
            return;
        }
    }
    strcpy(symbol_table[symbol_count].name, name);
    symbol_table[symbol_count].value = value;
    symbol_count++;
}

int get_variable(const char* name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].value;
        }
    }
    printf("Error: Undefined variable '%s'\n", name);
    return 0;
}

%}

%union {
    int  num;
    char *str;
}

%token BcsMain LBRACE RBRACE SEMI INT BOOL ASSIGN IF ELSE LPAREN RPAREN WHILE PLUS MULT EQ NEQ LT LE GT GE
%token <num> NUMBER
%token <str> IDENTIFIER

%type <str> expr aexpr term factor relop

%nonassoc EQ NEQ LT LE GT GE
%left PLUS
%left MULT

%%

program:
    BcsMain LBRACE declist stmtlist RBRACE {}
    ;

declist:
    declist decl
    | decl
    ;

decl:
    type IDENTIFIER SEMI {
    set_variable($2, 0);
    free($2);
    }
    ;

type:
    INT
    | BOOL
    ;

stmtlist:
    stmtlist SEMI stmt
    | stmt
    ;

stmt:
    IDENTIFIER ASSIGN aexpr {
    emit($1, $3, NULL, NULL);
    free($1);
    }
    | IF LPAREN expr RPAREN LBRACE stmtlist RBRACE ELSE LBRACE stmtlist RBRACE
    | WHILE LPAREN expr RPAREN LBRACE stmtlist RBRACE
    ;

expr:
    aexpr relop aexpr {
    $$ = newTemp();
    emit($$, $1, $2, $3);
    }
    | aexpr { $$ = $1; }
    ;

relop:
    EQ  { $$ = "=="; }
    | NEQ { $$ = "!="; }
    | LT  { $$ = "<";  }
    | LE  { $$ = "<="; }
    | GT  { $$ = ">";  }
    | GE  { $$ = ">="; }
    ;

aexpr:
    aexpr PLUS aexpr {
    $$ = newTemp();
    emit($$, $1, "+", $3);
    }
    | term
    ;

term:
    term MULT factor {
    $$ = newTemp();
    emit($$, $1,"*",$3);
    }
    | factor
    ;

factor:
    IDENTIFIER {
    $$ = $1;
    }
    | NUMBER {
    char *s = malloc(16);
    sprintf(s, "%d", $1);
    $$ = s;
    }
    ;

%%

void yyerror(const char *s) {
    // fprintf(stderr, "Syntax Error: %s\n", s);
	printf("Syntax Error\n");
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Could not open file");
            return 1;
        }
        extern FILE *yyin;
        yyin = file;
    }
    int rc = yyparse();
    close_tac_file();
    if (rc == 0) printf("Parsing Successful\n");
    return 0;
}
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./tac.h"

void yyerror(const char* s);
int yylex(void);

#define MAX_SYMS 100
#define MAX_NAME 32

typedef enum {
    T_INT,
    T_BOOL,
    T_ERR
} Type;

typedef struct {
    char name[MAX_NAME];
    Type type;
} Symbol;

static Symbol symbol_table[MAX_SYMS];
static int nsyms = 0;
int sem_errors = 0;

int lookup(const char *name) {
    for (int i = 0; i < nsyms; i++)
        if (strcmp(symbol_table[i].name, name) == 0) return i;
    return -1;
}

void declare(const char *name, Type t) {
    if (strlen(name) >= MAX_NAME) {
        fprintf(stderr, "Semantic error: identifier '%s' too long\n", name);
        sem_errors++;
        return;
    }
    if (lookup(name) >= 0) {
        fprintf(stderr, "Semantic error: '%s' redeclared\n", name);
        sem_errors++;
        return;
    }
    if (nsyms >= MAX_SYMS) {
        fprintf(stderr, "Semantic error: too many variables\n");
        sem_errors++;
        return;
    }
    strcpy(symbol_table[nsyms].name, name);
    symbol_table[nsyms].type = t;
    nsyms++;
}

void check_declared(const char *name) {
    if (lookup(name) < 0) {
        fprintf(stderr, "Semantic error: '%s' undeclared\n", name);
        sem_errors++;
    }
}

Type get_type(const char *name) {
    int i = lookup(name);
    return i < 0 ? T_ERR : symbol_table[i].type;
}

const char *type_name(Type t) {
    if (t == T_INT)
        return "int";
    else if (t == T_BOOL)
        return "bool";
    else
        return "error";
}

Type arith_type(Type a, Type b, const char *op) {
    if (a == T_ERR || b == T_ERR)
        return T_ERR;
    if (a != T_INT || b != T_INT) {
        fprintf(stderr, "Type error: operator '%s' needs int operands, got %s and %s\n",
                op, type_name(a), type_name(b));
        sem_errors++;
        return T_ERR;
    }
    return T_INT;
}

Type rel_type(Type a, Type b, const char *op) {
    if (a == T_ERR || b == T_ERR)
        return T_ERR;
    if (a != T_INT || b != T_INT) {
        fprintf(stderr, "Type error: operator '%s' needs int operands, got %s and %s\n",
                op, type_name(a), type_name(b));
        sem_errors++;
        return T_ERR;
    }
    return T_BOOL;
}

void check_assign(const char *name, Type rhs) {
    Type lhs = get_type(name);
    if (lhs == T_ERR || rhs == T_ERR) return;
    if (lhs != rhs) {
        fprintf(stderr, "Type error: cannot assign %s to %s variable '%s'\n",
                type_name(rhs), type_name(lhs), name);
        sem_errors++;
    }
}

void check_condition(Type t) {
    if (t == T_ERR) return;
    if (t != T_BOOL) {
        fprintf(stderr, "Type error: condition must be bool, got %s\n", type_name(t));
        sem_errors++;
    }
}

%}

%union {
    int  num;
    char *str;
    struct{
        char *name;
        int type;
    } attr;
}

%token BcsMain LBRACE RBRACE SEMI INT BOOL ASSIGN IF ELSE LPAREN RPAREN WHILE PLUS MULT EQ NEQ LT LE GT GE
%token <num> NUMBER
%token <str> IDENTIFIER

%type <num> type
%type <str> relop
%type <attr> expr aexpr term factor

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
        declare($2, (Type)$1);
        free($2);
    }
    ;

type:
    INT { $$ = T_INT; }
    | BOOL { $$ = T_BOOL; }
    ;

stmtlist:
    stmtlist SEMI stmt
    | stmt
    ;

stmt:
    IDENTIFIER ASSIGN aexpr {
        check_declared($1);
        check_assign($1, (Type)$3.type);
        emit($1, $3.name, NULL, NULL);
        free($1);
    }
    | IF LPAREN expr RPAREN LBRACE stmtlist RBRACE ELSE LBRACE stmtlist RBRACE {
        check_condition((Type)$3.type);
    }
    | WHILE LPAREN expr RPAREN LBRACE stmtlist RBRACE {
        check_condition((Type)$3.type);
    }
    ;

expr:
    aexpr relop aexpr {
        $$.name = newTemp();
        emit($$.name, $1.name, $2, $3.name);
        $$.type = rel_type((Type)$1.type, (Type)$3.type, $2);
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
        $$.name = newTemp();
        emit($$.name, $1.name, "+", $3.name);
        $$.type = arith_type((Type)$1.type, (Type)$3.type, "+");
    }
    | term
    ;

term:
    term MULT factor {
        $$.name = newTemp();
        emit($$.name, $1.name,"*",$3.name);
        $$.type = arith_type((Type)$1.type, (Type)$3.type, "*");
    }
    | factor
    ;

factor:
    IDENTIFIER {
        check_declared($1);
        $$.name = $1;
        $$.type = get_type($1);
    }
    | NUMBER {
        char *s = malloc(16);
        sprintf(s, "%d", $1);
        $$.name = s;
        $$.type = T_INT;
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

    if (rc != 0 || sem_errors != 0)
        remove("tac_output.txt");

    if (rc == 0 && sem_errors == 0) {
        printf("Parsing Successful\n");
    } else if (rc == 0) {
        printf("Semantic Error\n");
    }

    return 0;
}
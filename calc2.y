%{
    #include <cstdio>
    #include <iostream>
    using namespace std;

    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    extern int line_number;
    extern bool divZero;
    extern bool eq;
    extern bool ieq;

    void yyerror(const char *p) {
       cerr << "Error: " << p << endl;
    };
%}

%union {
    int val;
};

%token LARGER EQUAL SMALLER
%token LPAREN RPAREN COLON
%token PLUS MINUS MUL DIV
%token ENDL
%token <val> NUM

%type <val> equation iequation expr term factor

%%

prog:
    questions
    ;

questions:
    questions question
    | question
    ;

question:
    NUM COLON equation ENDLS {
        cout << $1 << ": ";

        if (divZero) {
            yyerror("Division by Zero");
            divZero = false;
            eq = true;
        } else if (eq) {
            cout << "YES" << endl;
        } else {
            cout << "NO" << endl;
            eq = true;
        }
    }
    | NUM COLON iequation ENDLS {
        cout << $1 << ": ";

        if (divZero) {
            yyerror("Division by Zero");
            divZero = false;
            ieq = true;
        } else if (ieq) {
            cout << "YES" << endl;
        } else {
            cout << "NO" << endl;
            ieq = true;
        }
    }
    | ENDL {
        cout << "An empty line" << endl;
    }
    ;


equation:
    equation EQUAL expr {
        if ($1 == $3) {
            $$ = $1;
        } else {
            $$ = $1;
            eq = false;
        }
    }
    | expr
    ;

iequation:
    iequation LARGER expr {
        if ($1 > $3) {
            $$ = $3;
        } else {
            $$ = $3;
            ieq = false;
        }
    }
    | iequation SMALLER expr {
        if ($1 < $3) {
            $$ = $3;
        } else {
            $$ = $3;
            ieq = false;
        }
    }
    | expr
    ;

expr:
    expr PLUS term {
    $$ = $1 + $3;
    }
    | expr MINUS term {
    $$ = $1 - $3;
    }
    |
    MINUS term {
    $$ = -1 * $2;
    }
    | term
    ;

term:
    term MUL factor {
    $$ = $1 * $3;
    }
    | term DIV factor {
        if ($3 == 0) {
            divZero = true;
        }
        $$ = $1 / $3;
    }
    | factor
    ;

factor:
    NUM
    | LPAREN expr RPAREN {
    $$ = $2;
    }
    ;

ENDLS:
    ENDL
    |
    ;

%%

int main(int argc, char** argv)
{
    FILE *myfile = fopen(argv[1], "r");

    if (!myfile) {
        cout << "Can't open the file" << endl;
        return -1;
    }

    yyin = myfile;
    yyparse();
}

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
%token ENDL END_OF_FILE
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
    NUM COLON eqs ENDL {
        cout << $1 << ": ";

        if (divZero) {
            yyerror("Division by Zero");
            divZero = false;
            eq = true;
            ieq = true;
        } else if (eq && ieq) {
            cout << "YES" << endl;
        } else {
            cout << "NO" << endl;
            eq = true;
            ieq = true;
        }
    }
    | NUM COLON eqs END_OF_FILE {
        cout << $1 << ": ";

        if (divZero) {
            yyerror("Division by Zero");
            divZero = false;
            eq = true;
            ieq = true;
        } else if (eq && ieq) {
            cout << "YES" << endl;
        } else {
            cout << "NO" << endl;
            eq = true;
            ieq = true;
        }

        exit(0);
    }
    | ENDL {
        cout << "An empty line" << endl;
    }
    ;

eqs:
    equation
    | iequation
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

%%

int main()
{
    yyin = stdin;
    yyparse();
}

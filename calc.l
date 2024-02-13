%{
    #include <iostream>
    #include <stdlib.h>
    #include "calc.tab.h"
    using namespace std;

    int line_number = 1;
    bool divZero = false;
    bool eq = true;
    bool ieq = true;

%}

%option noyywrap

%%

[0-9]+                  { yylval.val = atoi(yytext); return NUM; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return MUL; }
"/"                     { return DIV; }
"("                     { return LPAREN; }
")"                     { return RPAREN; }
":"                     { return COLON; }
">"                     { return LARGER; }
"="                     { return EQUAL; }
"<"                     { return SMALLER; }
[ \t\r]+                ;
\n                      { line_number += 1;
                          return ENDL;
                        }
.                       { cerr << "Error: syntax error" << endl;
                          exit(42);
                        }
<<EOF>>                 { return END_OF_FILE; }

%%

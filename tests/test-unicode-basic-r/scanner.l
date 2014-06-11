%{
/* TEST */

#define YY_READ_BUF_SIZE 8
#include <stdio.h>
#include <stdlib.h>
#include "config.h"

%}

%option unicode
%option prefix="test"
%option nounput nomain noyywrap noinput reentrant
%option warn

/* tests of various unicode characters */

/* latin-us */
LATIN_US       [A-Za-z ]

/* greek */
GREEK          [Ͱ-ϡ ]

/* egyptian hieroglyphs */
HIEROGLYPHS    [𓀀-𓐮 ]

%%

{LATIN_US}+     { fprintf(yyout, "[LATIN_US]"); }
{GREEK}+        { fprintf(yyout, "[GREEK]"); }
{HIEROGLYPHS}+  { fprintf(yyout, "[HIEROGLYPHS]"); }
  /*\n              { fprintf(yyout, "\n"); }*/

%%

int main(void);

int
main ()
{
    yyscan_t lexer;
    yylex_init(&lexer);
    yyset_in(stdin, lexer);
    yyset_charset("UTF-8", lexer);
    yyset_out(stdout, lexer);
    yylex(lexer);
    yylex_destroy(lexer);
    return 0;
}

%{
#include<stdio.h>
#include<stdlib.h>
#include "parser.tab.h"
    extern FILE *yyin;  

	int linenr = 0;
%}

%option noyywrap nodefault yylineno

%%

--\[\[([^\]])*\]\]--					{printf("comment %s %s",yytext); }
--[^\n]*								{printf("comment %s",yytext); }


"do"										{printf("do %s", yytext); return DO; }
while									{ printf("while %s", yytext); return WHILE ;}
for										{printf("for %s", yytext); return FOR; }
until									{printf("until %s", yytext); return UNTIL; }
repeat									{printf("repeat %s", yytext); return REPEAT; }
end										{printf("end %s", yytext); return END; }
in										{printf("in %s", yytext); return IN; }

if										{printf("if %s", yytext); return IF; }
then									{printf("then %s", yytext); return THEN; }
elseif									{printf("elseif %s", yytext); return ELSEIF; }
else									{printf("else %s", yytext); return ELSE; }
 

[+]                                     {printf("binop/+ %s", yytext); return PLUS; }
[-]                                     {printf("binop/- %s", yytext); return MINUS; }
[*]                                     {printf("binop/* %s", yytext); return TIMES; }
[/]                                     {printf("binop// %s", yytext); return DIVIDE; }
[\^]                                    {printf("binop/^ %s", yytext); return POWER; }
[%]                                     {printf("binop/% %s", yytext); return MODULO; }
[=][=]                                  {printf("binop/== %s", yytext); return EQS; }
[<]                                     {printf("binop/< %s", yytext); return LT; }
[<][=]                                  {printf("binop/<= %s", yytext); return LTE; }
[>]                                     {printf("binop/> %s", yytext); return GT; }
[>][=]                                  {printf("binop/>= %s", yytext); return GTE; }
[~][=]                                  {printf("binop/~= %s", yytext); return NEQS; }
[.][.]                                  {printf("binop/.. %s", yytext); return APPEND; }
and                                     {printf("unop/and %s", yytext); return AND; }
or                                      {printf("unop/or %s", yytext); return OR; }
#                                     {printf("unop/# %s", yytext); return SQUARE; }
not                                     {printf("unop/not %s", yytext); return NOT; }



local									{printf("local %s", yytext); return LOCAL; }


function								{printf("function %s",yytext); return FUNCTION; }
return									{printf("return %s",yytext); return RETURN; }
break									{printf("break %s",yytext); return BREAK; }


nil										{printf("nil %s", yytext); return NIL;}
false									{printf("false %s", yytext); return FALSE; }
true									{printf("true %s", yytext); return TRUE;}
[0-9]+									{printf("number %s",yytext); return NUMBER;}
\"[^\"]*\"								{printf("string %s",yytext); return STRING;}
\.\.\.									{printf("tdot %s",yytext); return TDOT;}
[A-Za-z_][A-Za-z0-9_]*					{printf("name %s",yytext); return NAME; }




=										{printf("assign %s",yytext); return ASSIGN; }
\.										{printf("dot %s",yytext); return DOT; }
:										{printf("colon %s",yytext); return COL; }
,										{printf("comma %s",yytext); return COMMA; }
;										{printf("semicolon %s",yytext); return SC; }


\(										{printf("parentheses_l %s",yytext); return OPB; }
\)										{printf("parantheses_r %s",yytext); return CPB; }
\{										{printf("braces_l %s", yytext); return OCB; }
\}										{printf("braces_r %s", yytext); return CCB; }
[\[]									{printf("bracket_l %s",yytext); return OSB; }
[\]]									{printf("bracket_r %s",yytext); return CSB; }


[ \t]									{ /* spacing */}
[\n]									{ linenr++; }

%%
//<<EOF>>                 				{printf("end %s", ""); return EXIT; }
void yyerror(const char *str)
{
    fprintf(stderr,"Error | Line: %d\n%s\n",yylineno,str); 
}

int yywrap()
{
    return 1; 
}


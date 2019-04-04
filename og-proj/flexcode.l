%{
#include<stdio.h>
#include<stdlib.h>
#include "parser.tab.h"
    extern FILE *yyin;  

	int linenr = 0;
%}

%option nodefault yylineno

%%

--\[\[([^\]])*\]\]--					{printf("comment %s",yytext); }
--[^\n]*								{printf("comment %s",yytext); }

"do"									{printf("do %s", yytext); return DO; }
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
[%]                                     {printf("binop/ %s", yytext); return MODULO; }
[=][=]                                  {printf("binop/== %s", yytext); return EQS; }
[<]                                     {printf("binop/< %s", yytext); return LT; }
[<][=]                                  {printf("binop/<= %s", yytext); return LTE; }
[>]                                     {printf("binop/> %s", yytext); return GT; }
[>][=]                                  {printf("binop/>= %s", yytext); return GTE; }
[~][=]                                  {printf("binop/~= %s", yytext); return NEQS; }
[.][.]                                  {printf("binop/.. %s", yytext); return APPEND; }
and                                     {printf("unop/and %s", yytext); return AND; }
or                                      {printf("unop/or %s", yytext); return OR; }
#                                       {printf("unop/# %s", yytext); return SQUARE; }
not                                     {printf("unop/not %s", yytext); return NOT; }

local									{printf("\nlocal %s", yytext); return LOCAL; }


function								{printf("\nfunction %s",yytext); return FUNCTION; }
return									{printf("\nreturn %s",yytext); return RETURN; }
break									{printf("\nbreak %s",yytext); return BREAK; }


nil										{printf("\nnil %s", yytext); return NIL;}
false									{printf("\nfalse %s", yytext); return FALSE; }
true									{printf("\ntrue %s", yytext); return TRUE;}
[0-9]+									{printf("\nnumber %s",yytext); return NUMBER;}
\"[^\"]*\"								{printf("\nstring %s",yytext); return STRING;}
\.\.\.									{printf("\ntdot %s",yytext); return TDOT;}
[A-Za-z_][A-Za-z0-9_]*					{printf("\nname %s",yytext); return NAME; }




=										{printf("\nassign %s",yytext); return ASSIGN; }
\.										{printf("\ndot %s",yytext); return DOT; }
:										{printf("\ncolon %s",yytext); return COLON; }
,										{printf("\ncomma %s",yytext); return COMMA; }
;										{printf("\nsemicolon %s",yytext); return SEMICOLON; }


\(										{printf("\nopening parentheses %s",yytext); return OPB; }
\)										{printf("\nclosing parentheses %s",yytext); return CPB; }
\{										{printf("\nopening braces %s", yytext); return OCB; }
\}										{printf("\nclosing braces %s", yytext); return CCB; }
[\[]									{printf("\nopening sqbracket %s",yytext); return OSB; }
[\]]									{printf("\nclosing sqbracket %s",yytext); return CSB; }


[ \t]									{ /* spacing */}
[\n]									{ linenr++; }

%%
void yyerror(const char *str)
{
    fprintf(stderr,"Error | Line: %d\n%s\n",yylineno,str); 
}

int yywrap()
{
    return 1; 
}


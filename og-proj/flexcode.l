%{
#include<stdio.h>
#include<stdlib.h>
#include "parser.tab.h"
    extern FILE *yyin;  

	int linenr = 0;
%}

%option nodefault yylineno

%%

--\[\[([^\]])*\]\]--					{printf("\ncomment %s",yytext); }
--[^\n]*								{printf("\ncomment %s",yytext); }

"do"									{printf("\ndo %s", yytext); return DO; }
while									{ printf("\nwhile %s", yytext); return WHILE ;}
for										{printf("\nfor %s", yytext); return FOR; }
until									{printf("\nuntil %s", yytext); return UNTIL; }
repeat									{printf("\nrepeat %s", yytext); return REPEAT; }
end										{printf("\nend %s", yytext); return END; }
in										{printf("\nin %s", yytext); return IN; }

if										{printf("\nif %s", yytext); return IF; }
then									{printf("\nthen %s", yytext); return THEN; }
elseif									{printf("\nelseif %s", yytext); return ELSEIF; }
else									{printf("\nelse %s", yytext); return ELSE; }

[+]                                     {printf("\nbinary operator %s", yytext); return PLUS; }
[-]                                     {printf("\nbinary operator %s", yytext); return MINUS; }
[*]                                     {printf("\nbinary operator %s", yytext); return TIMES; }
[/]                                     {printf("\nbinary operator %s", yytext); return DIVIDE; }
[\^]                                    {printf("\nbinary operator %s", yytext); return POWER; }
[%]                                     {printf("\nbinary operator %s", yytext); return MODULO; }
[=][=]                                  {printf("\nbinary operator %s", yytext); return EQS; }
[<]                                     {printf("\nbinary operator %s", yytext); return LT; }
[<][=]                                  {printf("\nbinary operator %s", yytext); return LTE; }
[>]                                     {printf("\nbinary operator %s", yytext); return GT; }
[>][=]                                  {printf("\nbinary operator %s", yytext); return GTE; }
[~][=]                                  {printf("\nbinary operator %s", yytext); return NEQS; }
[.][.]                                  {printf("\nbinary operator %s", yytext); return APPEND; }
and                                     {printf("\nunary operator %s", yytext); return AND; }
or                                      {printf("\nunary operator %s", yytext); return OR; }
#                                       {printf("\nunary operator %s", yytext); return SQUARE; }
not                                     {printf("\nunary operator %s", yytext); return NOT; }

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


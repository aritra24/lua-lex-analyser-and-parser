%{
#include<stdio.h>
#include<stdlib.h>
#include "parser.tab.h"
#include "sym_table.h"
    extern FILE *yyin;  

	int linenr = 0;
%}

%option nodefault yylineno

%%

--\[\[([^\]])*\]\]--					{printf("comment %s \n",yytext);}
--[^\n]*								{printf("comment %s \n",yytext); }


"do"										{printf("do %s \n", yytext); insertUtil(newToken(yytext,1)); return DO; }
while									{ printf("while %s \n", yytext); insertUtil(newToken(yytext,1)); return WHILE ;}
for										{printf("for %s \n", yytext); insertUtil(newToken(yytext,1)); return FOR; }
until									{printf("until %s \n", yytext); insertUtil(newToken(yytext,1)); return UNTIL; }
repeat									{printf("repeat %s \n", yytext); insertUtil(newToken(yytext,1)); return REPEAT; }
end										{printf(" END%s \n", yytext); insertUtil(newToken(yytext,1)); return END; }
in										{printf("in %s \n", yytext); insertUtil(newToken(yytext,1)); return IN; }
if										{printf("if %s \n", yytext); insertUtil(newToken(yytext,1)); return IF; }
then									{printf("then %s \n", yytext); insertUtil(newToken(yytext,1)); return THEN; }
elseif									{printf("elseif %s \n", yytext); insertUtil(newToken(yytext,1)); return ELSEIF; }
else									{printf("else %s \n", yytext); insertUtil(newToken(yytext,1)); return ELSE; }
 

[+]                                     {printf("binary operator %s \n", yytext); insertUtil(newToken(yytext,3)); return PLUS; }
[-]                                     {printf("binary operator%s \n", yytext);  insertUtil(newToken(yytext,3)); return MINUS; }
[*]                                     {printf("binary operator%s \n", yytext);  insertUtil(newToken(yytext,3)); return TIMES; }
[/]                                     {printf("binary operator%s \n", yytext);  insertUtil(newToken(yytext,3)); return DIVIDE; }
[\^]                                    {printf("binary operator%s \n", yytext);  insertUtil(newToken(yytext,3)); return POWER; }
[%]                                     {printf("binary operator%s \n", yytext);  insertUtil(newToken(yytext,3)); return MODULO; }
[=][=]                                  {printf("binary operator %s \n", yytext);  insertUtil(newToken(yytext,5)); return EQS; }
[<]                                     {printf("binary operator%s \n", yytext); insertUtil(newToken(yytext,4)); return LT; }
[<][=]                                  {printf("binary operator %s \n", yytext); insertUtil(newToken(yytext,4)); return LTE; }
[>]                                     {printf("binary operator%s \n", yytext); insertUtil(newToken(yytext,4)); return GT; }
[>][=]                                  {printf("binary operator %s \n", yytext); insertUtil(newToken(yytext,4)); return GTE; }
[~][=]                                  {printf("binary operator %s \n", yytext); insertUtil(newToken(yytext,5)); return NEQS; }
[.][.]                                  {printf("binary operator %s \n", yytext); return APPEND; }
and                                     {printf("unop/and %s \n", yytext); return AND; }
or                                      {printf("unop/or %s \n", yytext); return OR; }
#                                     {printf("unop/# %s \n", yytext); return SQUARE; }
not                                     {printf("unop/not %s \n", yytext); return NOT; }



local									{printf("local %s \n", yytext); insertUtil(newToken(yytext,1)); return LOCAL; }

function								{printf("function %s \n",yytext); insertUtil(newToken(yytext,1)); return FUNCTION; }
return									{printf("return %s \n",yytext); insertUtil(newToken(yytext,1)); return RETURN; }
break									{printf("break %s \n",yytext); insertUtil(newToken(yytext,1)); return BREAK; }


nil										{printf("nil %s \n", yytext); insertUtil(newToken(yytext,1)); return NIL;}
false									{printf("false %s \n", yytext); insertUtil(newToken(yytext,1)); return FALSE; }
true									{printf("true %s \n", yytext); insertUtil(newToken(yytext,1)); return TRUE;}
[0-9]+									{printf("number %s \n",yytext); insertUtil(newToken(yytext,8)); return NUMBER;}
\"[^\"]*\"								{printf("string %s \n",yytext); insertUtil(newToken(yytext,9)); return STRING;}
\.\.\.									{printf("tdot %s \n",yytext); return TDOT;}
[A-Za-z_][A-Za-z0-9_]*					{printf("name %s \n",yytext); insertUtil(newToken(yytext,2)); return NAME; }
[A-Za-z_][A-Za-z0-9_.]*/[ ]*"("					{printf("name %s \n",yytext); insertUtil(newToken(yytext,14)); return NAME; }


=										{printf("\nassign %s",yytext); return ASSIGN; }
\.										{printf("\ndot %s",yytext); return DOT; }
:										{printf("\ncolon %s",yytext); return COLON; }
,										{printf("\ncomma %s",yytext); return COMMA; }
;										{printf("\nsemicolon %s",yytext); return SEMICOLON; }


\(										{printf("\nopening parentheses %s",yytext);insertUtil(newToken(yytext,12));  return OPB; }
\)										{printf("\nclosing parentheses %s",yytext); insertUtil(newToken(yytext,12)); return CPB; }
\{										{printf("\nopening braces %s", yytext); insertUtil(newToken(yytext,12)); return OCB; }
\}										{printf("\nclosing braces %s", yytext); insertUtil(newToken(yytext,12)); return CCB; }
[\[]									{printf("\nopening sqbracket %s",yytext); insertUtil(newToken(yytext,12)); return OSB; }
[\]]									{printf("\nclosing sqbracket %s",yytext); insertUtil(newToken(yytext,12)); return CSB; }

[ \t]									{ /* spacing */}
[\n]									{ linenr++; insertUtil(newToken(yytext,16));}
<<EOF>>                 				{printf("end %s \n", ""); Display(); return EXIT; }
. {}

%%
void yyerror(const char *str)
{
    fprintf(stderr,"Error | Line: %d\n%s\n",yylineno,str); 
    Display();
}

int yywrap()
{
    return 1; 
}

/*
int main()
{
    while(yylex())
    {

    }
    printf("Display table\n"); 
    Display(); 
}
*/

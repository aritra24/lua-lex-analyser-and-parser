%top{
    #include "grammar.tab.hh"
    #include "ops.h"
	#include "globals.h"
    #define YY_DECL yy::parser::symbol_type yylex()

	int linenr = 0;

	void log(std::string message, std::string text){
		if (debug_lex == true)
			std::cout << message << ": " << text << std::endl;
	}
}

%option noyywrap nounput batch noinput

%%

--\[\[([^\]])*\]\]--					{ log("comment",yytext); }
--[^\n]*								{ log("comment",yytext); }


do										{ log("do", yytext); return DO; }
while									{ log("while", yytext); return WHILE }
for										{ log("for", yytext); return FOR; }
until									{ log("until", yytext); return UNTIL; }
repeat									{ log("repeat", yytext); return REPEAT; }
end										{ log("end", yytext); return END; }
in										{ log("in", yytext); return IN; }

if										{ log("if", yytext); return IF; }
then									{ log("then", yytext); return THEN; }
elseif									{ log("elseif", yytext); return ELSEIF; }
else									{ log("else", yytext); return ELSE; }
 

[+]                                     { log("binop/+", yytext); return PLUS; }
[-]                                     { log("binop/-", yytext); return MINUS; }
[*]                                     { log("binop/*", yytext); return TIMES; }
[/]                                     { log("binop//", yytext); return DIVIDE; }
[\^]                                    { log("binop/^", yytext); return POWER; }
[%]                                     { log("binop/%", yytext); return MODULO; }
[=][=]                                  { log("binop/==", yytext); return EQUALS; }
[<]                                     { log("binop/<", yytext); return LESS_THAN; }
[<][=]                                  { log("binop/<=", yytext); return LESS_EQUAL_THAN; }
[>]                                     { log("binop/>", yytext); return MORE_THAN; }
[>][=]                                  { log("binop/>=", yytext); return MORE_EQUAL_THAN; }
[~][=]                                  { log("binop/~=", yytext); return TILDE_EQUAL; }
[.][.]                                  { log("binop/..", yytext); return APPEND; }
and                                     { log("unop/and", yytext); return AND; }
or                                      { log("unop/or", yytext); return OR; }
#                                     { log("unop/#", yytext); return SQUARE; }
not                                     { log("unop/not", yytext); return NOT; }



local									{ log("local", yytext); return LOCAL; }


function								{ log("function",yytext); return FUNCTION; }
return									{ log("return",yytext); return RETURN; }
break									{ log("break",yytext); return BREAK; }


nil										{ log("nil", yytext); return NIL;}
false									{ log("false", yytext); return FALSE; }
true									{ log("true", yytext); return TRUE;}
[0-9]+									{ log("number",yytext); return NUMBER;}
\"[^\"]*\"								{ log("string",yytext); return STRING;}
\.\.\.									{ log("tdot",yytext); return TDOT;}
[A-Za-z_][A-Za-z0-9_]*					{ log("name",yytext); return NAME; }




=										{ log("assign",yytext); return ASSIGN; }
\.										{ log("dot",yytext); return DOT; }
:										{ log("colon",yytext); return COLON; }
,										{ log("comma",yytext); return COMMA; }
;										{ log("semicolon",yytext); return SEMICOLON; }


\(										{ log("parentheses_l",yytext); return PARANTHESES_L; }
\)										{ log("parantheses_r",yytext); return PARANTHESES_R; }
\{										{ log("braces_l", yytext); return BRACES_L; }
\}										{ log("braces_r", yytext); return BRACES_R; }
[\[]									{ log("bracket_l",yytext); return BRACKET_L; }
[\]]									{ log("bracket_r",yytext); return BRACKET_R; }


[ \t]									{ /* spacing */}
[\n]									{ linenr++; }
<<EOF>>                 				{ log("end", ""); return QUIT(); }

%%
void set_input_file(char* filename)
{
	yyin = fopen(filename, "r");
}

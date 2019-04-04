%{
#include<stdio.h>
#include<stdlib.h>
//#include "sym_table.h"
//#define YYSTYPE double
#define YYDEBUG 1
#define YYPRINT(file, type, value)	
int yylex(); 
int yyerror(); 
extern FILE *yyin;  

%}
%define parse.error verbose
%define parse.lac full
%define parse.trace
%locations

%token DO WHILE FOR REPEAT UNTIL IN END IF THEN ELSE ELSEIF PLUS MINUS TIMES DIVIDE POWER MODULO LT LTE GT GTE ASSIGN NEQS EQS AND APPEND SQUARE NOT OR LOCAL FUNCTION RETURN BREAK NIL FALSE TRUE NUMBER STRING TDOT NAME DOT COLON COMMA SEMICOLON OPB CPB OCB CCB OSB CSB 
%token EXIT 0 "end of file"
%%
block	: chunk
		;

chunk	: chunk2 laststat 
		| chunk2 
		| laststat
		| error '\n'
		;

chunk2	: stat optsemi
	   	| chunk stat optsemi 
		| error '\n'
		;

optsemi	: SEMICOLON
		| 
		| error '\n'
		;

laststat: RETURN explist optsemi 
		| RETURN optsemi 
		| BREAK optsemi 
		| error '\n'
		;

stat	: varlist ASSIGN explist 
		| LOCAL namelist ASSIGN explist 
		| LOCAL namelist 
		| FUNCTION funcname funcbody 
		| LOCAL FUNCTION NAME funcbody
		| functioncall 
		| DO block END 
        | whileblock 
		| REPEAT block UNTIL exp 
		| ifblock 
		| forblock
		| error '\n'
	 	;

forblock: FOR NAME ASSIGN exp COMMA exp DO block END 
		| FOR NAME ASSIGN exp COMMA exp COMMA exp DO block END 
		| FOR namelist IN explist DO block END 
		| error '\n'
		;
		
whileblock: WHILE exp DO block END 
		| error '\n'
        ;

ifblock	: iflist elsestat END 
		| error '\n'
		;
iflist: ifstat 
		| iflist elseifstat 
		| error '\n'
		;

ifstat: IF exp THEN block 
		| error '\n'
		;

elseifstat: ELSEIF exp THEN block 
		| error '\n'
		;

elsestat	: ELSE block 
		| /* empty */
		| error '\n'
		;

var		: NAME 
		| prefixexp OSB exp CSB 
		| prefixexp DOT NAME 
		| error '\n'
	 	;

varlist : var 
		| varlist COMMA var 
		| error '\n'
		;

funcname: funcname2 
		| funcname2 COLON NAME 
		| error '\n'
		;

funcname2: NAME 
		| funcname2 DOT NAME 
		| error '\n'
		;

namelist: NAME 
		| namelist COMMA NAME 
		| error '\n'
		;

exp		: NIL 
	 	| FALSE
		| TRUE 
		| NUMBER
		| string
		| function 
		| prefixexp
		| op 
		| error '\n'
		;

explist : exp
		| explist COMMA exp 
		| error '\n'
		;

prefixexp: var 
		| functioncall
		| OPB exp CPB 
		| OCB explist CCB
		| error '\n'
		;

function: FUNCTION funcbody ;
		| error '\n'

functioncall: prefixexp args
		| prefixexp COLON NAME args 
		| error '\n'
		;

funcbody: OPB parlist CPB block END 
		| OPB CPB block END 
		| error '\n'
		;

parlist	: namelist 
		| namelist COMMA TDOT 
		| TDOT 
		| error '\n'
		;

args	: OPB CPB 
		| OPB explist CPB 
        | tableconstructor 
		| string 
		| error '\n'
		;

tableconstructor: OCB fieldlist CCB 
		| OCB CCB
		| error '\n' 
		;

field	: OSB exp CSB ASSIGN exp 
		| NAME ASSIGN exp 
		| exp 
		| error '\n'
	  	;

fieldlist: fieldlist2 optfieldsep 
		| error '\n'
		;

fieldlist2: field 
		| fieldlist2 fieldsep field 
		| error '\n'
		;
optfieldsep: fieldsep 
		| /* empty */ 
		| error '\n'
		;

fieldsep: COMMA 
		| SEMICOLON 
		| error '\n'
		;

string	: STRING 
		| error '\n'
		;



/*
    opnd Priority
*/

op: opnd1 
        ;

opnd1: opnd1 OR opnd2 
        | opnd2 
        ;

opnd2: opnd2 AND opnd3 
        | opnd3 
        ;

opnd3: opnd3 LT opnd4 
        | opnd3 LTE opnd4 
        | opnd3 GT opnd4 
        | opnd3 GTE opnd4 
        | opnd3 NEQS opnd4 
        | opnd3 EQS opnd4 
        | opnd4 
        ;

opnd4: opnd4 APPEND opnd5 
        | opnd5 
        ;

opnd5: opnd5 PLUS opnd6 
        | opnd5 MINUS opnd6
        | opnd6 
        ;

opnd6: opnd6 TIMES opnd7 
        | opnd6 DIVIDE opnd7
        | opnd6 MODULO opnd7
        | opnd7 
        ;

opnd7: NOT opnd8 
        | SQUARE opnd8 
        | MINUS opnd8 
        | opnd8 
        ;

opnd8: opnd8 POWER opnd9 
        | opnd9 
        ;

opnd9: exp
        ;

%%

int main()
{
     yyin = fopen("test6.lua", "r");
    do{
        if(yyparse())
        {
            printf("\nFailure");
            exit(0);
        }

       }while(!feof(yyin));
    printf("\nSuccess"); 
 //   Display(); 
    return 0; 
 }

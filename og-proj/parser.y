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
		;

chunk2	: stat optsemi
	   	| chunk stat optsemi 
		;

optsemi	: SEMICOLON
		| 
		;

laststat: RETURN explist optsemi 
		| RETURN optsemi 
		| BREAK optsemi 
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
	 	;

forblock: FOR NAME ASSIGN exp COMMA exp DO block END 
		| FOR NAME ASSIGN exp COMMA exp COMMA exp DO block END 
		| FOR namelist IN explist DO block END 
		;
		
whileblock: WHILE exp DO block END 
        ;

ifblock	: iflist elsestat END 
		;
iflist: ifstat 
		| iflist elseifstat 
		;

ifstat: IF exp THEN block 
		;

elseifstat: ELSEIF exp THEN block 
		;

elsestat	: ELSE block 
		| /* empty */
		
		;

var		: NAME 
		| prefixexp OSB exp CSB 
		| prefixexp DOT NAME 
	 	;

varlist : var 
		| varlist COMMA var 
		;

funcname: funcname2 
		| funcname2 COLON NAME 
		;

funcname2: NAME 
		| funcname2 DOT NAME 
		;

namelist: NAME 
		| namelist COMMA NAME 
		;

exp		: NIL 
	 	| FALSE
		| TRUE 
		| NUMBER
		| string
		| function 
		| prefixexp
		| op 
		;

explist : exp
		| explist COMMA exp 
		;

prefixexp: var 
		| functioncall
		| OPB exp CPB 
		| OCB explist CCB
		;

function: FUNCTION funcbody ;

functioncall: prefixexp args
		| prefixexp COLON NAME args 
		;

funcbody: OPB parlist CPB block END 
		| OPB CPB block END 
		;

parlist	: namelist 
		| namelist COMMA TDOT 
		| TDOT 
		;

args	: OPB CPB 
		| OPB explist CPB 
        | tableconstructor 
		| string 
		;

tableconstructor: OCB fieldlist CCB 
		| OCB CCB 
		;

field	: OSB exp CSB ASSIGN exp 
		| NAME ASSIGN exp 
		| exp 
	  	;

fieldlist: fieldlist2 optfieldsep 
		;

fieldlist2: field 
		| fieldlist2 fieldsep field 
		;
optfieldsep: fieldsep 
		| /* empty */ 
		;

fieldsep: COMMA 
		| SEMICOLON 
		;

string	: STRING 
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

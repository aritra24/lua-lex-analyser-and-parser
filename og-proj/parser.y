%{
#include<stdio.h>
#include<stdlib.h>
#define YYSTYPE double
int yylex(); 
int yyerror(); 
extern FILE *yyin;  

%}
%define parse.error verbose
%locations

%token DO WHILE FOR REPEAT UNTIL IN END IF THEN ELSE ELSEIF PLUS MINUS TIMES DIVIDE POWER MODULO LT LTE GT GTE ASSIGN NEQS EQS AND APPEND SQUARE NOT OR LOCAL FUNCTION RETURN BREAK NIL FALSE TRUE NUMBER STRING TDOT NAME DOT COLON COMMA SEMICOLON OPB CPB OCB CCB OSB CSB 

%%
BLOCK	: CHUNK
		;

CHUNK	: CHUNK2 LASTSTAT 
		| CHUNK2 
		| LASTSTAT
		;

CHUNK2	: STAT optsemi
	   	| CHUNK STAT optsemi 
		;

optsemi	: SEMICOLON
		| 
		;

LASTSTAT: RETURN EXPLIST optsemi 
		| RETURN optsemi 
		| BREAK optsemi 
		;

STAT	: VARLIST ASSIGN EXPLIST 
		| LOCAL NAMELIST ASSIGN EXPLIST 
		| LOCAL NAMELIST 
		| FUNCTION funcname funcbody 
		| LOCAL FUNCTION NAME funcbody
		| functioncall 
		| DO BLOCK END 
        | WHILEBLOCK 
		| REPEAT BLOCK UNTIL EXP 
		| IFBLOCK 
		| forBLOCK
	 	;

forBLOCK: FOR NAME ASSIGN EXP COMMA EXP DO BLOCK END 
		| FOR NAME ASSIGN EXP COMMA EXP COMMA EXP DO BLOCK END 
		| FOR NAMELIST IN EXPLIST DO BLOCK END 
		;
		
WHILEBLOCK: WHILE EXP DO BLOCK END 
        ;

IFBLOCK	: IFlist ELSEstat END 
		;
IFlist: IFstat 
		| IFlist ELSEIFstat 
		;

IFstat: IF EXP THEN BLOCK 
		;

ELSEIFstat: ELSEIF EXP THEN BLOCK 
		;

ELSEstat	: ELSE BLOCK 
		| /* empty */
		
		;

VAR		: NAME 
		| PREFIXEXP OSB EXP CSB 
		| PREFIXEXP DOT NAME 
	 	;

VARLIST : VAR 
		| VARLIST COMMA VAR 
		;

funcname: funcname2 
		| funcname2 COLON NAME 
		;

funcname2: NAME 
		| funcname2 DOT NAME 
		;

NAMELIST: NAME 
		| NAMELIST COMMA NAME 
		;

EXP		: NIL 
	 	| FALSE
		| TRUE 
		| NUMBER
		| string
		| function 
		| PREFIXEXP
		| op 
		;

EXPLIST : EXP
		| EXPLIST COMMA EXP 
		;

PREFIXEXP: VAR 
		| functioncall 
		| OPB EXP CPB 
		;

function: FUNCTION funcbody ;

functioncall: PREFIXEXP args
		| PREFIXEXP COLON NAME args 
		;

funcbody: OPB parlist CPB BLOCK END 
		| OPB CPB BLOCK END 
		;

parlist	: NAMELIST 
		| NAMELIST COMMA TDOT 
		| TDOT 
		;

args	: OPB CPB 
		| OPB EXPLIST CPB 
        | tableconstructor 
		| string 
		;

tableconstructor: OCB fieldlist CCB 
		| OCB CCB 
		;

field	: OSB EXP CSB ASSIGN EXP 
		| NAME ASSIGN EXP 
		| EXP 
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
    Operator Priority
*/

op      : op_1 
        ;

op_1    : op_1 OR op_2 
        | op_2 
        ;

op_2    : op_2 AND op_3 
        | op_3 
        ;

op_3    : op_3 LT op_4 
        | op_3 LTE op_4 
        | op_3 GT op_4 
        | op_3 GTE op_4 
        | op_3 NEQS op_4 
        | op_3 EQS op_4 
        | op_4 
        ;

op_4    : op_4 APPEND op_5 
        | op_5 
        ;

op_5    : op_5 PLUS op_6 
        | op_5 MINUS op_6
        | op_6 
        ;

op_6    : op_6 TIMES op_7 
        | op_6 DIVIDE op_7
        | op_6 MODULO op_7
        | op_7 
        ;

op_7    : NOT op_8 
        | SQUARE op_8 
        | MINUS op_8 
        | op_8 
        ;

op_8    : op_8 POWER op_9 
        | op_9 
        ;

op_9    : EXP
        ;

%%

int main()
{
     yyin = fopen("in.txt", "r");
    do{
        if(yyparse())
        {
            printf("\n Failure");
            exit(0);
        }

       }while(!feof(yyin));
    printf("success"); 
    return 0; 
 }
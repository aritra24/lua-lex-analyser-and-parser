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
		| DO BLOCK END 
        | whileblock 
		| REPEAT BLOCK UNTIL exp 
		| ifblock 
		| forblock
	 	;

forblock: FOR NAME ASSIGN exp COMMA exp DO BLOCK END 
		| FOR NAME ASSIGN exp COMMA exp COMMA exp DO BLOCK END 
		| FOR namelist IN explist DO BLOCK END 
		;
		
whileblock: WHILE exp DO BLOCK END 
        ;

ifblock	: iflist elsestat END 
		;
iflist: ifstat 
		| iflist elseifstat 
		;

ifstat: IF exp THEN BLOCK 
		;

elseifstat: ELSEIF exp THEN BLOCK 
		;

elsestat	: ELSE BLOCK 
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
		;

function: FUNCTION funcbody ;

functioncall: prefixexp args
		| prefixexp COLON NAME args 
		;

funcbody: OPB parlist CPB BLOCK END 
		| OPB CPB BLOCK END 
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

op_9    : exp
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
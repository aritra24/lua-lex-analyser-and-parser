%{
#include<stdio.h>
#include<stdlib.h>
#define YYSTYPE double
int yylex(); 
int yyerror(); 
extern FILE *yyin;  

%}

%token DO WHILE FOR REPEAT UNTIL IN END IF THEN ELSE ELSEIF PLUS MINUS TIMES DIVIDE POWER MODULO LT LTE GT GTE ASSIGN NEQS EQS AND APPEND SQUARE NOT OR LOCAL FUNCTION RETURN BREAK NIL FALSE TRUE NUMBER STRING TDOT NAME DOT COL COMMA SC OPB CPB OCB CCB OSB CSB 

%%

CHUNK : OCB STAT OSB SC CSB CCB OSB LASTSTAT OSB SC CSB CSB
      ; 

BLOCK : CHUNK
      ; 

STAT :  VARLIST ASSIGN EXPLIST 
     | FUNCTIONCALL 
     | DO BLOCK END 
     | WHILE EXP DO BLOCK END 
     | REPEAT BLOCK UNTIL EXP
     | IF EXP THEN BLOCK OCB ELSEIF EXP THEN BLOCK CCB OSB ELSE BLOCK CSB END 
     | FOR NAME ASSIGN EXP COMMA EXP OSB COMMA EXP CSB DO BLOCK END
     | FOR NAMELIST IN EXPLIST DO BLOCK END 
     | FUNCTION FUNCNAME FUNCBODY 
     | LOCAL FUNCTION NAME FUNCBODY 
     | LOCAL NAMELIST OSB ASSIGN EXPLIST CSB 
     ;  

LASTSTAT : RETURN OSB EXPLIST CSB 
         | BREAK
         ; 

FUNCNAME : NAME OCB DOT NAME CCB OSB COL NAME CSB
         ; 

VARLIST : VAR OCB COMMA VAR CCB
        ; 

VAR :  NAME 
    | PREFIXEXP OSB EXP CSB
    | PREFIXEXP DOT NAME 
    ; 

NAMELIST : NAME OCB COMMA NAME CCB
         ; 

EXPLIST : OCB EXP COMMA CCB EXP
        ; 

EXP :  NIL 
    | FALSE 
    | TRUE 
    | NUMBER 
    | STRING 
    | TDOT 
    | FUNCTION1
    | PREFIXEXP 
    | TABLECONSTRUCTOR 
    | EXP BINOP EXP 
    | UNOP EXP 
    ; 

PREFIXEXP : VAR 
          | FUNCTIONCALL 
          | OPB EXP CPB
          ; 
FUNCTIONCALL :  PREFIXEXP ARGS 

| PREFIXEXP COL NAME ARGS 
             ; 

ARGS :  OPB OSB EXPLIST CSB CPB
     | TABLECONSTRUCTOR 
     | STRING 
    ; 

FUNCTION1 : FUNCTION FUNCBODY
          ; 

FUNCBODY : OPB OSB PARLIST CSB CPB BLOCK END
         ; 

PARLIST : NAMELIST OSB COMMA TDOT CSB 
        | TDOT
        ; 

TABLECONSTRUCTOR : OCB OSB FIELDLIST CSB CCB
                 ; 

FIELDLIST : FIELD OCB FIELDSEP FIELD CSB OSB FIELDSEP CSB
          ; 

FIELD : OSB EXP CSB ASSIGN EXP 
      | NAME ASSIGN EXP 
      | EXP
      ; 

FIELDSEP : COMMA 
         | SC
         ; 

BINOP : PLUS 
      | MINUS 
      | TIMES 
      | DIVIDE 
      | POWER 
      | MODULO
      | APPEND 
      | LT 
      | LTE 
      | GT 
      | GTE 
      | EQS 
      | NEQS 
      | AND 
      | OR
      ; 

UNOP : MINUS 
     | NOT 
     | SQUARE
     ; 
%%
int yyerror(char *msg)
{
    printf("Invalid expression\n");
    return 1;
}


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

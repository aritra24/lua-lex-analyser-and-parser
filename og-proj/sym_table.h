#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#define TableLength 30 

struct token
{
    char name[100];
    int index;
    unsigned int row,col;
    int type; 
}; 

typedef struct token Token; 

struct ListElement{
    struct token t;
    //char dtype[100]; 
    char type[100]; 
    int size;
    char scope;
    int argcount;
    int args[10]; 
    int scope_counter; 
    struct ListElement *next;
}; 

struct ListElement *TABLE[TableLength];

Token newToken(char name[],int type)
{
    Token t; 
    strcpy(t.name,name);
    t.type=type; 
    
    return t;  
}

int HASH(char* str,int bias)
{
    int sum=0;
    for(int i=0;i<strlen(str);i++)
        sum+=(str[i]*(i+1));
    sum+=bias; 
    //printf("hash of %s is %d\n",str,sum%29); 
    return sum%29;
}

void Initialize()
{
    for(int i=0;i<TableLength;i++)
        TABLE[i]=NULL;
}

void Display()
{
    printf("Hash-name-type-scope-argcount-arguments\n"); 
    for(int i=0;i<TableLength;i++)
    {
        struct ListElement* cur = TABLE[i];
        while(cur!=NULL)
        {
            printf("%d-%s-%s-%c%d-%d-",HASH(cur->t.name,0),cur->t.name,cur->type,cur->scope,cur->scope_counter,cur->argcount);
            if(cur->argcount>0)
                printf("%d",cur->args[0]);
            for(int i=1;i<cur->argcount;i++)
                printf(",%d",cur->args[i]);
            printf("\n"); 

            cur=cur->next; 
        }
    }
}

int SEARCH(char* str,int scope_counter)
{
    for(int i=0;i<TableLength;i++)
    {
        struct ListElement* cur = TABLE[i];
        while(cur!=NULL)
        {
            printf("inside search function %s and scope counter %d  \n",str,scope_counter); 
            if(strcmp(cur->t.name,str)==0 && scope_counter==cur->scope_counter)
            {
                printf("name found %s \n",cur->t.name);
                return 1; 

            }
            cur=cur->next; 
        }
    }
    return 0; 
}


void INSERT(struct token tk,char type[],char scope,int argcount,int args[],int scope_counter)
{
    printf("trying to insert %s with scope %c and scope counter %d and type %s \n",tk.name,scope,scope_counter,type); 

    if(scope=='\0')
    {
        printf("no scope \n");
        return; 
    }
    if(scope=='L')
    {
        if(SEARCH(tk.name,scope_counter)==1) return; 
    }
    else
    {
    printf("global \n",tk.name); 
    if(SEARCH(tk.name,0)==1) return; 

    }
    //if(SEARCH(tk.name,scope_counter)==1) return; 

    int val=HASH(tk.name,scope_counter);
    struct ListElement* cur= (struct ListElement*)malloc(sizeof(struct ListElement));
    cur->t=tk;
    cur->scope=scope; 
    strcpy(cur->type,type); 
    cur->argcount=argcount;
    if(scope=='L')
    cur->scope_counter=scope_counter; 
    else 
    cur->scope_counter=0; 
    cur->next=NULL; 
    for(int i=0;i<argcount;i++)
    {
        cur->args[i]=args[i];
                printf("arg[%d] is %d\n",i,args[i]); 

    }
    if(TABLE[val]==NULL)
        TABLE[val]=cur;
    else
    {
        struct ListElement* ele= TABLE[val];
        while(ele->next!=NULL)
            ele= ele->next; 
        ele->next =cur; 
    }
}

int funcFlag=0;
int scope_counter=0;
int argcount=0;
int lFlag=0; 
char scope='G'; 
int args[10]; 
int idFlag=0; 
char type[10]="var"; 
Token temp; 
int argflag=0; 

void insertUtil(Token t)
{
    printf("lexeme name is %s and type is %d  \n ",t.name,t.type); 
    if((t.type==2|| t.type==14) && argflag!=1)
    {
        strcpy(temp.name,t.name); 
    }

    if(strcmp(t.name,"local")==0)
    {
        lFlag=1; 
        scope='L'; 
    }

    if(t.type==16 || strcmp(t.name,";")==0)
    {
        scope='G'; 
    }
    if(funcFlag==1 && strcmp(t.name,"(")==0)
    {
        argflag=1; 
    }

    if(strcmp(t.name,"function")==0)
    {
        funcFlag=1;
        if(idFlag==1)
        {
            //update function
        }
        scope_counter++; 
    }
    if(t.type==2 && funcFlag==1)
    {
        //strcpy(args[argcount++],t.name);
        printf("for func name %s argument found %s \n",temp.name,t.name); 
        if(scope_counter==0)
        args[argcount++]=HASH(t.name,scope_counter); 
        else
        args[argcount++]=HASH(t.name,scope_counter-1); 
        printf("args[] value is %d \n",args[0]); 
    }
    if(strcmp(t.name,")")==0 && funcFlag==1)
    {
        //insert
        INSERT(temp,"func",scope,argcount,args,scope_counter); 
        argcount=0; 
        funcFlag=0;
        argflag=0; 
        return; 

    }

    if(strcmp(t.name,"repeat")==0| strcmp(t.name,"do")==0| strcmp(t.name,"then")==0| strcmp(t.name,"else")==0)
    {
        scope_counter++; 
    }
    if(strcmp(t.name,"end")==0 | strcmp(t.name,"until")==0)
    {
        scope_counter--; 
    }

    if(strcmp(t.name,";")==0)
    {
        lFlag=0; 
    }

    if(t.type==2)
    {
        idFlag=1; 
        if((argflag==0 && funcFlag==0) || (argflag==1 && funcFlag==1))
        INSERT(t,"var",scope,0,args,scope_counter); 
    }

    if(t.type==14 && funcFlag!=1)
    {
        INSERT(t,"func call",' ',0,0,scope_counter); 
    }
    
}


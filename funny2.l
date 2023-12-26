%{
#include <stdio.h>
#include "funny2.tab.h"
#include <stdlib.h>

void yyerror(const char *s);
void tokenToStr(int token);
int yycolumn_next = 1;
int yycolumn = 1;

//define YY_USER_ACTION \
//yycolumn = yycolumn_next; \
//if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}\
//else {yycolumn_next += strlen(yytext);}\

#define YY_USER_ACTION \
 yylval.id = strndup(yytext, yyleng);
  

int CommentLevel = 0;

%}

%option yylineno
%option nounput

%x COMMENTS

id          [A-Za-z][A-Za-z0-9_]*
num         [0-9]+

%%

"/*"             { BEGIN COMMENTS; CommentLevel++; }
<COMMENTS>"/*"   { CommentLevel++; }
<COMMENTS>"*/"   { CommentLevel--; if (CommentLevel == 0) BEGIN INITIAL; }
<COMMENTS>"\n"    yycolumn_next = 1;
<COMMENTS>.       ;

"\n"             { yycolumn_next = 1; }

[!#+*&=<>();,:]  { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);   return *yytext; }
"-"              {  yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);   return MINUS; }
"funny"          { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);    return FUNNY; }
"in"             { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);    return IN; }
"let"            { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);   return LET; }
"while"          { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);    return WHILE; }
"do"             {yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);} tokenToStr(0);  return DO; }
"if"             { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);    return IF; }
"then"           {yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);} tokenToStr(0);   return THEN; }
"else"           { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);    return ELSE; }
"ref"            {yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);} tokenToStr(0);   return REF; }
"not"            {yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);} tokenToStr(0);  return NOT; }
"type"           { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);    return TYPE; }

"||"             {yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);  return OR; }
"->"             {yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);} tokenToStr(0);  return ARROW; }
":="             { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0);    return ASSIGN; }

{id}             { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(1); yylval.id = strndup(yytext, yyleng); return ID; }

[ \t\r]+         {;}      // skip whitespace

{num}            {yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0); if(1073741823 >= atoi(yytext)) yylval.num = atoi(yytext); 
return NUM;
}

.                { yycolumn = yycolumn_next; 
if(yycolumn ==1) {yycolumn_next += strlen(yytext)-1;}
else {yycolumn_next += strlen(yytext);}tokenToStr(0); yyerror("Invalid character"); return *yytext; }

%%



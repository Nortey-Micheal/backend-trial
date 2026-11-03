#include <errno.h>
#include <stdint.h>
#include <stdlib.h>
int parse_amount(const char *text,int64_t *amount){if(text==NULL||amount==NULL||text[0]=='\0')return -1;for(const char *p=text;*p;p++)if(*p<'0'||*p>'9')return -1;errno=0;char *end=NULL;long long value=strtoll(text,&end,10);if(errno==ERANGE||end==text||*end!='\0'||value<=0)return -1;*amount=(int64_t)value;return 0;}

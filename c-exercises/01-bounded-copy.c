#include <stddef.h>
#include <string.h>
int bounded_copy(char *dst,size_t capacity,const char *src){if(dst==NULL||src==NULL||capacity==0)return -1;size_t n=strnlen(src,capacity-1);memcpy(dst,src,n);dst[n]='\0';return (int)n;}

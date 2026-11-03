#include <stddef.h>
#include <stdint.h>
int checked_sum(const int64_t *values,size_t length,int64_t *result){if(result==NULL||(length>0&&values==NULL))return -1;int64_t total=0;for(size_t i=0;i<length;i++){if((values[i]>0&&total>INT64_MAX-values[i])||(values[i]<0&&total<INT64_MIN-values[i]))return -1;total+=values[i];}*result=total;return 0;}

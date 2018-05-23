#include <sys/time.h>

#include <stdio.h>
#include "utils.h"
#include "logger.h"
void setTimeIndex(int* index,  struct timeval *position, double * result){
	struct timeval  tv2;
	gettimeofday(&tv2, NULL);
	int x = *index;
	if (x ==0 ){
    	x=4;
	}else{
		x--;
	}
	
		
	struct timeval   tv1 = position[x];

	double diff =  ( ((tv2.tv_sec) * 1000 + (tv2.tv_usec) / 1000) - ( (tv1.tv_sec) * 1000 + (tv1.tv_usec) / 1000 ));
	//(*result) = diff;
	//log_debug("Diff is %f index %d Previos %d", diff,(*index), x);
	
	if(*index < 5){
		position[*index] = tv2;
		result[*index]   = diff;
		(*index)++;
	}else{
		(*index) = 0;
        position[*index] = tv2;
		result[*index]   = diff;
	}
	
}

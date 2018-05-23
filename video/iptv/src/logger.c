#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdarg.h>
#include <string.h>
#include <sys/time.h>
#include <iconv.h>
#include "logger.h"

void print_wrapper(void *_unused, const char *psz_format, ...)
{
    char psz_fmt[strlen(psz_format) + 2];
    va_list args;
    va_start(args, psz_format);
    strcpy(psz_fmt, psz_format);
    strcat(psz_fmt, "\n");
    vprintf(psz_fmt, args);
    va_end(args);
}

char *iconv_append_null(const char *p_string, size_t i_length)
{
    char *psz_string = malloc(i_length + 1);
    memcpy(psz_string, p_string, i_length);
    psz_string[i_length] = '\0';
    return psz_string;
}


char *iconv_wrapper(void *_unused, const char *psz_encoding,
                           char *p_string, size_t i_length)
{
    char *psz_string, *p;
    size_t i_out_length;

    if (!strcmp(psz_encoding, psz_native_encoding))
        return iconv_append_null(p_string, i_length);

    if (iconv_handle != (iconv_t)-1 &&
        strcmp(psz_encoding, psz_current_encoding)) {
        iconv_close(iconv_handle);
        iconv_handle = (iconv_t)-1;
    }

    if (iconv_handle == (iconv_t)-1)
        iconv_handle = iconv_open(psz_native_encoding, psz_encoding);
    if (iconv_handle == (iconv_t)-1) {
        fprintf(stderr, "couldn't initiate conversion from %s to %s (%m)\n",
                psz_encoding, psz_native_encoding);
        return iconv_append_null(p_string, i_length);
    }
    psz_current_encoding = psz_encoding;

    /* converted strings can be up to six times larger */
    i_out_length = i_length * 6;
    p = psz_string = malloc(i_out_length);
    if (iconv(iconv_handle, &p_string, &i_length, &p, &i_out_length) == -1) {
        fprintf(stderr, "couldn't convert from %s to %s (%m)\n", psz_encoding,
                psz_native_encoding);
        free(psz_string);
        return iconv_append_null(p_string, i_length);
    }
    if (i_length)
        fprintf(stderr, "partial conversion from %s to %s\n", psz_encoding,
                psz_native_encoding);

    *p = '\0';
    return psz_string;
}


void debug(char* msg,...){
    va_list args;
	va_start( args, msg );	
	printMsg(args,"DEBUG");
    char buffer[4096];
	vsnprintf(buffer, sizeof(buffer), msg, args);
        printf("%s",buffer);
        msg = va_arg(args,  char*);
    va_end(args);
	printf("\n");
}

void info (char* msg,...){
	va_list args;
	va_start( args, msg );
	printMsg(args,"INFO");
    while (msg){
        printf("%s",msg);
        msg = va_arg(args, char *);
    }
    va_end(args);
    printf ( "\n");

}

void error(char* msg,...){
	va_list args;
    va_start( args, msg );
	printMsg(args,"ERROR");
	while (msg){
        printf("%s",msg);
        msg = va_arg(args, char *);
    }
    va_end(args);
    printf ( "\n");

}

void printMsg(va_list ap,char* level){
	struct tm  * timeinfo =getTime();	
	printf ( "[%02d/%02d/%d %02d:%02d:%02d] - %s - ", timeinfo->tm_mday ,
												 timeinfo->tm_mon + 1,
												 timeinfo->tm_year + 1900,
												 timeinfo->tm_hour, 
												 timeinfo->tm_min, 
												 timeinfo->tm_sec, level );
}

struct tm  * getTime(void){
	time_t rawtime;
  	time ( &rawtime );
    return localtime ( &rawtime );
}

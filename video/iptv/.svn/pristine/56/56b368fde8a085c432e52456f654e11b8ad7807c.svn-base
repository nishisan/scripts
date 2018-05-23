#ifndef LOGGER_H__
#define LOGGER_H__
#include <stddef.h>
#include <stdarg.h>
#include <iconv.h>

#define log_debug(...) debug(__VA_ARGS__, NULL)
#define log_info(...)  info(__VA_ARGS__, NULL)
#define log_error(...) error(__VA_ARGS__, NULL)

static const char *psz_native_encoding = "UTF-8";
static const char *psz_current_encoding = "";
static iconv_t iconv_handle = (iconv_t)-1;

void print_wrapper(void *_unused, const char *psz_format, ...);

char *iconv_wrapper(void *_unused, const char *psz_encoding,
				                           char *p_string, size_t i_length);

void debug(char* msg,...);

void info(char* msg,...);

void error(char* msg,...);

struct tm * getTime(void);

void printMsg(va_list ap,char* level);

#endif

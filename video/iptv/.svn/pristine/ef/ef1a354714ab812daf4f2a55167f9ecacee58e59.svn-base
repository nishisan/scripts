#ifndef IPTV_H__
#define IPTV_H__
#include <sys/types.h>

static const int ERR_PARAM      =  1;    /* invalid parameter(s) */
static const int ERR_REQ        =  2;    /* error parsing request */
static const int ERR_INTERNAL   =  3;    /* internal error */

static const int LQ_BACKLOG = 16;    /* server backlog value */
static const int RCV_LWMARK = 0;     /* low watermaek on the receiving (m-cast) socket */

static const char* IVERSION = "v 0.1b";
/* max size of string with IPv4 address */
#define IPADDR_STR_SIZE 16

/* max size of string with TCP/UDP port */
#define PORT_STR_SIZE   6

/* max length of an HTTP command */
#define MAX_CMD_LEN     31

/* max length of a command parameter (address:port, etc.) */
#define MAX_PARAM_LEN   79

/* max length of a command's supplementary part (URI-embedded variables) */
#define MAX_TAIL_LEN    255

static const int    ETHERNET_MTU        = 1500;

/* socket timeouts in seconds */
#define RLY_SOCK_TIMEOUT   5
#define SRVSOCK_TIMEOUT    1
#define SSEL_TIMEOUT       1

/* time-out (sec) to hold buffered data
 * before sending/flushing to client(s) */
#define DHOLD_TIMEOUT      1

/* time-out (sec) to hold buffered data
 * before sending/flushing to client(s) */
#define DHOLD_TIMEOUT      1

typedef u_short flag_t;
#if !defined( uf_TRUE ) && !defined( uf_FALSE )
    #define     uf_TRUE  ((flag_t)1)
    #define     uf_FALSE ((flag_t)0)
#else
    #error uf_TRUE or uf_FALSE already defined
#endif

#ifndef MAXPATHLEN
    #define MAXPATHLEN 1024
#endif

/* max size of string with IPv4 address */
#define IPADDR_STR_SIZE 16

typedef struct tmfd {
    int     fd;
    time_t  atime;
} tmfd_t;

void loadConfiguration(void);

#endif

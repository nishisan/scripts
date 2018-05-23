#include <stdio.h>
#include <stdlib.h>
#include <libconfig.h>
#include <syslog.h>
#include "configuration.h"

// This is The Main Configuration Object!
config_t cfg;


/**
  * Open The Syslog xD
  *
  */
void initSyslogger(){
	openlog("IPTV-ANALYZER", LOG_PID, LOG_USER);
	syslog(LOG_INFO, "IPTV-ANALYZER v0.1b starting - @Author: Lucas Nishimura<lucas.nishimura@gmail.com>");
}
/**
  * Loads system default configuration!
  *
  */
int loadConfiguration(void){
    config_init(&cfg);
    if(! config_read_file(&cfg, "iptv-analyzer.cfg")){
        printf("Failed Loading cofiguration: %s", config_error_text(&cfg));
    }else{
		char msg[1024];
		syslog(LOG_INFO,"Configurtion Read OK [%s]","iptv-analyzer.cfg");
		syslog(LOG_INFO,"Channel List File is [%s]",loadStringKey(&cfg,"server.channel-list-file"));
		return 0;		
    }
	return 1;
}

int main(int argc, char *argv[]){
	initSyslogger();
	loadConfiguration();
	return 0;
}

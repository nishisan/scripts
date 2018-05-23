#include <stdio.h>
#include <stdlib.h>
#include <libconfig.h>
#include <syslog.h>
#include "configuration.h"
#include "monitoring_group.h"
// This is The Main Configuration Object!
config_t cfg;
monitoring_group *groups;
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
		syslog(LOG_INFO,"Configuration Read OK [%s]","iptv-analyzer.cfg");
		syslog(LOG_INFO,"Channel List File is [%s]",loadStringKey(&cfg,"server.channel-list-file"));
		return 0;		
    }
	return 1;
}

int allocateArayGroupSize(){
	// max possibel channels
	int max = loadIntKey(&cfg,"server.max-channel-count");
	groups  = malloc(sizeof(monitoring_group) * max);  
}

int main(int argc, char *argv[]){
	initSyslogger();
	loadConfiguration();
	allocateArayGroupSize();
	return 0;
}

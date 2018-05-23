#include <stdio.h>
#include <stdlib.h>
#include <libconfig.h>
#include "utils.h"
#include "logger.h"
#include "iptv.h"
#include "configuration.h"
#include "flow_analyzer.h"
#include "flow_manager.h"
config_t cfg;
int configOk = 0;
int running  = 0;

/**
  * Loads configuration file
  */
void loadConfiguration(void){
    log_debug("\t Loading [iptv-analyzer.cfg] file");
    config_init(&cfg);
    if(! config_read_file(&cfg, "iptv-analyzer.cfg")){
        printf("Failed Loading cofiguration: %s", config_error_text(&cfg));
    }else{
        configOk =1;
    }
}


/**
  * Main
  */
int main(int argc, char *argv[]){
	log_debug("Starting IPTV-ANALYZER by @Nishisan v:0.1b");
	loadConfiguration();
	if(configOk){
		log_debug("\t\t My Instance name is:%s",loadStringKey(&cfg,"client.name"));
		running = 1;
		if(startFlowManager()){
			exit(0);
		}else{
			log_error("\t\t Failed to start Flow Manager");
		}
	}
	// couldnt load configuration file.... cant continue
	printf("ERROR");
	exit(1);
}


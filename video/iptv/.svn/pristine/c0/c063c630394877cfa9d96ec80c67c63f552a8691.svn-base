#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "configuration.h"
#include "logger.h"
#include "flow_analyzer.h"
#include "flow_manager.h"
#include "manager_thread.h"



void* managerThread(void* args){
    analyzer_info *info,*root;
    info =(analyzer_info*)args;
    root = info;
    //Just logs!
    while(info->running){
        while(info != NULL){
            if (info->root == 0){
                if (info->running ==0){
                    log_debug("Found Dead Thread %s ", info->mcast_group);
                    //info->running == -1; // marked for shutdown
					remove_analyzer_by_index(root,info->_index);
                    // Chama o shutdown
                    //root->threadcount--;
					if(strcmp(info->mcast_group,"239.232.31.21") == 0){
						sleep(5);
					add_analyzer(root,"239.232.31.21",5001,5000);
						start_list(root,NULL);
					}
                }
                //log_debug("OI From %s",info->mcast_group);
            }
            info = info->next;
        }
        sleep(1);
        info = root;
    }


    log_debug("Manager Thread is donee!!!!");
    return NULL;
}

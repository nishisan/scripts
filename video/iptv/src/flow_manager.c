#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include "configuration.h"
#include "logger.h"
#include "flow_analyzer.h"
#include "manager_thread.h"
#include <bitstream/mpeg/psi/pmt.h>
#include <bitstream/mpeg/psi/desc_0a.h>

config_t cfg;

//int maxThread  =0;
//int totalThread=0;


void reorder_info(analyzer_info* table){
    analyzer_info* root = table;
    int index = 0;
    while(root !=NULL){
        root->_index = index;
        index++;
        root = root->next;
    }
}

void free_descriptor(descriptor_table *table){
	//log_debug("Oi Vou free um descriptor");
    if (table->next !=NULL){
		//log_debug(" case 1");
        free_descriptor(table->next);
    }else{
        if (table->service_name) {
			//log_debug("Free Service Name");
			//free(table->service_name);
		}
		if (table->service_provider_name){
        	//log_debug("Free Service Provider Name");
			//free(table->service_provider_name);
		}
		
        free(table);
    }
}

void free_streams(stream_table *table){
    if (table->next !=NULL){
        free_streams(table->next);
    }else{
		if(table->_descriptors_size>0){
			free_descriptor(table->descriptors);
		}
        free(table);
    }

}

int shutdown_thread(analyzer_info *info){
	log_debug("Shutting down one thread");
	//free(info->sdt->descriptor->service_provider_name);
	log_debug("Free SDT Descriptor Name");
    //free(info->sdt->descriptor->service_name );
	// code not tested yet...
	log_debug("Free PAT");
	free(info->pat);
    if(info->sdt->descriptor!=NULL){
		log_debug("Has Descriptors to be Free");
		free(info->sdt->descriptor->service_provider_name);
		free(info->sdt->descriptor->service_name );
		free(info->sdt->descriptor);
	}

	log_debug("Going to Free SDT");
	free(info->sdt);
	log_debug("SDT OK");
	// ok for sdt
	if(info->pmt->descriptors_size > 0){
		//fazer loop
		log_debug("Going to free Descriptors");
		free_descriptor(info->pmt->descriptors);
	}
	log_debug("Done Descriptor");
	if (info->pmt->streams_size > 0){
		free_streams(info->pmt->streams);
	}
    free(info->pmt);
	// end of not tested code
    info->running = 0;
	pthread_join(info->thread,NULL);
	pthread_join(info->stats_thread,NULL);
	free(info);
    return 0;
}

void dump_infos(analyzer_info *infos){
	analyzer_info * info = infos;
	while (info != NULL) {
		if(1)
		if (info->root ==0){
			log_debug("Found Info at [%d] For Group: [%s]", info->_index,info->mcast_group);
			log_debug("\t Group: %s Name [%s] Got: %d ,packets Delta is %d RTP Packet Rate is [ %.2f /s ]",info->mcast_group,info->sdt->descriptor->service_name,info->packets,info->delta,info->rate);
			log_debug("\t Group: %s BitRate is %.2f Kb/s",info->mcast_group,info->brate);
			log_debug("\t Group: %s Pat Interval is %0.2f ms",info->mcast_group,info->pat->_times_result[2]);
			log_debug("\t Group: %s Has %d Streams at PMT",info->mcast_group,info->pmt->streams_size);
			if(info->pmt->streams_size > 0){
			if(info->pmt->streams != NULL){
           	 	stream_table* root =info->pmt->streams;
                	while(root !=NULL){
                    	//root->_match =0;
						log_debug("\t\tStream PID[%x] Type is:[%x]:= (%s)   Desc: %d" , root->elementary_pid,
										root->stream_type,pmt_get_streamtype_txt(root->stream_type),root->_descriptors_size);
						if (root->_descriptors_size> 0 ){
							descriptor_table *descriptor = root->descriptors;
							if(descriptor == NULL ) {
								log_debug("Descriptor is not here!");
							}
							while(descriptor !=NULL){
								log_debug("\t\t\tDescriptor Type: [%x]", descriptor->descriptor_tag); 
								descriptor = descriptor->next;
							}
						}
                    	root = root->next;
                	}
        		}	
			}
		}
        info = info->next;
    }
}

int remove_analyzer_first(analyzer_info * head) {
    int retval = -1;
    analyzer_info * next_node = NULL;

    if (head == NULL) {
        return -1;
    }

    next_node = (head)->next;
    retval = (head)->val;
    //free(*head);
	shutdown_thread(head);
    head = next_node;
	reorder_info(head);
    return retval;
}


int remove_analyzer_by_index(analyzer_info * head, int n) {
    log_debug("Trying to remove Thread %d" , n);
	int i = 0;
    int retval = -1;
    analyzer_info * current = head;
    analyzer_info * root    = head;
	analyzer_info * temp_node = NULL;

	if(current ==NULL){
		log_debug("SOU NULL");
	} 
	
	if (n == 0) {
        return remove_analyzer_first(head);
    }
	int x = 0;
    for ( x = 0; x < n-1; x++) {
        if (current->next == NULL) {
            return -1;
        }
        current = current->next;
    }
	

    temp_node 	  = current->next;
	current->next = temp_node->next;
	
	// Reordernar indices!
    shutdown_thread(temp_node);
	//free(temp_node);
	root->size--;
	reorder_info(head);
	return 0;
}

void start_list(analyzer_info *list,pthread_t *tid){
	log_debug("Starting Thread List Count: %d",list->threadcount);
	
	//if (!list->running){
		if (list->thread_pool == NULL){
			list->thread_pool = tid;
		}
		if(tid ==NULL){
			if ( list->thread_pool != NULL){
				tid = list->thread_pool;
			}else{
				return ;
			}
		}
        analyzer_info * current = list;
        while (current != NULL) {
			if(current->root != 1 && current->running == 0){
				log_debug("Commiting Group: %s to Thread ID: %d Root: %d", current->mcast_group, list->threadcount,current->root);
				pthread_create(&tid[list->threadcount],NULL,&analyzerFlowThread,current);
				current->thread = tid[list->threadcount];
				log_debug("Started Thread ID [%d]",  list->threadcount);
				current->running = 1;
				list->threadcount++;
			}else{
				//log_debug("Not OK!");
			}
			current = current->next;
        }
		list->running=1;
		if (!list->list_manager){
			log_debug("Creating Thread Manager Thread");
			pthread_create(&list->list_manager,NULL,&managerThread,list);
		}
    //}else{
	//	log_debug("Ooops something went wrong");
	//}
}


analyzer_info *create_monitoring(char *group,int port,int max_packets){
	analyzer_info *info = (analyzer_info*) malloc(sizeof(analyzer_info));
	if (info!=NULL){
		info->packets      							= 0;
		info->root									= 0;
		info->trouble_found							= 0;
		info->delta									= 0;
		info->brate									= 0;
		info->max_packets							= max_packets;
		info->config       							= &cfg;
		info->running      							= 0;
		info->mcast_port   							= port;
		info->mcast_group  							= group;
		info->pat		   							= (pat_table *) malloc(sizeof(pat_table));
		info->pat->_times_index						= 0;
		info->pat->_times_size                     = 0;
		info->sdt		   							= (sdt_table *) malloc(sizeof(sdt_table));
		info->pmt									= (pmt_table *) malloc(sizeof(pmt_table));
		info->pmt->descriptors_size					= 0 ;
		info->pmt->streams_size						= 0 ; 
		info->pmt->streams							= NULL;
		info->pmt->descriptors						= NULL;
		info->sdt->_descriptor_size					= 0;
		info->sdt->descriptor						= (descriptor_table *)  malloc(sizeof(descriptor_table));
		info->sdt->descriptor->service_name 		= malloc(sizeof(char) * 255);
		info->sdt->descriptor->service_provider_name= malloc(sizeof(char) * 255);
		sprintf(info->sdt->descriptor->service_name,"%s","N/A");
		sprintf(info->sdt->descriptor->service_provider_name,"%s","N/A");
		return info;
	}
}

analyzer_info *create_list(void){
    analyzer_info *info = (analyzer_info*) malloc(sizeof(analyzer_info));
    if (info!=NULL){
        info->packets                               = 0;
        info->root                                  = 1;
		info->size									= 0;
        info->delta                                 = 0;
		info->threadcount							= 0;
		info->thread_pool							= NULL;
        info->config                                = &cfg;
        info->running                               = 0;
        info->mcast_port                            = 0;
		info->rate									= 0;
		info->_index								= 0;
        info->mcast_group                           = "ROOT";
        info->pat                                   = (pat_table *) malloc(sizeof(pat_table));
        info->sdt                                   = (sdt_table *) malloc(sizeof(sdt_table));
		info->pmt                                   = (pmt_table *) malloc(sizeof(pmt_table));
        info->sdt->descriptor                       = (descriptor_table *)  malloc(sizeof(descriptor_table));
        info->sdt->descriptor->service_name         = malloc(sizeof(char) * 255);
        info->sdt->descriptor->service_provider_name= malloc(sizeof(char) * 255);
        sprintf(info->sdt->descriptor->service_name,"%s","ROOT");
        sprintf(info->sdt->descriptor->service_provider_name,"%s","ROOT");
        return info;
    }
}

void add_analyzer(analyzer_info * head,char *group,int port,int max_packets) {
    analyzer_info * current = head;
	int size = current->size;
    while (current->next != NULL) {
        current = current->next;
    }
    analyzer_info *info = create_monitoring(group,port,max_packets) ;
    info->_index  = current->_index+1; 
	current->next = info;
    
	current->next->val = current->val+1;
    current->next->next = NULL;
		
	current->size = size +1;

}

/*
analyzer_info *commitThread(char *group,int port,pthread_t *tid,analyzer_info *infos[]){
	analyzer_info *info = create_monitoring(group,port);
	log_debug("Trying to commit group [%s]:[%d]", group,port);
	pthread_create(&tid[totalThread],NULL,&analyzerFlowThread,info);	
	infos[totalThread] = info;
	totalThread++;
	return info;
}
*/
int startThradManager(void ){
	log_debug("\t\t\t Starting Thread Manager");
	int i,x = 0;
	int maxThread = (int) loadIntKey(&cfg,"client.max-threads");
	maxThread++; //beacause we have system thread;
	
	pthread_t tid[maxThread];	
	
	log_debug("\t\t\t Max Threads Size is [%d]",maxThread);

	
	analyzer_info *analyzer_list  = create_list();

	//add_analyzer(analyzer_list,"239.192.0.42",3001);	

	add_analyzer(analyzer_list,"239.232.41.11",5001,0);
	//add_analyzer(analyzer_list,"239.232.31.21",5001,0);
	//add_analyzer(analyzer_list,"239.232.111.11",5001,0);
	//add_analyzer(analyzer_list,"239.232.111.21",5001,0);
	//add_analyzer(analyzer_list,"239.232.111.31",5001,0);
	//add_analyzer(analyzer_list,"239.232.111.41",5001,0);
	//add_analyzer(analyzer_list,"239.232.31.31",5001,0);
 	//add_analyzer(analyzer_list,"239.232.31.41",5001,0);
	//add_analyzer(analyzer_list,"239.232.31.51",5001,0);
	//add_analyzer(analyzer_list,"239.192.0.32",3001);
	//add_analyzer(analyzer_list,"239.192.0.33",3001);
	//add_analyzer(analyzer_list,"239.192.0.34",3001);
	//add_analyzer(analyzer_list,"239.192.0.35",3001);
	//add_analyzer(analyzer_list,"239.192.0.36",3001);
	//add_analyzer(analyzer_list,"239.192.0.37",3001);
	//add_analyzer(analyzer_list,"239.192.0.38",3001);
	//add_analyzer(analyzer_list,"239.192.0.39",3001);
	//add_analyzer(analyzer_list,"239.192.0.40",3001);	
	//add_analyzer(analyzer_list,"239.192.0.41",3001);
	//add_analyzer(analyzer_list,"239.192.0.42",3001);
	//add_analyzer(analyzer_list,"239.192.0.43",3001);
	//add_analyzer(analyzer_list,"239.192.0.44",3001);
	//add_analyzer(analyzer_list,"239.192.0.45",3001);
	//add_analyzer(analyzer_list,"239.192.0.46",3001);
	//add_analyzer(analyzer_list,"239.192.0.47",3001);
	//add_analyzer(analyzer_list,"239.192.0.48",3001);
	//add_analyzer(analyzer_list,"239.192.0.49",3001);
	//add_analyzer(analyzer_list,"239.192.0.50",3001);
	//add_analyzer(analyzer_list,"239.192.0.51",3001);
	//dump_infos(analyzer_list);
	start_list(analyzer_list,tid);	



	// Create Threads
	//	for ( x=0;x<maxThread;x++){
	//
		//analyzer_info *g1 = create_monitoring("239.232.31.11",5001);
		//analyzer_info *g2 = create_monitoring("239.232.31.21",5001);

		//analyzer_info *g1 = create_monitoring("239.192.0.31",3001);
		//analyzer_info *g2 = create_monitoring("239.192.0.32",3001);
		//pthread_create(&tid[0],NULL,&analyzerFlowThread,g1);	
		//pthread_create(&tid[1],NULL,&analyzerFlowThread,g2);

	 	//commitThread("239.232.31.11",5001,tid,infos);
		//commitThread("239.232.111.11",5001,tid,infos);
		//commitThread("239.232.111.21",5001,tid,infos);

	//	commitThread("239.192.0.32",3001,tid,infos);
	//	commitThread("239.192.0.33",3001,tid,infos);
	//	commitThread("239.192.0.34",3001,tid,infos);
		//commitThread("239.192.0.35",3001,tid);
		//commitThread("239.192.0.36",3001,tid);
		//commitThread("239.192.0.37",3001,tid);
		//commitThread("239.192.0.38",3001,tid);
		//commitThread("239.192.0.39",3001,tid);
		//commitThread("239.192.0.40",3001,tid);
		//commitThread("239.192.0.41",3001,tid);
		//commitThread("239.192.0.42",3001,tid);
		//commitThread("239.192.0.43",3001,tid);
		//commitThread("239.192.0.44",3001,tid);
		//commitThread("239.192.0.45",3001,tid);
		//commitThread("239.192.0.46",3001,tid);
		//commitThread("239.192.0.47",3001,tid);
		//commitThread("239.192.0.48",3001,tid);
		//commitThread("239.192.0.49",3001,tid);
		//commitThread("239.192.0.50",3001,tid);
		//commitThread("239.192.0.51",3001,tid);
		//commitThread("239.192.0.52",3001,tid);
		//commitThread("239.192.0.53",3001,tid);
		//commitThread("239.192.0.54",3001,tid);
		//commitThread("239.192.0.55",3001,tid);
		//commitThread("239.192.0.56",3001,tid);
		//commitThread("239.192.0.57",3001,tid);



	for(;;){
		sleep(10);
		log_debug("main is running ");
		dump_infos(analyzer_list);
	}	

	
	log_debug("main waiting for thread to terminate...");
	for ( x=0;x<maxThread;x++){

		log_debug("Trying to join thread [%d]",x);
        pthread_join(tid[x],NULL);
    }
}


int startFlowManager(void){
    log_debug("\t\t\t Starting flow manager");
    startThradManager();
    return 1;
}


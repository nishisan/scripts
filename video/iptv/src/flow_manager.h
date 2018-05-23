#ifndef FLOWMANAGER_H__
#define FLOWMANAGER_H__
#include <pthread.h>
#include "flow_analyzer.h"
void free_descriptor(descriptor_table *table);
void free_streams(stream_table table);
void reorder_info(analyzer_info* table);
int remove_analyzer_by_index(analyzer_info * head, int n);
void dump_infos(analyzer_info *infos);
void add_analyzer(analyzer_info *head,char *group,int port,int max_packets);
int remove_analyzer_first(analyzer_info **head) ;
void start_list(analyzer_info *list,pthread_t *tid);
int startFlowManager(void);
int startThradManager(void);
int shutdown_thread(analyzer_info *info);
#endif

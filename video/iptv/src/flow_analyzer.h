#ifndef ANALYZER_H__
 #define ANALYZER_H__

#include <stdint.h>
#include "rtp.h"
#include "mpegts.h"

typedef struct info  {
    int packets;
	int max_packets;
	int delta;
	float rate;
	float brate;
	uint8_t *mcast_group;
	int  mcast_port;
    uint16_t *pid;
    sdt_table *sdt;
    pat_table *pat;
	pmt_table *pmt;
	config_t  *config;
	int bytes;

	int running;
	struct info *next;
	int val;	
	int root;
	int size;
	int _index;
	int threadcount;
	int trouble_found;
	pthread_t list_manager;
	pthread_t thread;
	pthread_t stats_thread;
	pthread_t *thread_pool;
} analyzer_info;

void remove_pmt_unmatched_descriptors(pmt_table* pmt,descriptor_table* root);

void add_pmt_descriptor(pmt_table *pmt,descriptor_table* table);

void reorder_tag_descriptors(descriptor_table* table);

void remove_tag_descriptor_first(descriptor_table * head);

void destroy_descriptor(descriptor_table  *descriptor);

int remove_tag_descriptor_by_index(pmt_table* table, int n);

int find_descriptor_index_by_tag(descriptor_table* table,uint8_t tag);

int tag_desc_exists(descriptor_table* table,uint8_t tag);

void* analyzerFlowThread(void* args);

int decode_rtp_packet(uint8_t* message,rtp_hdr_t* header,int recv,int* prev,analyzer_info* analyzer);

int decode_ts_packet(rtp_hdr_t* rtp_packet,transport_packet_header* ts_packet,analyzer_info* analyzer);

int decode_ts_pat(pat_table* pat,uint8_t* ts,analyzer_info* analyzer);

int decode_ts_sdt(sdt_table* sdt,uint8_t* ts);

int decode_ts_pmt(pmt_table* pmt,uint8_t* ts);

int decode_ts_pmt_descriptors(pmt_table* pmt,uint16_t length,uint8_t* ts);

descriptor_table *decode_descriptor(uint8_t* ts);

rtp_hdr_t *create_rtp_header(void);

void free_rtp_header( rtp_hdr_t *header );

#endif /* flow_analyzer.h */

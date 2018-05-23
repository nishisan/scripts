#ifndef FLOW_STREAM_H__
#define FLOW_STREAM_H__

#include <stdint.h>
#include "rtp.h"
#include "mpegts.h"

void remove_stream_unmatched_descriptors(stream_table *stream);

int stream_table_exists(stream_table* table,uint16_t tag);

void decode_ts_pmt_streams(pmt_table* pmt,uint8_t* ts,int size);

void add_stream_descriptor(stream_table *stream,descriptor_table* table);

void remove_stream_tag_descriptor_by_index(stream_table *stream, int n) ;

stream_table *create_stream(void);

stream_table *decode_stream(pmt_table* pmt,uint8_t *ts);

#endif

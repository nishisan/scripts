#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "configuration.h"
#include "flow_stream.h"
#include "logger.h"
#include <bitstream/mpeg/psi/pmt.h>
#include <bitstream/mpeg/psi/pmt_print.h>
#include <bitstream/mpeg/psi/desc_0a.h>
#include <bitstream/mpeg/psi/desc_28.h>

// Validar se vai ficar aqui
#include "flow_analyzer.h"

void destroy_stream(stream_table *stream){
	if (stream->descriptors){
		destroy_descriptor(stream->descriptors);
	}
	free(stream);

}

void remove_stream_unmatched_descriptors(stream_table *stream){
    descriptor_table* root =stream->descriptors;
    while(root !=NULL){
        if(root->_match ==0){
            remove_stream_tag_descriptor_by_index(stream,root->_index);
        }
        root = root->next;
    }
}


void remove_stream_tag_descriptor_by_index(stream_table *stream, int n) {
    int i = 0;
    int retval = -1;
    descriptor_table *head 		= stream->descriptors;
    descriptor_table * current 	= head;
    descriptor_table * root    	= head;
    descriptor_table * temp_node = NULL;

    if (n == 0) {
        remove_tag_descriptor_first(head);
        return ;
    }
    int x = 0;
    for ( x = 0; x < n-1; x++) {
        if (current->next == NULL) {
            return ;
        }
        current = current->next;
    }

    temp_node     = current->next;
    current->next = temp_node->next;

    // chama os metodos de free

    destroy_descriptor(temp_node);
    // Reordena os indices  
    reorder_tag_descriptors(root); //reordena
    stream->_descriptors_size--;
    // free(temp_node);
    //root->size--;
}




void add_stream_descriptor(stream_table *stream,descriptor_table* table){
    descriptor_table * current 	= stream->descriptors;
    int size 					= stream->_descriptors_size;
    if (current ==NULL){
        //pmt->descriptors          = decode_descriptor(ts);
        stream->descriptors            = table;
        stream->_descriptors_size       = 1;
        stream->descriptors->_index    = 0;
    }else{
        while (current->next != NULL) {
                current = current->next;
        }
        //descriptor_table *descriptor = decode_descriptor(ts);
        current->next = table;
        table->_index = current->_index +1;
        current->next->next = NULL;
        stream->_descriptors_size = size +1;
        //log_debug("Added Descriptor %x to position %d",descriptor->descriptor_tag,pmt->descriptors_size);
    }
}



int stream_table_exists(stream_table* table,uint16_t tag){
    stream_table* root = table;
    while(root !=NULL){
        if (root->elementary_pid == tag){
            root->_match =1;
            return root->_index;
        }
        root = root->next;
    }
    return -1;
}



stream_table *create_stream(void){
	stream_table *stream     = malloc(sizeof(stream_table));
    stream->_has_descriptors = 0;
	stream->_descriptors_size= 0;
    stream->next             = NULL;
	stream->_match			 = 1;
	stream->_index			 = 0;
	stream->descriptors		 = NULL;
	return stream;
}

stream_table *decode_stream(pmt_table* pmt,uint8_t *ts){

	stream_table *stream	 = create_stream();
	stream->stream_type      = (uint8_t)  (ts[0] );
    stream->reserved         = (uint8_t)  (ts[1] >> 5)  & 0x7 ;
    stream->elementary_pid   = (uint16_t) (ts[1] << 8) | ts[2] & 0x1FFF;
    stream->reserved2        = (uint8_t)  (ts[3] >> 4)  & 0xF ;
    stream->es_info_length   = (uint16_t) (ts[3] << 8) | ts[4] & 0xFFF;

	int byteDescIndex		 = 5;
	if (stream->es_info_length > 0){
		int descBytes        = (int) stream->es_info_length;
		// we have descriptors
		// Deal in another place
		if (stream->_has_descriptors == 0){
			stream->_has_descriptors  = 1;
			descriptor_table *table = stream->descriptors;
			while(table!=NULL){
            	table->_match = 0;
                table = table->next;
            }
	
			while(descBytes >0){
				stream->_descriptors_size++;
				uint8_t descripors[descBytes];
				memcpy(&descripors,&ts[byteDescIndex],descBytes);
				descriptor_table *descriptor = decode_descriptor(descripors);
				if (stream->descriptors == NULL){
					//stream->descriptors = descriptor;
					add_stream_descriptor(stream,descriptor);
					//table = stream->descriptors;
				}else{
					//check if descriptor already exists in our table
					if(tag_desc_exists(stream->descriptors,descriptor->descriptor_tag) < 0 ){
						add_stream_descriptor(stream,descriptor);	
					}else{
						destroy_descriptor(descriptor);
					}
					//table->next = descriptor;
					//table = table->next;
				}
				byteDescIndex 		= byteDescIndex + 2 + (int) descriptor->descriptor_length;
				descBytes 			= descBytes - 2 - (int) descriptor->descriptor_length;
				//log_debug("\tMy tag is %x DescByte is %d",descriptor->descriptor_tag,descBytes);
				//free(descriptor);
			}
			remove_stream_unmatched_descriptors(stream);

		}else{
			//log_debug("Exists");
		}
		// Validar como extrair os descriptors do stream
	}
	return stream;
}


void decode_ts_pmt_streams(pmt_table* pmt,uint8_t *ts,int size){
		int streamSize = 5;
		int byteIndex  = 0;

		//vamos ver se eu tenho streams;
		if(pmt->streams != NULL){
			stream_table* root =pmt->streams;
        		while(root !=NULL){
            		root->_match =0;
            		root = root->next;
        		}
		}else{
			//log_debug("No Stream Found Yet");
		}
	
		while(size >0){
			uint8_t streamBuffer[size];
			memcpy(&streamBuffer,&ts[byteIndex],size);
			stream_table *stream = decode_stream(pmt,streamBuffer);		
			size      = size - 5 - (int) stream->es_info_length;	
			byteIndex = byteIndex + 5 + (int) stream->es_info_length;
			//log_debug("Found PID %x", stream->elementary_pid);
			if (pmt->streams == NULL){
				//criou
				//log_debug("Created ROOT Stream with PID: %x" , stream->elementary_pid);
				pmt->streams 		= stream;
				pmt->streams_size	= 1;
			}else{
				if (stream_table_exists(pmt->streams,stream->elementary_pid) < 0){
					//addicione
					stream_table * current = pmt->streams;
    				while (current->next != NULL) {
        				current = current->next;
    				}
    				current->next = stream;
					current->next->_index = current->_index +1;
    				current->next->next = NULL;
					pmt->streams_size++;
					//log_debug("Adicionei!");
				}else{
					// Need to recheck the Descriptors!
					//log_debug("Já Existo!");
					destroy_stream(stream);
					stream = NULL;
				}
			}
		}

		if(pmt->streams != NULL){
        	stream_table* root =pmt->streams;
                while(root !=NULL){
                    if (root->_match == 0){
                    	//should be removed!
					}
					root = root->next;
                }
        }

}

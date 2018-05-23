#ifndef MPEGTS_H__
 #define MPEGTS_H__

#define SYNC_BYTE 0x47
#include <sys/time.h>

typedef struct
{
	uint8_t	 sync_byte:8;
    uint8_t  transport_error_indicator:1;
    uint8_t  payload_unit_start_indicator:1;
    uint8_t  transport_priority:1;
    uint16_t pid:13;
    uint8_t  transport_scrambling_control:2;
    uint8_t  adaptation_field_control:2;
    uint8_t  continuity_counter:4;
} transport_packet_header;

typedef struct
{
    uint8_t length;
    /* If length > 0 */
    uint8_t discontinuity_indicator:1;
    uint8_t random_access_indicator:1;
    uint8_t elementary_stream_priority_indicator:1;
    uint8_t pcr_flag:1;
    uint8_t opcr_flag:1;
    uint8_t splicing_point_flag:1;
    uint8_t transport_private_data_flag:1;
    uint8_t extension_flag:1;
    /* If splicing_point_flag == 1 */
    int8_t splice_countdown;
    /* If transport_private_data_flag == 1 */
    uint8_t transport_private_data_length;
} adaptation_field_header;

typedef struct
{
    uint64_t reference_base:33;
    uint8_t  reserved:6;
    uint16_t reference_extension:9;
} pcr;

typedef struct
{
    uint64_t reference_base:33;
    uint8_t  reserved:6;
    uint16_t reference_extension:9;
} opcr;

typedef struct
{
    uint8_t  length;
    uint8_t  ltw_flag:1;
    uint8_t  piecewise_rate_flag:1;
    uint8_t  seamless_splice_flag:1;
    /* If ltw_flag == 1 */
    uint8_t  ltw_valid_flag:1;
    uint16_t ltw_offset:15;
    /* If piecewise_rate_flag == 1 */
    uint8_t  piecewise_reserved:2;
    uint32_t piecewise_rate:22;
    /* If seamless_splice_flag == 1 */
    uint8_t  splice_type:4;
    uint64_t dts_next_au:33;
} adaptation_field_extension;

typedef struct
{
	uint8_t  tid:8;
	uint8_t	 syntax_indicator:1;
	uint8_t  reserved:2;
	uint16_t length:12;
	uint16_t transport_streamid:16;
	uint8_t	 reserved2:2;
	uint8_t	 version_number:5;
	uint8_t	 current_next_indicator:1;
	uint8_t	 section_number:8;
	uint8_t	 last_section_number:8;
	uint16_t program_number:16;	
	uint8_t  reserved3:3;
	uint16_t network_pid:13;
	uint16_t program_map_pid:13;
	struct 	 timeval  _times[5];	
	double	 _times_result[5];
	int      _times_index;
	int		_times_size;
	double	_pat_interval;
} pat_table;

typedef struct descriptor_table
{
    uint8_t descriptor_tag:8;
    uint8_t descriptor_length:8;
    uint8_t adaptation_field_data_identifier:8;
    uint8_t service_type:8;
    uint8_t service_provider_name_length:8;
    char *service_provider_name;
	uint8_t service_name_length:8;
	char *service_name;
	uint8_t external_clock_reference:1;
	uint8_t reserved:1;
	uint8_t	accuracy_integer:6;
	uint8_t accuracy_exponent:3;
	uint8_t reserved2:5;
	struct descriptor_table* next;
	int		_match;
	int		_index;
} descriptor_table;

typedef struct
{
	uint8_t  tid:8;
	uint8_t  syntax_indicator:1;
	uint8_t  reserved:3;
	uint16_t length:12;
	uint16_t transport_streamid:16;
	uint8_t  reserved2:2;
	uint8_t  version_number:5;
	uint8_t  current_next_indicator:1;
    uint8_t  section_number:8;
    uint8_t  last_section_number:8;
	uint16_t original_network_id:16;
	int8_t   reserved3:8;
	uint16_t service_id:16;
	uint8_t  reserved4:6;
	uint8_t	 eit_schedule_flag:1;
	uint8_t	 eit_present_following_flag:1;
	uint8_t	 running_status:3;
	uint8_t	 free_ca_mode:1;
	uint16_t descriptors_loop_length:12;
	int		_descriptor_size;
	descriptor_table *descriptor;
} sdt_table;

typedef struct stream_table
{
	uint8_t 	stream_type:8;
	uint8_t		reserved:3;
	uint16_t	elementary_pid:13;
	uint8_t		reserved2:4;
	uint16_t	es_info_length:12;
	descriptor_table	*descriptors;	
	struct stream_table	*next;
	int		_has_descriptors;	
	int		_descriptors_size;
	int     _match;
	int     _index;
} stream_table;

typedef struct
{
    uint8_t  tid:8;
    uint8_t  syntax_indicator:1;
    //carefull cause its really 2 fields one bit 0 and 2 bits reserved!
    uint8_t  reserved:3;
    uint16_t length:12;
    uint16_t transport_streamid:16;
    uint8_t  reserved2:2;
    uint8_t  version_number:5;
    uint8_t  current_next_indicator:1;
    uint8_t  section_number:8;
    uint8_t  last_section_number:8;
    uint8_t  reserved3:3;
    uint16_t pcr_pid:13;
    uint8_t  reserved4:4;
    uint16_t program_info_length:12;
    int      descriptors_size;
    int      streams_size;
    descriptor_table* descriptors;
    stream_table* streams;
} pmt_table;


#endif /* mpegts.h */

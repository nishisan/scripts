AM_FLAGS   	=  --pedantic -Wall -std=c99 -O3 
AM_LDFLAGS 	= -g -O3 

LIBS = -Ilibconfig -Llibconfig -lconfig -pthread -lpthread
# this lists the binaries to produce, the (non-PHONY, binary) targets in:
# the previous manual Makefile
iptv_analyzer_CPPFLAGS = -I../libs
bin_PROGRAMS = iptv-analyzer
iptv_analyzer_SOURCES = configuration.h configuration.c monitoring_group.h iptv_analyzer.h iptv_analyzer.c

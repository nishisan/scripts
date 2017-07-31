#!/bin/bash
INPUT=$1;
OUTPUT=$2;
OUTDIR=/var/www/html/censura/;

while [ true ];
 do

	ffmpeg -i ${INPUT} -f segment -segment_time 600 -acodec libmp3lame  -strftime 1 "${OUTDIR}%Y-%m-%d_%H-%M-%S${OUTPUT}.mp3"	
    sleep 1 
 done

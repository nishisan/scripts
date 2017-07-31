#!/bin/bash
# @author: Lucas Nishimura
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
SOURCE_FILE=""$1"";
PREFIX="$2";
HLS_TIME=10;
GOP_INTERVAL=60
FRAME_RATE=30
H264_PRESET=fast;
MASTER_FILE=$DIR/out/${PREFIX}.m3u8;
TUNE=movie;
LEVEL=4.1;
PROFILE=high;
BRATES0="256k";
BRATES1="512k";
BRATES2="1024k";
BRATES3="1512k";
BRATES4="2048k";
# 1920x856
#while [ true ]
#do

 ffmpeg -re -y -i "$1" \
        -map 0:0 -map 0:1 -sn \
		-user-agent "Mozilla/5.0 (Linux; Android 6.0.1; SM-J500M Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36"\
        -vbsf h264_mp4toannexb \
        -flags -global_header \
        -pix_fmt yuv420p\
		-c:v libx264 -x264opts "keyint=$GOP_INTERVAL:min-keyint=$GOP_INTERVAL:pic-struct:no-scenecut:scenecut=-1" -movflags fragkeyframe \
		-vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
        -bufsize 1835k   \
		-b:v 2048k \
        -maxrate 3120k \
		-c:a libfdk_aac\
        -b:a 90k -ac 2 \
        -hls_time $HLS_TIME \
		-hls_list_size 30 -hls_wrap 30 \
		-hls_flags  delete_segments \
        -start_number 0 \
        /var/www/html/live/live.m3u8 
	sleep 5
	rm /var/www/html/live/*
#done

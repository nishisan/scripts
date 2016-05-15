#!/bin/bash
# @author: Lucas Nishimura
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
SOURCE_FILE=""$1"";
PREFIX="$2";
HLS_TIME=10;
GOP_INTERVAL=46;
FRAME_RATE=23.98;
VIDEO_TIME=$(ffprobe "$SOURCE_FILE" 2>&1 | grep Duration | awk '{print $2}' | sed s/\,//g;);
H264_PRESET=veryslow;
MASTER_FILE=$DIR/out/${PREFIX}.m3u8;
TUNE=animation;
LEVEL=4.1;
PROFILE=high;
BRATES0="256k";
BRATES1="512k";
BRATES2="1024k";
BRATES3="2048k";
BRATES4="3072k";
ffmpeg  -y -i "$1" \
        -map 0:0 -map 0:1 -sn -t $VIDEO_TIME \
        -vbsf h264_mp4toannexb \
        -flags -global_header \
        -pix_fmt yuv420p\
        -c:v libx264 -x264opts pic-struct:no-scenecut -movflags fragkeyframe  \
        -vprofile ${PROFILE} -level ${LEVEL} -tune ${TUNE} -preset $H264_PRESET \
        -g $GOP_INTERVAL -keyint_min $GOP_INTERVAL\
        -bufsize 1835k   \
        -filter:v scale=480:-1 \
        -b:v ${BRATES0} -r $FRAME_RATE \
        -maxrate ${BRATES0} \
        -c:a libfdk_aac \
        -b:a 64000 -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES0}.m3u8 \
        -filter:v scale=480:-1 \
        -b:v ${BRATES1} -r $FRAME_RATE \
        -maxrate ${BRATES1} \
        -c:a libfdk_aac \
        -b:a 128000 -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES1}.m3u8 \
	-filter:v scale=960:-1 \
        -b:v ${BRATES2} -r $FRAME_RATE \
        -maxrate ${BRATES2} \
        -c:a libfdk_aac \
        -b:a 128000 -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES2}.m3u8 \
	-filter:v scale=1400:-1 \
        -b:v ${BRATES3} -r $FRAME_RATE \
        -maxrate ${BRATES3} \
        -c:a libfdk_aac \
        -b:a 128000 -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES3}.m3u8 \
	-filter:v scale=1920:-1 \
        -b:v ${BRATES4} -r $FRAME_RATE \
        -maxrate ${BRATES4} \
        -c:a libfdk_aac \
        -b:a 128000 -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES4}.m3u8 

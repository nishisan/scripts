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
TUNE=movie;
LEVEL=4.1;
PROFILE=high;
BRATES0="256k";
BRATES1="512k";
BRATES2="1512k";
ffmpeg  -y -i "$1" \
        -map 0:0 -map 0:1 -sn -t $VIDEO_TIME \
        -vbsf h264_mp4toannexb \
        -flags -global_header \
        -pix_fmt yuv420p\
        -c:v libx264 -x264opts 'keyint=24:min-keyint=24:pic-struct:no-scenecut' -movflags fragkeyframe  \
        -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
        -g $GOP_INTERVAL -keyint_min $GOP_INTERVAL\
        -bufsize 1835k   \
        -filter:v scale=-1:360 \
        -b:v ${BRATES0} -r $FRAME_RATE \
        -maxrate ${BRATES0} \
        -c:a libfdk_aac \
        -b:a 64k -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES0}.m3u8 \
        -filter:v scale=-1:540 \
        -b:v ${BRATES1} -r $FRAME_RATE \
        -maxrate ${BRATES1} \
        -c:a libfdk_aac \
        -b:a 128k -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES1}.m3u8\
        -filter:v scale=-1:536 \
        -b:v ${BRATES2} -r $FRAME_RATE \
        -maxrate ${BRATES2} \
        -c:a libfdk_aac \
        -b:a 128k -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES2}.m3u8

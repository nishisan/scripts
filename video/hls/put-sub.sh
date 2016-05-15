#!/bin/bash
# @author: Lucas Nishimura
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
SOURCE_FILE=$1;
SUB_FILE=$2;
PREFIX=$3;
HLS_TIME=10;
GOP_INTERVAL=46;
FRAME_RATE=23.98;
VIDEO_TIME=$(ffprobe $SOURCE_FILE 2>&1 | grep Duration | awk '{print $2}' | sed s/\,//g;);
ORIG_BITRATE=$(ffprobe $SOURCE_FILE 2>&1 | grep bitrate |grep Duration | awk '{print $6}' | sed s/\,//g;);
ORIG_BITRATE="512k";
H264_PRESET=fast;
nohup \
/app/encoder/ffmpeg/ffmpeg  -y -i $1 \
        -map 0 -sn -t $VIDEO_TIME \
        -vbsf h264_mp4toannexb \
        -flags -global_header \
        -pix_fmt yuv420p\
        -c:v libx264 -x264opts pic-struct:no-scenecut -movflags +faststart \
        -vprofile baseline -preset $H264_PRESET \
        -g $GOP_INTERVAL -keyint_min $GOP_INTERVAL\
        -filter:v scale=480:-1 \
        -bufsize 1835k   \
        -vf "ass=$SUB_FILE" \
        -b:v ${ORIG_BITRATE}k -r $FRAME_RATE \
        -maxrate ${ORIG_BITRATE}k \
        -c:a copy \
        -threads 12\
        $DIR/out/${PREFIX}_sub.ts \
        > /dev/null 2>&1  &
PID_VIDEO=$!;
echo started $PID_VIDEO


#!/bin/bash
# @author: Lucas Nishimura
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
SOURCE_FILE=""$1"";
PREFIX="$2";
HLS_TIME=10;
GOP_INTERVAL=48;
FRAME_RATE=24;
VIDEO_TIME=$(ffprobe "$SOURCE_FILE" 2>&1 | grep Duration | awk '{print $2}' | sed s/\,//g;);
ORIG_BITRATE=$(ffprobe "$SOURCE_FILE"  2>&1 | grep bitrate |grep Duration | awk '{print $6}')
H264_PRESET=veryslow;
ORIG_FRAME_RATE=$(ffprobe "${SOURCE_FILE}"  2>&1| grep ",* fps" | cut -d "," -f 5 | cut -d " " -f 2 | perl -e  'use POSIX; print ceil(<>)' )
VIDEO_RES=$(ffprobe "${SOURCE_FILE}" 2>&1 | grep Stream | grep -oP ', \K[0-9]+x[0-9]+' | awk -F 'x' '{print $1}')
AUDIO_RATE=$(ffprobe "${SOURCE_FILE}"  2>&1 | grep Stream | grep Audio  |grep -oP ', \K[0-9]+ kb' | sed s/\\skb//g)
FRAME_RATE=$ORIG_FRAME_RATE;
GOP_INTERVAL=$(( $FRAME_RATE *2 ));


MASTER_FILE=$DIR/out/${PREFIX}.m3u8;
TUNE=movie;
LEVEL=4.1;
PROFILE=high;
BRATES0="256k";
BRATES1="512k";
BRATES2="1024k";
BRATES3="1512k";
BRATES4="2048k";
BRATES5="3072k";


LASTRATE="256";
OUTSCRIPT=/tmp/${PREFIX}.sh;
cat  > $OUTSCRIPT  <<  "EOF"
ffmpeg  -y -i "$1" \
        -map 0:0 -map 0:1 -sn -t $VIDEO_TIME \
        -vbsf h264_mp4toannexb \
        -flags -global_header \
        -pix_fmt yuv420p \
EOF
echo "Resolution: $VIDEO_RES :  Bitrate: $ORIG_BITRATE  Audio Rate: $AUDIO_RATE  Script :[$OUTSCRIPT]"
$DIR/calculate-steps.pl $VIDEO_RES $ORIG_BITRATE $AUDIO_RATE $OUTSCRIPT

source $OUTSCRIPT
rm -fv $OUTSCRIPT

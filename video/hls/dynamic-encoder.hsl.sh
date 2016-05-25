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
        -pix_fmt yuv420p\
        -c:v libx264 -x264opts 'keyint=48:min-keyint=48:pic-struct:no-scenecut' -movflags fragkeyframe  \
        -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
        -g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
        -bufsize ${BRATES0}   \
        -filter:v "scale=iw*.10:-2" \
        -b:v ${BRATES0} -r $FRAME_RATE \
        -maxrate ${BRATES0} \
        -c:a aac \
        -b:a 32k -ac 1 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES0}.m3u8 \
EOF

if [ "$ORIG_BITRATE" -gt "512" ]; then
LASTRATE="512";
cat  >> $OUTSCRIPT  <<  "EOF"
   	-filter:v scale=iw*.20:-1 \
	 -bufsize ${BRATES1}   \
	-b:v ${BRATES1} -r $FRAME_RATE \
	-c:v libx264 -x264opts 'keyint=48:min-keyint=48:pic-struct:no-scenecut' -movflags fragkeyframe  \
	-vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
	-g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
	-maxrate ${BRATES1} \
	-c:a aac \
	-b:a 64k -ac 2 \
	-hls_time $HLS_TIME -hls_list_size 0 \
	-start_number 0 \
	${DIR}/out/${PREFIX}_${BRATES1}.m3u8 \
EOF
fi

if [ "$ORIG_BITRATE" -gt "1024" ]; then
LASTRATE="1024";
cat  >> $OUTSCRIPT  <<  "EOF"
        -filter:v "scale=iw*.40:-2" \
	-bufsize ${BRATES2}   \
        -b:v ${BRATES2} -r $FRAME_RATE \
        -c:v libx264 -x264opts 'keyint=48:min-keyint=48:pic-struct:no-scenecut' -movflags fragkeyframe  \
        -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
        -g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
        -maxrate ${BRATES2} \
        -c:a aac \
        -b:a 96k -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES2}.m3u8 \
EOF
fi

if [ "$ORIG_BITRATE" -gt "1512" ]; then
LASTRATE="1512";
cat  >> $OUTSCRIPT  <<  "EOF"
        -filter:v scale=iw*.75:-2 \
	-bufsize ${BRATES3}   \
        -b:v ${BRATES3} -r $FRAME_RATE \
        -c:v libx264 -x264opts 'keyint=48:min-keyint=48:pic-struct:no-scenecut' -movflags fragkeyframe  \
        -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
        -g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
        -maxrate ${BRATES3} \
        -c:a aac \
        -b:a 96k -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES3}.m3u8    \
EOF
fi

if [ "$ORIG_BITRATE" -gt "2048" ]; then
LASTRATE="2048";
cat  >> $OUTSCRIPT  <<  "EOF"
    -filter:v scale=-1:-1 \
        -bufsize ${BRATES4}   \
        -b:v ${BRATES4} -r $FRAME_RATE \
        -c:v libx264 -x264opts 'keyint=48:min-keyint=48:pic-struct:no-scenecut' -movflags fragkeyframe  \
        -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
        -g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
        -maxrate ${BRATES4} \
        -c:a aac \
        -b:a 128k -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES4}.m3u8   \
EOF
fi

if [ "$ORIG_BITRATE" -gt "3072" ]; then
LASTRATE="3072"
cat  >> $OUTSCRIPT  <<  "EOF"
        -filter:v scale=-1:-1 \
        -bufsize ${BRATES5}   \
        -b:v ${BRATES5} -r $FRAME_RATE \
        -c:v libx264 -x264opts 'keyint=48:min-keyint=48:pic-struct:no-scenecut' -movflags fragkeyframe  \
        -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
        -g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
        -maxrate ${BRATES5} \
        -c:a aac \
        -b:a 160k -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${BRATES5}.m3u8   \
EOF
fi

DIFF=$(expr $ORIG_BITRATE - $LASTRATE);
if [ "$DIFF" -gt "150" ]; then
cat  >> $OUTSCRIPT  <<  "EOF"
        -filter:v scale=-1:-1 \
        -bufsize ${ORIG_BITRATE}k   \
        -b:v  ${ORIG_BITRATE}k -r $FRAME_RATE \
        -c:v libx264 -x264opts 'keyint=48:min-keyint=48:pic-struct:no-scenecut' -movflags fragkeyframe  \
        -vprofile ${PROFILE} -level ${LEVEL}  -preset $H264_PRESET \
        -g ${FRAME_RATE} -keyint_min $GOP_INTERVAL\
        -maxrate ${ORIG_BITRATE}k \
        -c:a aac \
        -b:a 160k -ac 2 \
        -hls_time $HLS_TIME -hls_list_size 0 \
        -start_number 0 \
        ${DIR}/out/${PREFIX}_${ORIG_BITRATE}k.m3u8   \

EOF
fi


cat  $OUTSCRIPT
#source $OUTSCRIPT
#rm -fv $OUTSCRIPT

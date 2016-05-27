#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
VIDEO_FILE=$1;
SUB_FILE=$2;
PREFIX=$3;


# first part fix sub
FIX_SUB_FILE="$DIR/subs/out/${PREFIX}_sub.ass";
$DIR/fix-sub.sh "${SUB_FILE}" "${FIX_SUB_FILE}";

# BURN SUB IN VIDEO
SUBBED_VIDEO="$DIR/out/${PREFIX}_subbed.mp4";
$DIR/put-sub.sh "${VIDEO_FILE}" "${FIX_SUB_FILE}" "${SUBBED_VIDEO}"


# HLS ENCONDING
$DIR/dynamic-encoder.hls.sh "${SUBBED_VIDEO}" "${PREFIX}"

#MASTERPLAYLIST
$DIR/build-master.sh "${PREFIX}" >> "$DIR/${PREFIX}_master.m3u8";
mv "$DIR/${PREFIX}_master.m3u8" "$DIR/out/"




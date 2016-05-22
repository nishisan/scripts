#!/bin/bash
# @author: Lucas Nishimura
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
SOURCE_FILE=$1;
SUB_FILE=$2;
OUTFILE=$3;
FRAME_RATE=23.98;
ffmpeg -i "${SOURCE_FILE}" -vf "ass=${SUB_FILE}" "${OUTFILE}" 

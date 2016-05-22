#!/bin/bash
# @author: Lucas Nishimura
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
PREFIX=$1;
echo "#EXTM3U"
echo "#EXT-X-PLAYLIST-TYPE:VOD"

for IDX in $(ls out/${PREFIX}*.m3u8) 
do
 #echo ${IDX}
 RESOLUTION=$(ffprobe ${IDX} 2>&1 | grep Stream | grep Video | grep -o -E "([0-9]{2,})x([0-9]*)")
 FILE=$(echo ${IDX}| rev | cut -d"/" -f1 | rev)
 BWD=$(echo ${IDX} | rev | cut -d"/" -f1 | rev | sed s/k.m3u8//g | sed "s/${PREFIX}_//g") 
 echo "#EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=${BWD}000, RESOLUTION=${RESOLUTION}"
 echo $FILE
done

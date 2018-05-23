#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

#SCRIPT OPTIONS
TARGET_DIR=${DIR}/mediainfo_build
SOURCE_DIR=${DIR}/mediainfo_sources
mkdir -p ${TARGET_DIR}
mkdir -p ${SOURCE_DIR}
export makeflags='-j 8'

#
cd $SOURCE_DIR
git clone https://github.com/MediaArea/MediaInfo.git


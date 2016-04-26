#!/bin/bash
#Install Basic Tools
# Script DIR
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );
source $DIR/../../bash-libs/functions.sh
#SCRIPT OPTIONS
TARGET_DIR=${DIR}/build
SOURCE_DIR=${DIR}/sources

mkdir -p ${TARGET_DIR}
mkdir -p ${SOURCE_DIR}

#sudo yum -y install gcc gcc-c++ make flex bison gperf ruby   openssl-devel freetype-devel fontconfig-devel libicu-devel sqlite-devel   libpng-devel libjpeg-devel

cd ${SOURCE_DIR}
evalCmd git clone git://github.com/ariya/phantomjs.git
cd phantomjs
evalCmd git checkout 2.1.1
evalCmd git submodule init
evalCmd git submodule update
okLog This will Take a really long time...
evalCmd ./build.py --confirm --silent

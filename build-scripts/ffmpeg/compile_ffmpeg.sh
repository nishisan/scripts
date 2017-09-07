#!/bin/bash
#Install Basic Tools
# Script DIR
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

#SCRIPT OPTIONS
TARGET_DIR=${DIR}/ffmpeg_build
SOURCE_DIR=${DIR}/ffmpeg_sources
mkdir -p ${TARGET_DIR}
mkdir -p ${SOURCE_DIR}
export makeflags='-j 4'

# yum -y install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel fontconfig.x86_64 fontconfig-devel.x86_64 fribidi-devel.x86_64 fribidi;
cd  ${SOURCE_DIR}
#rm * -frv

# Download everything first

# YASM
git clone --depth 1 git://github.com/yasm/yasm.git
git clone --depth 1 git://git.videolan.org/x264
hg clone https://bitbucket.org/multicoreware/x265
git clone https://github.com/libass/libass.git
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
curl -L -O https://ftp.osuosl.org/pub/xiph/releases/opus/opus-1.2.tar.gz 
curl -L -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
curl -L -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
git clone http://source.ffmpeg.org/git/ffmpeg.git


# YASM
#git clone --depth 1 git://github.com/yasm/yasm.git
cd yasm
autoreconf -fiv
./configure --prefix="${TARGET_DIR}" --bindir="${TARGET_DIR}/bin"
make
make install
make distclean

# libx264 
cd  ${SOURCE_DIR}
#git clone --depth 1 git://git.videolan.org/x264
cd x264
PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig" ./configure --prefix="${TARGET_DIR}" --bindir="${TARGET_DIR}/bin" --enable-static
make
make install
make distclean

# libx265
cd  ${SOURCE_DIR}
#hg clone https://bitbucket.org/multicoreware/x265
cd  ${SOURCE_DIR}/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${TARGET_DIR}" -DENABLE_SHARED:bool=off ../../source
make
make install

# yum install fontconfig.x86_64 fontconfig-devel.x86_64 fribidi-devel.x86_64 fribidi -y

cd  ${SOURCE_DIR}
#git clone https://github.com/libass/libass.git
cd libass
./autogen.sh
PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig" ./configure --prefix="${TARGET_DIR}"
make
make install

cd ${SOURCE_DIR}
#git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig" ./configure --prefix="${TARGET_DIR}" --disable-shared
make
make install
make distclean


cd  ${SOURCE_DIR}
#curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig" ./configure --prefix="${TARGET_DIR}" --bindir="${TARGET_DIR}/bin" --disable-shared --enable-nasm
make
make install
make distclean


cd ${SOURCE_DIR}
#curl http://downloads.xiph.org/releases/opus/opus-1.1.2.tar.gz -O opus-1.1.2.tar.gz
tar -zxvf opus-1.2.tar.gz
cd opus-1.2
autoreconf -fiv
PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig" ./configure --prefix="${TARGET_DIR}" --disable-shared
make
make install
make distclean

cd ${SOURCE_DIR}
#curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
cd libogg-1.3.2
PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig" ./configure --prefix="${TARGET_DIR}" --disable-shared
make
make install
make distclean



cd ${SOURCE_DIR}
#curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.5.tar.gz
cd libvorbis-1.3.5
PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig" LDFLAGS="-L${TARGET_DIR}/lib" CPPFLAGS="-I${TARGET_DIR}/include" ./configure --prefix="${TARGET_DIR}" --with-ogg="${TARGET_DIR}" --disable-shared
make
make install
make distclean

cd ${SOURCE_DIR}
#git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig" ./configure --prefix="${TARGET_DIR}" --disable-examples
make
make install
make clean

git config --global http.sslVerify false
cd ${SOURCE_DIR}
#git clone http://source.ffmpeg.org/git/ffmpeg.git
cd ffmpeg
PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig" ./configure --prefix="${TARGET_DIR}" --extra-cflags="-I${TARGET_DIR}/include" --extra-ldflags="-L${TARGET_DIR}/lib" --bindir="${TARGET_DIR}/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libass
make
make install
make distclean
hash -r

compile_ffmpeg.sh
=================
This script build the lastest ffmeg on Centos 6.x and 7x

Script Options
==============
```bash
TARGET_DIR=${DIR}/ffmpeg_build
SOURCE_DIR=${DIR}/ffmpeg_sources
```

**TARGET_DIR**:Is the output directory, binaries files will be placed here.
**SOURCE_DIR**:Source files will be downloaded in this directory.

There is no need to mention that you shouldhave enough space and permissions to save and run the files. 

Dependencies
============
In order to build ffmpef on centos you should install the following packcges

0. autoconf
0. automake
0. cmake
0. freetype-devel
0. gcc
0. gcc-c++
0. git
0. libtool
0. make
0. mercurial
0. nasm
0. pkgconfig
0. zlib-devel
0. yasm ( enable epel to have this ) 
0. fontconfig.x86_64 
0. fontconfig-devel.x86_64 
0. fribidi-devel.x86_64 
0. fribidi.x86_64

Installation

 
On CentOs Based systems:
```
yum install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel yasm;
```

On Ubuntu Systems:

ASM Note
========
Debian based system shout use NASM Repo AT: http://www.nasm.us/nasm.repo in order to compile new version of x264 


#!/bin/bash
ffmpeg -sub_charenc utf-8 -y -i  "$1"  "$2"
sed -i s/Arial,16/Arial,18/g "$2"

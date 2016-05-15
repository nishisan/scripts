#!/bin/bash
ffmpeg   -sub_charenc UTF-8 -y -i  "$1"  "$2"


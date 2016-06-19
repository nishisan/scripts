#!/bin/bash

# Mimic the output of
# mplayer -lavdopts vstats FILE -fps 30 -vo null
# Example usage:
# ./vstats.sh file.hevc 30

FFPROBE=ffprobe

fps=$2
# default 30 fps
: ${fps:=30}

frames=$3
# Numper of frames to process
: ${frames:=65536}

awk -v FPS="${fps}" -v FRAMES="${frames}" '
BEGIN{
    FS="="
}
/pkt_size/ {
  br=$2/1000.0*8*FPS
  if (br > max_br)
      max_br=br
  acc_br+=br
  acc_bytes+=br
  i+=1
  printf("frame= %6d, f_size= %7d, s_size= %8dkB, br= %8.1fkbits/s, avg_br= %8.1fkbits/s\n",
      i, $2, int(acc_bytes/1024+0.5), br, acc_br/i)

  if (i >= FRAMES)
      exit 
}
END {
    print "----"
    printf("Peak BR: %.1fkbits/s", max_br)
}
' <(${FFPROBE} -show_frames $1 2>/dev/null)

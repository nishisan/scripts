#!/bin/bash

spinner(){
    local pid=$1
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "[%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b"
    done
    printf "   \b\b\b"
    ETIME=$(($(date +%s%N)/1000000));
    TTIME=$(expr $ETIME - $STIME);
    debugLog "Total Time was ${TTIME} ms"
}

function errorLog(){
        CTIME=$(date  +"[%d/%m/%Y %T]");
	RED='\033[0;31m'
	REDNC='\033[0m' # No Color
	echo -e "[${RED}error${REDNC}] - ${CTIME} - [$@]"

}

function okLog(){
        CTIME=$(date  +"[%d/%m/%Y %T]");
        RED='\033[0;32m'
        REDNC='\033[0m' # No Color
        echo -e "[${RED}debug${REDNC}] - ${CTIME} - [$@]"
}

function debugLog(){
        CTIME=$(date  +"[%d/%m/%Y %T]");
        RED='\033[1;36m'
        REDNC='\033[0m' # No Color
        echo -e "[${RED}debug${REDNC}] - ${CTIME} - [$@]"
}


function evalCmd(){
	debugLog Running: $@
	STIME=$(($(date +%s%N)/1000000));
	($@ >> /tmp/run.log 2>&1 &  R=$! && spinner $R  )
}

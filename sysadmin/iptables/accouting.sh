#!/bin/bash
# @author: Lucas Nishimura
# run ONCE a Day
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
IFS=$'\n'  
for ENTRY in $(iptables -xnvL FORWARD) 
do
    if [[ "$ENTRY" =~ all ]]; then
	echo $ENTRY;
    fi
done

#!/bin/bash
case "$1" in
  -g)
        ifconfig | grep "inet addr" | awk '{print $2}' | awk -F: '{print $2}'
  ;;

  -i)
        ipcount=`ifconfig | grep "inet addr" | awk '{print $2}' | awk -F: '{print $2}' | wc -l`
        for i in `seq 1 $ipcount`; do
                echo $i;
        done
        exit $ipcount # this is the value at OID .1.3.6.1.4.1.2021.49.42.100.1
  ;;

  *)
    exit 254
  ;;
esac

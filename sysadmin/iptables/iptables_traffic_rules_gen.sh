#!/bin/bash

case "$1" in
  -f)
        iptables -F traffic_in;
        iptables -F traffic_out;
        ;;
esac

for ip in `/app/scripts/sysadmin/iptables/iptables_traffic_iplist.sh -g`; do
       iptables -vnL traffic_out | grep $ip >/dev/null || iptables -A traffic_out  -s $ip;
       iptables -vnL traffic_in | grep $ip >/dev/null || iptables -A traffic_in  -d $ip;
done

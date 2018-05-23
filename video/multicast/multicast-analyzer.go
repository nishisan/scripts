package main

import (
	"log"
	"log/syslog"
	"net"
)

const (
	maxDatagramSize = 8192
)

func main(){
	logger , err := syslog.New(syslog.LOG_ERR,"multicast-analyzer")
	defer logger.Close()
	if err != nil {
		log.Fatal("Error")
	}
	logger.Debug("Application Starting");
	addr, err := net.ResolveUDPAddr("udp", "239.232.41.11:5001")
	if err != nil {
		log.Fatal("Error Converting Address")
	}

	conn, err := net.ListenMulticastUDP("udp", nil, addr)
	if err != nil {
        log.Fatal("Error ListenMulticastUDP")
    }

	conn.SetReadBuffer(maxDatagramSize)
	for {
		buffer := make([]byte, maxDatagramSize)
		//numBytes, src, err := conn.ReadFromUDP(buffer)
		conn.ReadFromUDP(buffer)
		buffer = null
		//handler(src, numBytes, buffer)
	}
}

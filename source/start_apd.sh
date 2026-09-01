#!/bin/bash

stop_proc() {
	kill $1
	i=0
	while kill -0 $1; do
		if [ $i -lt 5 ]; then
			sleep 3
			i=$((i+1))
			continue
		else
			kill -9 $1
			break
		fi
	done
}

handle_sigint() {
	echo $HOSTAPD_PID
	echo $DNSMASQ_PID
	stop_proc $DNSMASQ_PID
	stop_proc $HOSTAPD_PID
	sudo iw dev wlan1 del
	rm -r /tmp/start_apd
	echo "成功退出"
	exit 0
}

WIRELESS_CARD=wlan0
MAC=$(ip link show dev $WIRELESS_CARD | awk '/link\/ether/ {print $2}' | awk -F: '{printf("%s:%s:%s:%s:%s:%s\n", $1, $2, $3, $4, $5, $6+1)}')
IP_ADDR_6="fd$(openssl rand -hex 1)$(openssl rand -hex 8 | sed 's/\(....\)/:\0/g')::1/64"
iw dev $WIRELESS_CARD interface add wlan1 type __ap addr $MAC
sleep 2
ip addr add dev wlan1 10.42.1.1/24
ip -6 addr add dev wlan1 $IP_ADDR_6
mkdir /tmp/start_apd
cp /etc/start_apd/2_4g.conf /tmp/start_apd
cp /etc/start_apd/5g.conf /tmp/start_apd
bash -c "cd /tmp/start_apd && /usr/libexec/start_apd/generate_conf $WIRELESS_CARD > hostapd.conf"
cp /tmp/start_apd/hostapd.conf /etc/hostapd/hostapd.conf
hostapd /etc/hostapd/hostapd.conf &
HOSTAPD_PID=$!
sleep 2
cp /etc/start_apd/dnsmasq.conf /etc/dnsmasq.conf
dnsmasq --no-daemon &
DNSMASQ_PID=$!
trap handle_sigint SIGINT
trap handle_sigint SIGTERM
wait $HOSTAPD_PID
wait $DNSMASQ_PID

#!/bin/sh

GW_MODE=/sys/class/net/bat%/mesh/gw_mode
GW_BANDWIDTH=/sys/class/net/bat%/mesh/gw_bandwidth

off() {
	for i in 0 {% for d in domains %}{{ d.id }} {% endfor %}; do
		echo off > $(echo $GW_MODE | sed "s_%_${i}_") || logger -p local3.error "batman gw mode failed: off"
	done
	systemctl stop isc-dhcp-server
}

on() {
	for i in 0 {% for d in domains %}{{ d.id }} {% endfor %}; do
		echo server > $(echo $GW_MODE | sed "s_%_${i}_") || logger -p local3.error "batman gw mode failed: server"
	done
	systemctl start isc-dhcp-server
}

# ensure that we announce the highest bandwidth
for i in 0 {% for d in domains %}{{ d.id }} {% endfor %}; do
	echo "96MBit/96MBit" > $(echo $GW_BANDWIDTH | sed "s_%_${i}_")
done

if [ "$1" = '--force-off' ]; then
	off
	exit 0
fi

# we assume that the mark and the routing table number are the same
mark=$(cat /etc/iproute2/rt_tables | grep freifunk | cut -d" " -f 1)
interface=$(ip route get 100.100.0.1 mark ${mark} 2>/dev/null | head -n 1 | sed 's_^.*dev \([^ ]*\).*$_\1_g')

if [ "$interface" = "" ]; then
	logger -p local3.error "no default route found in table freifunk. turning off batman gw mode"
	off
	exit
fi

if ping -q -I ${interface} 100.100.0.1 -c 4 -W 5 >/dev/null; then
	on
else
	logger -p local3.error "ping to 100.100.0.1 (anycast) dev $interface failed. turning off batman gw mode"
	off
fi

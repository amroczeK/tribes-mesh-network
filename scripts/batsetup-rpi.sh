#!/bin/sh

#set -x

# node variables
iface="wlan0"
node_ip="172.27.0.1/16"
node_lladr="02:12:34:56:78:9A"

# cluster variables
cluster_channel="1"
cluster_mtu="1532"
cluster_ssid="KLOG-AD-HOC"

exit_error() {
	echo "${0##*/}: ${1:-"unknown error"}" 1>&2
	exit 1
}

[ "$(id -u)" -ne 0 ] && exit_error "needs root privileges"

# load kernel module
modprobe batman-adv || exit_error "failed to load batman-adv module"

# configure wireless interface
ifconfig ${iface} down || exit_error "failed to bring down ${iface}"
ifconfig ${iface} mtu ${cluster_mtu}
iwconfig ${iface} ap ${node_lladr}
iwconfig ${iface} mode ad-hoc
iwconfig ${iface} channel ${cluster_channel}
iwconfig ${iface} essid ${cluster_ssid}
sleep 1s && ifconfig ${iface} up || exit_error "failed to bring up ${iface}"

# configure batman interface
ifconfig bat0 up || exit_error "failed to bring up batman interface"
batctl if add ${iface}
ifconfig bat0 ${node_ip}

exit 0

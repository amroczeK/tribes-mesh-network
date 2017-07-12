#! /bin/sh

# Activate batman-adv
sudo modprobe batman-adv

# Disable and configure wlan0
sudo ip link set wlan0 down
sudo ifconfig wlan0 mtu 1532
sudo iwconfig wlan0 mode ad-hoc
sudo iwconfig wlan0 essid KLOG-AD-HOC # Change this to whatever you like
sudo iwconfig wlan0 ap 02:12:34:56:78:9A
sudo iwconfig wlan0 channel 1
sleep 1s
sudo ip link set wlan0 up

#iwconfig wlan0 essid KLOG-AD-HOC # Uncomment this if you are using a Rasp Pi 1 and have issues with essid not being created

sleep 1s
sudo batctl if add wlan0
sleep 1s
sudo ifconfig bat0 up
sleep 5s

# Use different IPv4 addresses for each device
sudo ifconfig bat0 172.27.0.1/16

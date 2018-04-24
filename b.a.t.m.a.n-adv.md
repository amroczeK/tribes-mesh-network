# Digital Tribes - Ad-Hoc Mesh Network
Ad-Hoc Mesh Network using Raspberry Pi's for the Digital Tribes Hardware Challenge / Hackathon and is achieved by implementing the [B.A.T.M.A.N Advanced](https://www.open-mesh.org/projects/batman-adv/wiki/Wiki) routing protocol. This protocol operates on the data-link layer of the OSI model, the network nodes transmit broadcast messages to inform neighboring nodes about they're existence and the messages follow the best quality path. This means the messages route based on latency and link quality, it will avoid poor wireless or saturated links so the messages don't suffer from packetloss or delay.

This is the most suitable routing protocol for a mesh network, and was chosen as the final routing implementation for our project. It enables roaming nodes to easily connect to the network when in range, and B.A.T.M.A.N Advanced enables non-mesh devices to communicate over the mesh network with the implementation of an OpenWRT router and gateway.

## Hardware Requirements

1. 1x Raspberry Pi 1 B+ V1.2 (acting as Gateway Node)
2. 4x Raspberry Pi Zero (acting as Nodes)
3. TP-LINK WN725N 150Mbps Wireless N USB Nano Adapter (used by Raspberry Pi 1)
4. Data and OTG cables
5. Minimum 4gb microSD card (install Raspbian Jesse Lite)
6. microSD card Reader (used to flash Raspbian Jesse Lite)

## Software Requirements

1. Raspbian Jessie Lite disk image
2. Etcher to mount the image
3. SDFormatter to format the microSD card
4. PuTTy to SSH into the Raspberry Pi's

## Initial Setup
1. Setup Raspberry Pi to connect to WiFi & internet.
```
# Edit the interfaces
sudo nano /etc/network/interfaces

auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp # Use DHCP to be leased a random IP from the Router
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

# Edit wpa_supplicant and add your WiFi network details
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf

network={
  ssid="myssid"
  psk="mypassword"
  proto=WPA2
  key_mgmt=WPA-PSK
  pairwise=CCMP
  auth_alg=OPEN
}

# Restart the networking service to apply changes
sudo service networking restart
```

2. Test internet connectivity.
```
# Test connectivity
ping 8.8.8.8

# Force DHCP request if needed
sudo dhclient wlan0

```

3. Update and Upgrade Raspberry Pi before installations.
```
sudo apt-get update && sudo apt-get upgrade -y
```

4. Install git, libnl and batctl. Git will allow you to clone git repositries, the libnl suite is a collection of libraries providing APIs to netlink protocol based Linux kernel interfaces, and batctl is the configuration and debugging tool for batman-adv.
```
sudo apt-get install git
sudo apt install libnl-3-dev libnl-genl-3-dev
sudo git clone https://git.open-mesh.org/batctl.git

cd batctl
sudo make install
```

5. Disconnect from your WiFi network by returning the /etc/network/interfaces/ and /etc/wpa_supplicant/wpa_supplicant.conf files to default or commenting out the changes.

6. Create a file in /home/pi that will be used to run as a script and configure the mesh network on boot-up.
```
sudo nano batsetup-rpi.sh
```
Add the following lines to the script file.
```
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
batctl if add ${iface}
ifconfig bat0 up || exit_error "failed to bring up batman interface"
ifconfig bat0 ${node_ip}
```

### Simplified version
```
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
```

7. Give execute privileges to the script.
```
sudo chown root:wheel batsetup-rpi.sh
sudo chmod 700 batsetup-rpi.sh
```

8. Configure /etc/rc.local to run the script on startup.
```
sudo nano /etc/rc.local
```
Comment out the unused script and add batsetup-rpi.sh test to the last line.
```
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
#_IP=$(hostname -I) || true
#if [ "$_IP" ]; then
#  printf "My IP address is %s\n" "$_IP"
#fi

#exit 0

# Add the directory to your script
/home/pi/batsetup-rpi.sh &
```
Save changes and exit.

9. Reboot the Raspberry Pi.
```
sudo reboot
```

Now B.A.T.M.A.N Advanced and all it's dependencies should be installed and running after the reboot. Either manually repeat the procedure for every node, or clone the microSD as an image and flash it to the other nodes microSD. Make sure to configure the network address of the bat0 interface for every node.

NOTE: If devices don't ping immediately don't panic, give them some time to broadcast their presence to the other nodes.

## Test mesh network connectivity
```
sudo ifconfig bat0
sudo ifconfig wlan0
sudo iwconfig

sudo batctl o
sudo batctl ping

# Trace route to another device
sudo batctl traceroute 172.27.0.2
```

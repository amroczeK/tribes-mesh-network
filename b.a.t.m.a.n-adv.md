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
1. Setup Raspberry Pi to connect to WiFi & internet
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

2. Test internet connectivity
```
# Check if you have been leased an IP address
sudo ifconfig wlan0

# If the interface appears to be down do the following
sudo ifconfig wlan0 up

# If you still aren't being leased an IP address, check your router configuration and reboot pi
sudo reboot

# Test connectivity
ping 8.8.8.8
```

3. Update and Upgrade Raspberry Pi before installations
```
sudo apt-get update
sudo apt-get upgrade
```

4. Install git, libnl and batctl. Git will allow you to clone git repositries, the libnl suite is a collection of libraries providing APIs to netlink protocol based Linux kernel interfaces, and batctl is the configuration and debugging tool for batman-adv.
```
sudo apt-get install git
sudo apt install libnl-3-dev libnl-genl-3-dev
sudo git clone https://git.open-mesh.org/batctl.git

cd batctl
sudo make install
```

5. Configure batman-adv to start automatically on boot up

Edit /etc/modules
```
sudo nano /etc/modules
```

Add "batman-adv" onto a new line in the /etc/modules file
```
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines begining with '#' are ignored.

batman-adv
```

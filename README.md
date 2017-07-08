# Digital Tribes - Ad-Hoc Mesh Network
Ad-Hoc Mesh Network using Raspberry Pi's for the Digital Tribes Hardware Challenge / Hackathon and is achieved by implementing [HSMM-Pi](https://github.com/urlgrey/hsmm-pi/blob/master/README.md).

<p align="center"><img width=100%% src="https://github.com/amroczeK/tribes-mesh-network/blob/master/images/HSMM.PNG"></p>

## Hardware Requirements

1. 1x Raspberry Pi 1 B+ V1.2 (acting as Gateway Node)
2. 4x Raspberry Pi Zero (acting as Nodes)
3. TP-LINK WN725N 150Mbps Wireless N USB Nano Adapter (used by Raspberry Pi 1)
4. Data and OTG cables
5. Minimum 4gb microSD card
6. microSD card Reader

## Software Requirements

1. Raspbian Jessie Lite disk image
2. Etcher to mount the image
3. SDFormatter to format the microSD card
4. PuTTy to SSH into the Raspberry Pi's

## Initial Setup
1. Setup Raspberry Pi to connect to WiFi & internet
```
sudo nano /etc/network/interfaces

auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
    address 192.168.1.106 # IP for the Zero
    netmask 255.255.255.0
    gateway 192.168.1.1 # Your router IP
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

sudo nano /etc/wpa_supplicant/wpa_supplicant.conf

network={
  ssid="myssid"
  psk="mypassword"
  proto=WPA2
  key_mgmt=WPA-PSK
  pairwise=CCMP
  auth_alg=OPEN
}

sudo service networking restart
```

2. Run the following commands to download the HSMM-Pi project and install
```
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/urlgrey/hsmm-pi.git
cd hsmm-pi
sh install.sh
```

3. Login to the web application on through a browser on: http://(wired Ethernet IP of the node):8080/
```
Initial login details:
Username: admin
Password: changeme
```

4. Configure the Network settings for the Gateway Node within the HSMM-Pi web interface
```
### Network Settings
#### WiFi
Adapter Name: wlan0
IP Address: 10.201.5.1
Netmask: 255.0.0.0
SSID: HSMM-MESH
Channel: 1

### Wired
Adapter Name: eth0
Wires interface mode: WAN
Protocol: DHCP
DNS 1: 8.8.8.8
DNS 2: 8.8.4.4
Tick box: WAN port is always on (periodic testing of Internet connectivity is unnecessary)

### Mesh (Leave this default as below)
Node Name: RPi-GW-01
Tick box: OLSRD Secure
OLSRD Secure Key: FFFFFFFFFFFFFFFF

### Time (Leave this default as below)
Network Time Server: ntp.ubuntu.com
```

5. 

## Syncing Files between Raspberry Pi's
```bash
rsync -azP ~/rsync/src/ pi@10.201.5.1:~/rsync/dest
```
Note: Ignore the strike through the code, this is caused by "~".

## References

1. https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=62371

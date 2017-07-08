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

1. Run the following commands to download the HSMM-Pi project and install
```
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/urlgrey/hsmm-pi.git
cd hsmm-pi
sh install.sh
```


## Syncing Files between Raspberry Pi's
```bash
rsync -azP ~/rsync/src/ pi@10.201.5.1:~/rsync/dest
```
Note: Ignore the strike through the code, this is caused by "~".

## References

1. https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=62371

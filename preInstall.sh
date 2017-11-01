#!/bin/bash
chown -R root:root *.mod 
chown -R root:root *.sh
apt-get --yes install cryptsetup lvm2 busybox vim git
# curl -L https://install.pivpn.io | bash
# apt-get -y install ddclient
# apt-get -y install dropbear

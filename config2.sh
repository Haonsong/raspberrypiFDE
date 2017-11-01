#!/bin/bash

apt-get -y install dropbear
ssh-keygen -t rsa -b 2048 -N '' -f id_rsa

mkdir /etc/initramfs-tools/root
mkdir /etc/initramfs-tools/root/.ssh

# Add publickey to authorized_keys
cat id_rsa.pub > /etc/dropbear-initramfs/authorized_keys
echo command="/scripts/local-top/cryptroot && kill -9 `ps | grep -m 1 'cryptroot' | cut -d ' ' -f 3` && exit" `cat id_rsa.pub` > /etc/initramfs-tools/root/.ssh/authorized_keys

#Add new script to initramfs
mv /usr/share/initramfs-tools/scripts/init-premount/dropbear dropbear.back
cp dropbear.mod /usr/share/initramfs-tools/scripts/init-premount/dropbear 

# Regenerate initramfs
sudo mkinitramfs -o /boot/initramfs.gz

# Note current ip
ifconfig

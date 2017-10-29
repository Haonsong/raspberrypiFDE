#!/bin/sh

#Modify boot option
echo initramfs initramfs.gz followkernel >> /boot/config.txt
mv /boot/cmdline.txt cmdline.txt.back
cp cmdline.txt.mod /boot/cmdline.txt

#Modify fstab
# echo /dev/mapper/crypt  /               ext4    defaults,noatime  0       1 >> /etc/fstab
mv /etc/fstab fstab.backup
cp fstab.mod /etc/fstab

#Modify the Cryttab
echo -e 'crypt\t/dev/mmcblk0p2\tnone\tluks' >> /etc/crypttab

#Generate a fake encryted disk to setup the initramfs
dd if=/dev/zero of=/tmp/fakeroot.img bs=1M count=20

#Encryt the fake disk with random passwor
cryptsetup luksFormat /tmp/fakeroot.img << !
YES
!

#Unlock the fake disk with the password
cryptsetup luksOpen /tmp/fakerook.img crypt << !
YES
!
#### How to input multiple different input to a command??? ###

#Creat the disk mapping
mkfs.ext4 /dev/mapper/crypt

#Update teh initramfs
mkinitramfs -o /boot/initramfs.gz

#Double check the module in the initramfs
lsinitramfs /boot/initramfs.gz | grep cryptsetup 
echo FINISHED! Unplug the Pi and formatting ur root partition with your PC

#!/bin/bash
echo initramfs initramfs.gz followkernel >> /boot/config.txt
mv /boot/cmdline.txt cmdline.txt.back
cp cmdline.txt.mod /boot/cmdline.txt

# echo /dev/mapper/crypt  /               ext4    defaults,noatime  0       1 >> /etc/fstab
mv /etc/fstab fstab.backup
cp fstab.mod /etc/fstab

echo -e 'crypt\t/dev/mmcblk0p2\tnone\tluks' >> /etc/crypttab

dd if=/dev/zero of=/tmp/fakeroot.img bs=1M count=20
cryptsetup luksFormat /tmp/fakeroot.img << !
YES
!

cryptsetup luksOpen /tmp/fakeroot.img crypt << !
YES
!

mkfs.ext4 /dev/mapper/crypt
mkinitramfs -o /boot/initramfs.gz
lsinitramfs /boot/initramfs.gz | grep cryptsetup 
echo Encrytion Finished!

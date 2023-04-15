#!/bin/bash

echo usage: changeroot rootdev bootdev
echo example: changeroot sda2 sda1
if [ -z "$1" ]; then
    exit 1
fi
if [ -z "$2" ]; then
    exit 1
fi

echo mounting /dev/$1
if ! [ -d "/mnt/$1" ]; then
    mkdir /mnt/$1 -p
fi

mount /dev/$1 /mnt/$1

echo "mounting boot (/dev/$2) on /mnt/$1/boot"
if ! [ -d "/mnt/$2" ]; then
    mkdir /mnt/$2 -p
fi

mount /dev/$2 /mnt/$1/boot

echo mounting proc into jail
mount /proc /mnt/$1/proc -t proc -o bind
echo mounting sys into jail
mount /sys /mnt/$1/sys -t sysfs -o bind
echo mounting dev into jail
mount /dev /mnt/$1/dev -o bind

echo Jailing...
chroot /mnt/$1 /bin/bash

echo Unmounting all filesystem
umount /mnt/$1/proc
umount /mnt/$1/sys
umount /mnt/$1/dev
umount /mnt/$1/boot
umount /mnt/$1

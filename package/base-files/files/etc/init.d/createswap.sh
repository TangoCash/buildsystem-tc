#!/bin/sh

device1=$(blkid -t  PARTLABEL="swap" -o device | head -n1)
swap1=$(cat /proc/swaps | grep -o "/dev/block/by-name/swap" | head -n1)

if [ "$device1" == "" ]; then
	echo "  Sorry, no swap drive found"
	exit 1
fi

grep -q "/dev/block/by-name/swap" /etc/fstab

if [ $? -ne 0 ]; then
	mkswap /dev/block/by-name/swap
	swapon /dev/block/by-name/swap
	echo '/dev/block/by-name/swap none swap defaults 0 0' >> /etc/fstab
elif [ "$swap1" == "" ]; then
	mkswap /dev/block/by-name/swap
	swapon /dev/block/by-name/swap
fi
